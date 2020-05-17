---
title: Cheat Sheet of Python Mock
---

I always wanted to have this. The cool part of me of course wanted *me* to be the one who writes it, the pragmatic part just wanted to have access to a list like this and the hedonic part of me made me ignore the whole topic by telling me to chase after greater pleasure of life, at least greater than this blog post, no mater how magnificent it might eventually become, could ever give. But here I am, some years later, in the wrath of the epidemic lockdown, re-running Python tests in an infinite loop until I figure out which nobs and settings of this `mock` library I have to turn and set to get it to mock the damn remote calls.

The situation makes you wonder. Did it have to take a nation wide lockdown for me to start composing this list? Is it the dullness of the `mock` library that is the problem? Or is the culprit just a general aversion to spending any more time on tests than absolutely necessary? .. Who knows. But here we are, so let's get on with it.

`mock` is actually a great library. There are people out there, who are absolutely against `mock` and who will tell you that you should not mock anything ever. You should handle their stance just like you would the stance of any other absolutist: don't trust them. Writing tests is less about who has the moral upperground and more about who can get a reasonably well structured test out in a reasonable amount of time.

## Level 1: Creating a new Mock object

First, let's see what are all the ways we can create and configure a `Mock` object.


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

Next to `Mock` there is also `MagicMock`. `MagicMock` can do all the same things that `Mock` can do, but it can do a smidgen more. `MagicMock` has some dunder (or magic) methods already defined: `__lt__`, `__gt__`, `__int__`, `__len__`, `__iter__`, ... . This means you can do this: `len(MagicMock())` and receive `0`. Or this: `float(MagicMock())` and receive `1.0`. Or this: `MagicMock()[1]` and receive a new `MagicMock` object.

A rule of thumb: a simple `Mock()` object cannot handle anything in the path that is not a function (or property, which is also a function).
{:.box}

Paths like these are ok:
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

A rule of thumb 2: When you are using a `Mock` object and there are only functions (and properties) in the path, you don't have to explicitly create sub-`Mock` objects. You can just use the dot-notation to specify the end result. <br>
If you are using `MagicMock` you can use the dor-notation most of the time.
<br>Examples:
{:.box}


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

Every `Mock` object can be instantiated with a `side_effect` attribute. This attribute is useful in 3 types of situations and only one of them can honestly be called a side effect. Unfortunately, the lamentable name makes developers miss how versatile and convenience its underlying functionality actually is.

#### `side_effect` as an iterator

We have a remote call to Slack where we fetch all channels of some Slack workspace. But Slack's API is in it's Nth version and has thus the annoying, but very sensible, limitation built-in which permits us to only fetch 100 channels at a time. To get the 101st channel we have to make a new GET request with the pagination cursor we received in the last request. Here is the code:

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

Let's say you are letting your users to log in with any social account they choose. But how do you handle the event where 2 of your users want to connect the same GitHub account? We want to catch this event and transform it into a friendly error message for the user.

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
  </tr><tr>
    <td class="border-top-0"></td>
    <td colspan="2" class="border-top-0">
      <p>The return value for the function is the same. The difference is in the message of the exception. In the first example the exception is raised without any message and in the second our message is supplied. We could check this by mocking the <code>logger</code> and looking at the calls that were made to it: <code>logger.call_args</code> -> <code>call('...', exc_info=SocialAlreadyClaimedException('GitHub account XXX already connected to user AAA'))
</code></p>
    </td>
  </tr>

</tbody>
</table>


#### `side_effect` as a substitute class/function



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
.title-row-td{
    border-bottom: 2px solid #e83e8c;
    font-weight: bold;
    font-size: 120%;
    padding: 20px 0;
    color: #e83e8c;
}
.top-border {
  border-top: 2px dotted #e83e8c;
}
.table-code p{font-style: italic;}

</style>
