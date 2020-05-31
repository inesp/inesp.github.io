---
title: Cheat Sheet of Python Mock
biblio:
  - title: "Python docs: mock object library"
    link: "https://docs.python.org/3/library/unittest.mock.html"
---

I always wanted to have this. The cool part of me, of course, wanted *me* to be the one who writes it, the pragmatic part just wanted to have access to a list like this and the hedonic part of me made me ignore the whole topic by telling me to chase after greater pleasures of life, at least greater than this blog post, no matter how magnificent it might eventually become, could ever be. But here I am, some years later, in the wrath of the epidemic lockdown, re-running Python tests in an infinite loop until I figure out which nobs and settings of this `mock` library I have to turn and set to get it to mock the damn remote calls.

The situation makes you wonder. Did it have to take a nationwide lockdown for me to start composing this list? Is it the dullness of the `mock` library that is the problem? Or is the culprit just a general aversion to spending any more time on tests than absolutely necessary? .. Who knows. But here we are, so let's get on with it.

`mock` is a great library. There are people out there, who are absolutely against `mock` and who will tell you that you should not mock anything ever. You should handle their stance just like you would the stance of any other absolutist: don't trust them. Writing tests is less about who has the moral upper ground and more about preventing bugs.

## Level 1: Creating a new Mock object

First, let's see what all the ways are we can create and configure a `Mock` object.


<table class="table table-sm table-code">
<thead>
  <tr>
    <th colspan="3" class="">Attribute/Function we wish to mock</th>
  </tr>
  <tr>
    <th class="">&nbsp;</th>
    <th class="">Possible Mock objects</th>
    <th class="border-left">Result of calling attr/func on Mock</th>
  </tr>
</thead>
<tbody>
  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">bool(book)</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()</td>
    <td class="align-middle border-left">True</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = None</td>
    <td class="align-middle border-left">False</td>
  </tr>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">book.title</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock(title="Russian Literature")</td>
    <td class="align-middle border-left">"Russian Literature"</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock(title="")</td>
    <td class="align-middle border-left">""</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()</td>
    <td class="align-middle border-left">&lt;Mock name='mock.title' id='14039307'&gt;</td>
  </tr>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">book.author.first_name</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock(author=Mock(first_name="Tatjana"))</td>
    <td class="align-middle border-left">"Tatjana"</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()<br>
        book.author.first_name = "Evgenij"
    </td>
    <td class="align-middle border-left">"Evgenij"</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()</td>
    <td class="align-middle border-left">&lt;Mock name='mock.author.first_name' id='140393072216336'&gt;</td>
  </tr>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">book.author.get_full_name()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()<br>
        book.author.get_full_name.return_value = ""
    </td>
    <td class="align-middle border-left">""</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock(<br/>
&nbsp;author=Mock(<br />
&nbsp;&nbsp;get_full_name=Mock(return_value="Aleksandr Pushkin")<br />
&nbsp;)<br />
)</td>
    <td class="align-middle border-left">"Aleksandr Pushkin"</td>
  </tr>


</tbody>
</table>

&#x26A0; One special situation is the parameter `name`. The `Mock` class has a few input arguments, most of them (like `return_value`) are easy to remember. But then there is `name`, which nobody ever remembers. Add to this the fact that practically every class in the computer world has either a `title` or a `name` attribute and you have got yourself a perfect programmer trap.


<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">author.name</td>
  </tr>
  <tr>
    <td>&#x2764;</td>
    <td>author = Mock()<br />author.name="Pushkin"</td>
    <td class="align-middle border-left">"Pushkin" &#x2764;
    </td>
  </tr>
  <tr>
    <td>&#128128;</td>
    <td>author = Mock(name="Pushkin")</td>
    <td class="align-middle border-left">&lt;Mock name='Pushkin.name' id='140504918800992'&gt; &#128128;</td>
  </tr>
</tbody>
</table>


Next to `Mock` there is also `MagicMock`. `MagicMock` can do all the same things that `Mock` can do, but it can do a smidgen more. `MagicMock` has some dunder (or magic) methods already defined: `__lt__`, `__gt__`, `__int__`, `__len__`, `__iter__`, ... . This means we can do this: `len(MagicMock())` and receive `0`. Or this: `float(MagicMock())` and receive `1.0`. Or this: `MagicMock()[1]` and receive a new `MagicMock` object.

#### Implicitly creating sub-`Mock`s

When we are mocking a deeply nested attribute, we don't need to explicitly create sub-`Mock`s at every level. As soon as we access an attribute/function/property, a new `Mock` will automatically be created, if none exists. And because calling the same attribute will return the same sub-`Mock` every time, we can use this to our advantage and simply say `mock_object.author.country().title = "Lichtenstein"` instead of `mock_object.author = Mock(country=Mock(return_value=...))`. But the rule of thumb is that the path must consist solely of functions and attributes. The `MagicMock` can handle a few more things in the path, like `[0]`.

Examples of paths thatare ok:
{:.mb-0}
- `book.get_review(sort="date", order="desc").reviewer.get_country().short_name`
- `book()()()`

As soon as a non-function comes along, we get an `Exception`. These paths are not ok:
{:.mb-0}
- `book.reviews[0]`
- `len(book.reviews)`
- `book.year > 1950`


<table class="table table-sm table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">book.data["reviews"][0].reviewer.date</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
book = <b>Mock</b>(<br>
&nbsp;&nbsp;data={<br>
&nbsp;&nbsp;&nbsp;&nbsp;"reviews":[<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mock(reviewer=Mock(<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;date=datetime.now()<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;))<br>
&nbsp;&nbsp;&nbsp;&nbsp;]<br>
&nbsp;&nbsp;}<br>
)
    </td>
    <td class="align-middle border-left">datetime.datetime(2020, 5, 17, ....)</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = Mock()</td>
    <td class="align-middle border-left">
      TypeError: 'Mock' object is not subscriptable
      <p>The problem is with the '["reviews"]'-part.</p>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = <b>MagicMock()</b></td>
    <td class="align-middle border-left">&lt;MagicMock<br> name='mock.data.__getitem__().__getitem__().reviewer.date'<br>id='14050491'&gt;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = <b>MagicMock()</b><br>
    book.data["reviews"][0].reviewer.date = datetime.now()</td>
    <td class="align-middle border-left">datetime.datetime(2020, 5, 17, ....)</td>
  </tr>


  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">len(book.data["reviews"])</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>book = MagicMock()<br>book.data["reviews"].__len__.return_value = 120</td>
    <td class="align-middle border-left">120</td>
  </tr>

</tbody>
</table>


<table class="table table-sm table-code">
<tbody>
    <tr class="title-row-tr">
      <td colspan="3" class="title-row-td">
        book.get_review(type="oldest").reviewer.get("name", "unknown")
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        book = Mock()<br>
        book.get_review.return_value.reviewer = {"name": "Natalia"}
      </td>
      <td class="align-middle border-left">"Natalia"</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>book = Mock()<br>book.get_review.return_value.reviewer = {}</td>
      <td class="align-middle border-left">"unknown"</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>book = Mock(<br>
&nbsp;&nbsp;**{"get_review.return_value.reviewer": {}}<br>
)</td>
      <td class="align-middle border-left">"unknown"</td>
    </tr>


    <tr class="title-row-tr">
      <td colspan="3" class="title-row-td">
        book.all_reviews[-1].get_country(locale="en").reviewer.get("name")
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        book = MagicMock()<br>
        book.all_reviews[-1].get_country(locale="en").reviewer = {"name": "Natalia"}
      </td>
      <td class="align-middle border-left">"Natalia"</td>
    </tr>

</tbody>
</table>

If you don't know the exact path you have to take to get to the value you wish to mock, just create a `Mock()` object, call the attribute/function and print out the mocked value, that is produced.

Let's say I have: `a.b(c, d).e.f.g().h()`. When I create `a = Mock()` and call the previous code I receive this `Mock` object: `<Mock name='mock.b().e.f.g().h()' id='14050'>`. This tells me the exact path I have to mock. I copy the path and just replace every `()` with `.return_value` and get:  `a.b.return_value.e.f.g.return_value.h.return_value = "My Result"`.

## Level 2: Missing attributes

<table class="table table-sm table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      item.slug -> should raise AttributeError
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      book = Mock(<b>spec=[]</b>)
    </td>
    <td class="align-middle border-left">AttributeError: Mock object has no attribute 'slug'</td>
  </tr>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td">
      getattr(item, "slug", None) or getattr(item, "uid", None)
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      item = Mock(uid="12345", <b>spec=["uid"]</b>)
      <p>Making sure there is no 'slug' attribute.</p>
    </td>
    <td class="align-middle border-left">"12345"</td>
  </tr>

</tbody>
</table>

What if we have a common utility function, which extracts the correct title from any object. It might look like this:
```python
def extract_title(item: Union[Book, Author, Review]) -> str:
  if isinstance(item, Book):
    return item.title

  if hasattr(item, "get_full_title"):
    return item.get_full_title()

  if hasattr(item, "summary"):
    return item.summary

  raise Exception("Don't know how to get title")

# ---- models: ---------------

@dataclass
class Book:
  title: str

class Author:
  def get_full_title() -> str:
    pass

class Review:
  @property
  def summary() -> str:
    pass
```

To test `extract_title` with objects mocking all 3 classes (`Book`, `Author`, `Review`), we can resort to `Mock`'s `spec` attribute. `spec` can be a list of attributes as shown above or it can be a **class** or a class **instance** or anything really as long as `Mock` can call `dir(spec_obj)` on it.

Calling `Mock(spec=Author)` is the same as:
`Mock(spec=[attr for attr in dir(Author) if not attr.startswith("__")]`. If we try to access any attribute not on the spec-list, an `AttributeError` is raised.

<table class="table table-sm table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      extract_title(item)
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      default_mock_obj = Mock()
    </td>
    <td class="align-middle border-left">
      Will alwas return True for <code>hasattr(item, "get_full_title")</code>:<br>
      &lt;Mock name='mock.get_full_title()' id='1405'&gt;
    </td>
  </tr>

  <tr class="top-border">
    <td>&nbsp;</td>
    <td>
      mock_book = Mock(<b>spec=Book("")</b>)
    </td>
    <td class="align-middle border-left">
      &lt;Mock name='mock.title' id='140504'&gt;
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      mock_book = Mock(<br>
&nbsp;&nbsp;spec=Book(""),<br>
&nbsp;&nbsp;title="Russian Literature"<br>
)
    </td>
    <td class="align-middle border-left">"Russian Literature"</td>
  </tr>


  <tr class="top-border">
    <td>&nbsp;</td>
    <td>
      mock_author = Mock(<b>spec=Author</b>)
    </td>
    <td class="align-middle border-left">
      &lt;Mock name='mock.get_full_title()' id='14050'&gt;
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      mock_book = Mock(spec=Author)<br>
mock_author.get_full_title.return_value = "Aleksandr Pushkin"
    </td>
    <td class="align-middle border-left">"Aleksandr Pushkin"</td>
  </tr>


  <tr class="top-border">
    <td>&nbsp;</td>
    <td>
      mock_review = Mock(<b>spec=Review</b>)
    </td>
    <td class="align-middle border-left">
      &lt;Mock name='mock.summary' id='14050'&gt;
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      mock_review = Mock(spec=Review)<br>
mock_review.summary = "Oh, bitter destiny"
    </td>
    <td class="align-middle border-left">"Oh, bitter destiny"</td>
  </tr>

</tbody>
</table>


## Level 3: The attribute with the very unfortunate name - `side_effect`

Every `Mock` object can be instantiated with a `side_effect` attribute. This attribute is useful in 3 types of situations and only one of them can honestly be called a side effect. Unfortunately, the lamentable name makes developers miss how versatile and convenient its underlying functionality actually is.

#### `side_effect` as an iterator

We have a remote call to Slack where we fetch all channels of some Slack workspace. But Slack's API is in its Nth version and has thus the annoying, but very sensible, limitation built-in which permits us to only fetch 100 channels at a time. To get the 101st channel we have to make a new GET request with the pagination cursor we received in the last request. Here is the code:

```python
def fetch_one_page_of_slack_channels(cursor=None):
  ....<channels: List[str]>....
  return channels, next_page_cursor

def fetch_all_slack_channels():
  all_channels: List[str] = []
  fetched_all_pages = False
  cursor = None
  while not fetched_all_pages:
    new_channels, cursor = fetch_one_page_of_slack_channels(cursor)
    all_channels.extend(new_channels)
    fetched_all_pages = bool(cursor is None)

  return all_channels
```

Now we want a test making sure that `fetched_all_pages` doesn't stop after the first page.


<table class="table table-sm table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      fetch_all_slack_channels()
    </td>
  </tr>
  <tr>
    <td class="border-bottom-0">&nbsp;</td>
    <td class="border-bottom-0">
      fetch_one_page_of_slack_channels = Mock()
    </td>
    <td class="align-middle border-left border-bottom-0">

      TypeError: cannot unpack non-iterable Mock object
    </td>
  </tr>
  <tr>
    <td class="border-top-0"></td>
    <td colspan="2" class="border-top-0">
      <p>Explanation: <code>Mock</code> will return a new <code>Mock</code> object for every call, but 1 <code>Mock</code> cannot be unpacked into 2 items: <code>new_channels</code> and <code>cursor</code>:<br>
      <code>
      ---->   new_channels, cursor = fetch_one_page_of_slack_channels(cursor)
      </code></p>
    </td>
  </tr>

  <tr>
    <td>&nbsp;</td>
    <td>fetch_one_page_of_slack_channels = Mock(<br>
&nbsp;&nbsp;side_effect=<b>[</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;(["channel_1","channel_2"],&nbsp;"__NEXT__PAGE__"),<br>
&nbsp;&nbsp;&nbsp;&nbsp;(["channel_3"],&nbsp;None),<br>
&nbsp;&nbsp;<b>]</b>)
    </td>
    <td class="align-middle border-left">
      ['channel_1', 'channel_2', 'channel_3']
    </td>
  </tr>

</tbody>
</table>


#### `side_effect` as an Exception

This one is for testing Exception-handling code.

Let's say you are letting your users log in with any social account they choose. But how do you handle the event where 2 of your users want to connect the same GitHub account? We want to catch this event and transform it into a friendly error message for the user.

Here is the code:

```python
def connect_github_account(user, github_uid):
  try:
    user.social_accounts.add("github", github_uid)
  except SocialAlreadyClaimedException as exc:
    logger.log('...', exc_info=exc)
    return False, "Sorry, we could not connect you"
  ...
```

How do we test for this?

<table class="table table-sm table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      user.social_accounts.add("github", github_uid) -> Must raise SocialAlreadyClaimedException
    </td>
  </tr>
  <tr>
    <td class="">&nbsp;</td>
    <td class="">
      user = Mock()<br/>
      user.social_accounts.add.side_effect = SocialAlreadyClaimedException
    </td>
    <td class="align-middle border-left">
      (False, 'Sorry, we could not connect you')
    </td>
  </tr>
  <tr>
    <td class="border-bottom-0">&nbsp;</td>
    <td class="border-bottom-0">
      user = Mock()<br/>
      user.social_accounts.add.side_effect = SocialAlreadyClaimedException(<br>
&nbsp;&nbsp;"GitHub account XXX already connected to user AAA"<br>
)
    </td>
    <td class="align-middle border-left border-bottom-0">
      (False, 'Sorry, we could not connect you')
    </td>
  </tr>
  <tr>
    <td class="border-top-0"></td>
    <td colspan="2" class="border-top-0">
      <p>The return value for the function is the same. The difference is in the message of the exception. In the first example, the exception is raised without any message and in the second our message is supplied. We could check this by mocking the <code>logger</code> and looking at the calls that were made to it: <code>logger.call_args</code> -> <code>call('...', exc_info=SocialAlreadyClaimedException('GitHub account XXX already connected to user AAA'))
</code></p>
    </td>
  </tr>

</tbody>
</table>


#### `side_effect` as a substitute class/function (not a Mock object)

The last and most awesome use for `side_effect` is to use it to replace the contents of functions or classes.You can specify a new function/class which will be used instead of the original function/class. But it must be a function or a class not a different type of object and it must accept the same variables as the original function/class.

For example, we want to write a unit test for our menu. The links that we show on the menu depend on who is logged in and what organization they belong to. The code looks like this:

```python
def menu_urls(user):
  org_settings_url = create_url(endpoint="org_settings", org_slug=user.org.slug)
  dashboard_url = create_url(endpoint="dashboard")
  user_settings_url = create_url(endpoint="user_settings", org_slug=user.org.slug, user_slug=user.slug)
  ...

  return [org_settings_url, dashboard_url, user_settings_url, ... ]
```

We don't want to set up the whole app for this test, we want to write the simplest unit test, just making sure that the links are created with the correct arguments.

One solution is to mock `create_url` with the `side_effect` option.

<table class="table table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      menu_urls(user)
    </td>
  </tr>
  <tr>
    <td class="">&nbsp;</td>
    <td class="">
def <b>substitue_create_url</b>(endpoint, **kwargs):<br>
&nbsp;&nbsp;return f"{endpoint} WITH {kwargs}"<br>
<br>
create_url = Mock(side_effect=substitue_create_url)<br>
<br>
user = Mock(**{<br>
&nbsp;&nbsp;"slug": "__USER__SLUG__",<br>
&nbsp;&nbsp;"org.slug": "__ORG__SLUG__"<br>
})<br>
    </td>
    <td class="align-middle border-left">
[<br>
&nbsp;&nbsp;"org_settings WITH {'org_slug': '__ORG__SLUG__'}",<br>
&nbsp;&nbsp;'dashboard WITH {}',<br>
&nbsp;&nbsp;"user_settings WITH {'org_slug': '__ORG__SLUG__', 'user_slug': '__USER__SLUG__'}"<br>
]

    </td>
  </tr>
  <tr>
    <td class="border-top-0"></td>
    <td colspan="2" class="border-top-0">
      <p>Each time that <code>create_url</code> is called inside <code>menu_urls</code>, what is actually called is our <code>substitue_create_url</code>. It is of course called with the same input arguments, which we can modify or store in any way.</p>
    </td>
  </tr>


  <tr>
    <td class="">&nbsp;</td>
    <td class="">
def <b>substitue_create_url</b>(**kwargs):<br>
&nbsp;&nbsp;return "_SOME_URL_"<br>
<br>
create_url = Mock(<b>side_effect=substitue_create_url</b>)<br>
<br>
user = Mock()<br>
    </td>
    <td class="align-middle border-left">
['_SOME_URL_', '_SOME_URL_', '_SOME_URL_']

    </td>
  </tr>
  <tr>
    <td class="border-top-0"></td>
    <td colspan="2" class="border-top-0">
      <p>This is the same as if we had set up <code>create_url = Mock(return_value="_SOME__URL_")</code>.</p>
    </td>
  </tr>

</tbody>
</table>

The same thing can be done with classes. Let's say I store some user configuration in a class and I build it up step by step. The code looks like this:

```python
def create_config(user):
  config = Configuration()
  if user.can_read():
    config.set("literate", True)
  if user.can_jump():
    config.set("springy", True)
  ...
  return config
```

One possible way to write a test for this would be to mock the `Configuration` class.

<table class="table table-code">
<tbody>

  <tr class="title-row-tr">
    <td colspan="3" class="title-row-td border-top-0">
      create_config(user_1)<br>create_config(user_2)
    </td>
  </tr>
  <tr>
    <td class="">&nbsp;</td>
    <td class="">
class <b>SubstituteConfiguration</b>:<br>
&nbsp;&nbsp;def __init__(self):<br>
&nbsp;&nbsp;&nbsp;&nbsp;self.config = {}<br>
<br>
<b>&nbsp;&nbsp;def set(self, key, value):<br>
&nbsp;&nbsp;&nbsp;&nbsp;self.config[key] = value<br></b>
<br>
&nbsp;&nbsp;def __repr__(self):<br>
&nbsp;&nbsp;&nbsp;&nbsp;return str(self.config)<br>
<br>
Configuration = Mock(<b>side_effect=SubstituteConfiguration</b>)<br>
<br>
user_1 = Mock(**{<br>
&nbsp;&nbsp;"can_read.return_value": False,<br>
})<br>
user_2 = Mock()<br>
    </td>
    <td class="align-middle border-left">
      {'springy': True}<br>{'literate': True, 'springy': True}
    </td>
  </tr>

</tbody>
</table>

When using `side_effect` in this way, be careful. Don't go overboard with mocking. These tests can be very unstable. Even non-functional changes to the source like replacing a positional argument with a keyword argument can make such a test fail.

#### `side_effect` vs `return_value`

With `side_effect` you define a function/class (or iterator or exception), which should be called instead of the original function/class. With `return_value` you define the  result, what the function/class is supposed to return so that we don't need to call it.
{:.box}

## Level 4: Tracking calls

Every `Mock` remembers all the ways it was called. Sometimes we want to control what a mocked function/class returns, other times we want to inspect how it was called.

`Mock` objects come with built-in assert functions. The simplest one is probably `mock_obj.assert_called()` and the most commonly used might be `mock_obj.assert_called_once_with(...)`. With the help of `assert`-functions and only occasionally by inspecting the attributes `mock_obj.call_args_list` and `mock_call_args` we can write tests verifying how our objects are accessed.

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">
    All useful functions:
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_once()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_with(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_once_with(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&#x2764;</td>
    <td>from mock import <b>ANY</b><br>mock_obj.assert_called_once_with(<b>ANY</b>, "Natalia")
    <p>When we don't care to know all function parameters or don't care to set them all, we can use <i>ANY</i> as a placeholder.</p></td>
  </tr>

</tbody>
</table>


<table class="table table-sm table-code">
<thead>
  <tr>
    <th colspan="2" class="">A call on a Mock object</th>
  </tr>
  <tr>
    <th class="">&nbsp;</th>
    <th class="">Assert calls, which will not raise an error</th>
  </tr>
</thead>
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">mock_obj(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_once()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_with(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_once_with(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&#x2764;</td>
    <td>from mock import <b>ANY</b><br>mock_obj.assert_called_once_with(<b>ANY</b>, "Natalia")
    <p>When we don't care to know all function parameters or don't care to set them all, we can use <i>ANY</i> as a placeholder.</p></td>
  </tr>

</tbody>
</table>

What about when the mocked function is called more than once:


<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">mock_obj(100, "Natalia")<br />mock_obj(None, "Evgenij")</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called()</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_called_with(None, "Evgenij")<p>The <i>assert_called_with</i> compares only to the last call. Had we checked for the "Natalia"-call it would raise an error.</p>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>mock_obj.assert_any_call(100, "Natalia")</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>from mock import <b>call</b><br>mock_obj.assert_has_calls([<br>
&nbsp;&nbsp;<b>call</b>(None, "Evgenij"),<br>
&nbsp;&nbsp;<b>call</b>(100, "Natalia"),<br>
], any_order=True)
    </td>
  </tr>

</tbody>
</table>

For when we want to make sure that something didn't happen we can use `assert_not_called()`. Example: we send Slack messages to those users, who have opted-in to receiving Slack messages and not to others.

```python
def send_slack_msg(user):
  if user.has_slack_disabled():
    return

  slack_post(...)
```

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">user=Mock(**{"has_slack_disabled.return_value": True})<br>slack_post = Mock()<br>send_slack_msg(user)</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>slack_post.assert_not_called()</td>
  </tr>

</tbody>
</table>

Should we want to make more calls to the same mock function, we can call `reset_mock` in between calls.



<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">send_slack_msg(user_1)<br>send_slack_msg(user_2)</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>slack_post.assert_called_once_with(...)<br>slack_post.<b>reset_mock()</b><br>slack_post_assert_called_once_with(...)</td>
  </tr>

</tbody>
</table>


## Level 5: Mocking imports with `patch`

The last piece in our puzzle of mocking is `patch`. Until now we've pretended that we have complete access to all functions and variables we are testing, that the test and the source code live in the same context, the same file, but this is never true. So, if the source file *sending.py* looks like this:

```python
#  sending.py
def send_post(...):
  ...

def send_slack_msg(user):
  if user.has_slack_disabled():
    return

  slack_post(...)
```

and we want to write a test in the file `test_sending.py`, how can we mock the function `send_post`?

By using `patch` .. and giving it the full path to the *relative* location/target of the thing we want to mock.

Generally speaking, the **target** is constructed like this: **&lt;prefix&gt;&lt;suffix&gt;&lt;optional suffix&gt;**.<br>
*The prefix is*: the path to the module, which will import the function/class/module we are mocking.<br>
*The suffix is*: the last part of the `from .. import..` statement which imports the object we are mocking, everything after `import`. <br>
*The optional suffix is*: If the `suffix` is the name of a module or class, then the optional suffix can the a class in this module or a function in this class. This way we can mock only 1 function in a class or 1 class in a module.
{:.box}

`patch` can be used as a decorator for a function, a decorator for a class or a context manager. In each case, it produces a `MagicMock` (exception: `AsyncMock`) variable, which it passes either to the function it mocks, to all functions of the class it mocks or to the with statement when it is a context manager.

#### Patch target - Examples of prefix-suffix-optional_suffix combinations

Here is a layered series of calls: `slack/sending.py` calls `aaa.py`, which calls `bbb.py`, which calls `ccc.py`, which calls `slack_api.py`.

In a diagram:
![](/assets/mock-patching.png)

and in code:

```python
#  slack/sending.py
from a_lib.aaa import A_slack_post

def send_slack_msg(user):
  print(f"send_slack_msg will call {A_slack_post}")
  A_slack_post(user)


#  a_lib/aaa.py
from b_lib.bbb import B_slack_post

def A_slack_post(user):
    print(f"A will call {B_slack_post}")
    B_slack_post(user)


# b_lib/bbb.py
from c_lib.ccc import C_slack_post

def B_slack_post(user):
    print(f"B will call {C_slack_post}")
    C_slack_post(user)


# c_lib/ccc.py
from slack_lib.slack_api import slack_post


def C_slack_post(user):
    print(f"C will call {slack_post}")
    slack_post(user)


# slack_lib/slack_api.py
def slack_post(user):
  print(f"send Slack msg")

```

What is the patch `target` if we want to only mock what is inside `slack_post`? What if we want to mock everything from `B_slack_post` on?

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">we will call <code>send_slack_msg(user)</code>and mock <code>slack_lib.slack_api.slack_post</code></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    @patch("<b>c_lib.ccc.</b>slack_post")<br>
    def test(mock_slack_post):<br>
    &nbsp;&nbsp;send_slack_msg(...)<br>
    &nbsp;&nbsp;<b>mock_slack_post.assert_called()</b><br>
    <p>Prefix: the path to the file, where we want to start mocking = <code>c_lib/ccc.py</code>.<br>
    Suffix: name of our function = <code>slack_post</code>.</p>
    <p>Our printout will be:<br>
send_slack_msg will call &lt;function A_slack_post at 0x7f25&gt;<br>
A will call &lt;function B_slack_post at 0x7f25&gt;<br>
B will call &lt;function C_slack_post at 0x7f25&gt;<br>
C will call &lt;MagicMock name='slack_post' id='1397'&gt;<br>
</p>
    </td>
  </tr>
    <tr class="title-row-tr">
      <td colspan="2" class="title-row-td">we will call <code>send_slack_msg(user)</code>and mock <code>b_lib.bbb.B_slack_post</code></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
      @patch("<b>a_lib.aaa.</b>B_slack_post")<br>
      def test(mock_B_slack_post):<br>
      &nbsp;&nbsp;<b>mock_B_slack_post.return_value = True</b><br>
      &nbsp;&nbsp;send_slack_msg(...)<br>
      <p>Prefix: the path to the file, where we want to start mocking = <code>a_lib/aaa.py</code>.<br>
      Suffix: name of our function = <code>B_slack_post</code>.</p>
      <p>Our printout will be:<br>
send_slack_msg will call &lt;function A_slack_post at 0x7fc&gt;<br>
A will call &lt;MagicMock name='B_slack_post' id='1405'&gt;<br></p>
      </td>
    </tr>
</tbody>
</table>

For reference, when nothing is mocked and we call `send_slack_msg(user)`, the following is printed:

<i>send_slack_msg will call &lt;function A_slack_post at 0x7f25&gt;<br>
A will call &lt;function B_slack_post at 0x7f25&gt;<br>
B will call &lt;function C_slack_post at 0x7f25&gt;<br>
C will call &lt;function send_slack_msg at 0x7f25&gt;<br>
send Slack msg</i>

#### Patching only one function in a class

```python
#  slack_lib/slack_api.py
from slack import slack_api

def send_slack_msg(user):
  slack_instance = slack_api.SlackAPI(user)
  print(f"send_slack_msg will call {slack_instance.post} on {slack_instance}")
  slack_instance.post()


#  slack_lib/slack_api.py
class SlackAPI:
  def __init__(self, user):
    self.user = user

  def post(self):
    print(f"send from class to user: {self.user}")
```

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">we will call <code>send_slack_msg</code> and mock only <code>SlackAPI.post</code>:</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      @patch("slack.sending.<b>slack_api.SlackAPI.post</b>")
      def test(mock_slack_api_post):<br>
      &nbsp;&nbsp;mock_slack_api_post = lambda :"Mock was called"<br>
      &nbsp;&nbsp;send_slack_msg(Mock())
      <p>Prefix: path to module where <code>send_slack_msg</code> lives = slack.sending.<br>
        Suffix: what is after <code>import</code> in <code>from slack import slack_api</code> = slack_api.<br/>
        Optional suffix: a class inside <code>slack_api</code> + a function inside the class = SlackAPI.post
      </p>
      <p>Our printout will be:<br>
        send_slack_msg will call &lt;MagicMock name='post'&gt; on &lt;slack_lib.slack_api.SlackAPI&gt;<br>
        Mock was called
      </p>
    </td>
  </tr>
</tbody>
</table>

#### Patch `object`

As far as I can see `patch.object()` works exactly the same as `patch()`. The only difference is that `patch` takes a string as the target while `patch.object` needs a reference. `patch.object` is thus used for patching individual functions of a class.

For the above situation the pather would look like this:
<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">we will call <code>send_slack_msg</code> and mock only <code>SlackAPI.post</code>:</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      <b>from slack_lib.slack_api import SlackAPI</b><br>
      @patch.object<b>(SlackAPI, "post")</b>
      def test(mock_slack_post):
    </td>
  </tr>
</tbody>
</table>




## Knicks-knacks A: `PropertyMock`

For when you need to mock a `@property`:

```python
# models/user.py
class User:
  @property
  def name(self):
    return f"{self.first_name} {self.last_name}"
  @name.setter
  def name(self, value):
    self.first_name = value

# service/user.py
def create_user(name):
  user = User()
  user.name = name
  return user.name
```

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">mock the property <code>name</code>:</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      from mock import PropertyMock<br>
      from models.user import User<br>
      from services.user import create_user<br>
<br>
      <b>@patch.object(User, "name", new_callable=PropertyMock)<br></b>
      def test(mock_user):<br>
      &nbsp;&nbsp;<b>mock_user.return_value = "Jane Doe"</b><br>
      &nbsp;&nbsp;assert create_user("Janette") == "Jane Doe"<br>
      &nbsp;&nbsp;<b>mock_user.assert_any_call("Janette")</b><br>
      <p>Whenever we will call user.name, we will get the string "Jane Doe". But the mock also remembers all the values it was called with.</p>
    </td>
  </tr>
</tbody>
</table>



## Knicks-knacks B: Patching a constant

How do we mock a constant? With `patch`'s `new`-attribute:

```python
# constants.py
MSG_LIMIT = 7

# code.py
from constants import MSG_LIMIT

def get_latest_msgs():
  return messages.limit(MSG_LIMIT).all()
```

<table class="table table-sm table-code">
<tbody>
  <tr class="title-row-tr">
    <td colspan="2" class="title-row-td">mock <code>MSG_LIMIT</code> and set it to 3</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      @patch("code.MSG_LIMIT", new=3)
    </td>
  </tr>
</tbody>
</table>


## Knicks-knacks C: Having many `patch`-ers

Each patcher can pass a `MagicMock` variable to the calling function. Because this is Python, the decorators are applied bottom up:

```python
@patch("path_1")
@patch("path_2")
@patch("path_3")
def test(mock_path_3, mock_path_2, mock_path_1):
  ...
```

## More!

This was supposed to be a list of essential mock functionalities. It covers 99% of everything I ever needed or saw mocked. Certainly, this is not the limit of the `mock` library, but I'm already looking forward to utilizing this summarized version of how `Mock`s should be constructed instead of reading through the longer (and more precise) official documentation or googling various StackOverflow answers. And who knows, maybe it will someday be of use to some other `mock`-frustrated programmer soul, who will be gladdened to have found this post.


<style>
.emoji{
  font-family: inherit;
}
.table-code {
    word-break: break-word;
    font-family: SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace,
    // Emoji fonts
    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol" !default;
}
.table .title-row-td{
    border-bottom: 2px solid #e83e8c;
    font-size: 120%;
}
.top-border {
  border-top: 2px dotted #e83e8c;
}
.table-code p{font-style: italic;}

</style>
