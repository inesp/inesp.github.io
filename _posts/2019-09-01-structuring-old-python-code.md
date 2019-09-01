---
title: Structuring old Python code
biblio:
  - title: "MyPy"
    link: "http://mypy-lang.org/"
---

Every project inevitably gravitates towards messy code. As long as you are adding features to a project, you can be pretty sure its total "messiness" is not decreasing. Developers are notoriously bad at removing features, there is only ever going to be more logic and in Python, this means more dictionaries and more tuples being passed around. While we may not be able to win in the long run, we surely can fight it for a long time.


## The ZOO of configs

Just last week I had to modify some old code in which (for some phantom reason) half of the variables were named with some conjugation of `config`. 

Let me illustrate the extent of the "configs". All names below have been changed to be Zoo-themed :box:.

There was a `ZOOsConfigBuilder`, which had a function called `get_config`, which returned a dictionary of dictionaries and inside the 2nd-level dicts was a key called `get_config`, which built a partial function, which would then eventually be called somewhere completely different with 2 parameters. Imagine this for a second, somewhere there was code like this: `zoos_config["paris"]["get_config"]("Mrs Zoo Keeper", 130)` and this worked correctly.

Accompanying repo: [GitHub - Structuring old Python code](https://github.com/inesp/blog-structuring-old-python/commits){:target="_blank"}
{:.box}

```python

# ----------- File zoos_config_builder.py -----------------

from functools import partial

class ZOOsConfigBuilder:

    ...

    def get_config(self):
        return {
            "paris": {
                "is_open_to_public": True,
                "get_config": self:_build_paris_config(["girrafe", "lion", "ape"]),
            },
            "vienna": {
                "is_open_to_public": True,
                "get_config": self._build_vienna_config(["elephant", "tucan"]),
            },
            ....
        }

    def _build_paris_config(animal_types):
        def _get_config(owner, zoo_size):
            animals = create_animals(animal_types):
            return {
                "owner": owner,
                "zoo_size": zoo_size,
                "animals": animals,
                "most_popular_animal": "giraffe",
            }
        
        return _get_config

    def _build_vienna_config(animal_types):
        def _get_config(owner, zoo_size):
            animals = create_animals(animal_types + ["pelican"]):
            return {
                "owner": owner,
                "zoo_size": zoo_size,
                "animals": animals,
                "free_entrance_day": "friday",
            }
        
        return _get_config


# ---------- city.py ----------------------

class City:

    name = "vienna"
    ...

    def create_zoo(self, owner):
        zoo_configs = ZOOsConfigBuilder().get_config()
        
        config = zoo_configs.get(self.name)
        if not config or not config.get("is_open_to_public"):
            return None

        return Zoo(config["get_config"](owner, 130))

# ---------- zoo.py ----------------------

class Zoo:

    def __init__(zoo_config):
        self.owner_name = zoo_config["owner"]
        ...
```

Were you able to follow the flow of the `configs`? :) Firstly, I must emphasize, the code worked marvellously, it was in production for a long time already, it ran successfully for all of our customers and had just a few bugs in the years it was out. But...code written like this is meant for 1 developer. Onboarding a new developer to this code was expensive. Especially, because in reality, it wasn't dealing with zoos and animals, but with credentials and configurations of integrated services.

This kind of beautiful, but unstructured and tightly entwined code often triggers the overly optimistic "let's rewrite everything"-reflex.

{% include image.html 
    alt="Life of a Software Engineer" 
    src="structuring-do-it-right.png" 
    ref="http://bonkersworld.net/building-software" %}

But in fact, if a huge code-base looks as neat at the picture on the right, everybody (including Product, Management and Sales) have done an awesome job at keeping messiness at bay.

## Turn knowledge into code

Before I could extend the above code with new functionality, I needed to read it, I needed to understand it. But once I read it, I had knowledge about the code's intention, about the invisible ways functions and classes depend on each other. But since memory is like a leaking bucket, all this knowledge will be lost again soon. 

## Take advantage of Python 3 features

A clever new Python 3 feature are `dataclasses`. They are a simple, but powerful way to define a composite type, a structure. Together with type hinting, you can improve the expressiveness of any old or new Python code.

The above `ZOOsConfigBuilder:get_config` returns a `dict` with sub-`dicts`, which all have the same structure:

```python
from dataclasses import dataclass
from typing import Callable, Dict

TZooOwnerName = str
TZooSize = int

@dataclass
class ZooConfiguration:
    is_open_to_public: bool
    get_config: Callable[[TZooOwnerName, TZooSize], Dict]

```

Once we have this, we can change `ZOOsConfigBuilder` to return a dict of `ZooConfiguration` objects. And while we are at it, we should append an `s` to the end of the function name. It does, after all, return many configurations, not only one. And let's also define the return type.

```python
TCityName = str

class ZOOsConfigBuilder:

    def get_configs(self) -> Dict[TCityName, ZooConfiguration]:
        return {
            "paris": ZooConfiguration(
                is_open_to_public=True,
                get_config=self:_build_paris_config(["girrafe", "lion", "ape"]),
            ),
            "vienna": ZooConfiguration(
                is_open_to_public=True,
                get_config=self._build_vienna_config(["elephant", "tucan"]),
            ),
            ....
        }
```

With this small change the `City` code becomes less random:

```python
class City:

    # 1. add type hints, here we see that name shouldn't* be None
    name: str = "vienna"

    # 2. add more type hints
    def create_zoo(self, owner: str) -> Optional[Zoo]:
        zoo_configs: Dict[
            str, ZooConfiguration
        ] = ZOOsConfigBuilder().get_configs()
        
        config = zoo_configs.get(self.name)

        # 3. we know that config is now either None 
        # or a ZooConfiguration instance. If it is 
        # a ZooConfiguration, then we call its property
        # is_open_to_public, which must return a True/False.
        if not config or not config.is_open_to_public:
            # 4. here we are reminded, that the result 
            # of this function can be a None as well as 
            # a Zoo instance.
            return None
        
        # 5. here we know that config is a ZooConfiguration instance
        # we know that it has a Callable variable called `get_config`
        # and that this Callable accepts 2 parameters: 
        #   - a string, zoo owner 
        #   - an integer, zoo size
        zoo_config: Dict[str, Any] = config.get_config(owner, 130)
        return Zoo(zoo_config)

```


***NOTE**: Python doesn't enforce any of your type hints. To enforce type hints, you must rely on MyPy or another hint checker.*

## Dataclasses are everywhere

Once you start defining dataclasses, you quickly see that soo many things are in fact semi-rigid structures just waiting to be uncovered.

Look at the `Zoo` class, we instantiate the class with an unstructured dictionary. How do we know what to put into the dictionary, if we decide to create a `Zoo` for a new `City`? The only way to know is to look at `Zoo`'s source code. This way we find a lot of implicit rules:

```python
from datetime import date
from models import Person

class Zoo:
    def __init__(zoo_config):
        self._owner_name = zoo_config["owner"]
        # 1. owner appears to be mandatory, it is actually the owner's name
        self._free_entrance_day = zoo_confi.get("free_entrance_day", "Monday")
        # 2. free_entrance_day is not mandatory, it must be the english name
        # for a week day, can I set it to None in zoo_config or will this 
        # cause a problem later?
        ...

    ...

    def owner(self):
      return Person.query.filter(Person.name == self._owner_name).one_or_none()
      # 3. aha, this line will raise an error if I use the wrong letter case or
      # trailing spaces for the owner
    
    def is_entrance_free(self):
      today = datetime.today().strftime('%A')
      return today == self._free_entrance_day
      # 4. aha, the entrance_day must be in the strftime format %A

   ... 
```

We can transform the above comments into a quick in-line tech-spec and save our co-team-members and all future developers some time. As they say, it is easier to reach high, if you are standing on the shoulders of giants.

```python
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Optional

from datetime import date
from models import Animal, Person

# 1. We define an Enum of possible weekday names
class WeekDay(Enum):
    MON = "Monday"
    WED = "Wednesday"
    FRI = "Friday"


# 2. We collect all key-value pairs from all _get_config functions
# and define a ZooInfo dataclass with type hints and default values.
@dataclass
class ZooOutline:
    owner_name: str
    size: int
    animals: List[Animal]

    free_entrance_day: WeekDay = field(default=WeekDay.MON)
    # As you can see this field is not meant to be None, it was
    # not marked as Optional. It does not, however, need to be
    # specified. It will default to Monday.
    
    most_popular_animal: Optional[Animal] = None

```

Now we change the `Zoo` class:

```python
class Zoo:
    def __init__(zoo_outline: ZooOutline):
        self._owner_name: str = zoo_outline.owner_name
        # TODO: It would be great to replace self._owner_name with
        # reference to an actual Person model instance from the database.
        # We probably get the owner name by fetching the owner person
        # from the database.
        # But this might be too invasive.
        self._free_entrance_day = zoo_outline.free_entrance_day.value
        # zoo_outline.free_entrance_day is an Enum, thus we call .value
        ...

    ...
    
```

This now also changes the code of `ZOOsConfigBuilder`. 

```python

class ZOOsConfigBuilder:

    def _build_paris_config(animal_types):
        def _get_config(owner: str, zoo_size: int) -> ZooOutline:
            animals: List[Animal] = create_animals(animal_types)
            return ZooOutline(
                # I also had to rename owner to owner_name and
                # because I am now instantiating a class
                # PyCharm automatically underlines the old
                # `owner` key name until I change it to 
                # `owner_name`
                owner_name=owner,
                size=zoo_size,
                animals=animals.values(),
                most_popular_animal=get_favorite_animal(...),
            )
        
        return _get_config

    def _build_vienna_config(animal_types: List[str]):
        def _get_config(owner: str, zoo_size: int) -> ZooOutline:
            animals: List[Animal] = create_animals(animal_types):
            return ZooOutline(
                owne_namer=owner,
                size=zoo_size,
                animals=animals,
                free_entrance_day=WeekDay.FRI,
            )
        
        return _get_config

```
Because I am using dataclasses instead of raw dicts, I can take advantage of tools like PyCharm and MyPy, which alert me of typos in parameter names and of type mismatchings. By using structure, where it is needed, I can effectively prevent bugs.

And now the `City` can change to:

```python
class City:

    name: str = "vienna"

    def create_zoo(self, owner_name: str) -> Optional[Zoo]:
        zoo_configs: Dict[
            str, ZooConfiguration
        ] = ZOOsConfigBuilder().get_configs()
        
        config = zoo_configs.get(self.name)

        if not config or not config.is_open_to_public:
            return None
        
        zoo_outline: ZooOutline = config.get_config(owner_name, size=130)
        return Zoo(zoo_outline)
```

We still haven't solved the problem of too many `config` uses. 

Now that we have named our second data class `ZooOutline`, we can go back and rename the `_get_config` functions and all its references to `_get_outline`. 

We might want to squash the 2 levels of configs into 1 level. What do we gain by having `is_open_to_public` outside the actual `ZooOutline` anyway? But actions of this size are often too destructive. As step 1, it is good that we have replaced the unstructured dictionaries with structured dataclasses. It is easier to scale a team and a project if we are passing structures between functions instead of dictionaries of unknown content.

To see the above transformation in action, take a look at the accompanying GitHub repository:

{% include image.html alt="Accompanying repo" src="structuring-repo-link.png" link="https://github.com/inesp/blog-structuring-old-python/commits/master" %}
