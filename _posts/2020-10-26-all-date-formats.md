---
title: "What are UTC time, ISO time format and UNIX time"
biblio:
  - title: "Wikipedia: Unix time"
    link: "https://en.wikipedia.org/wiki/Unix_time"
  - title: "Wikipedia: UTC"
    link: "https://en.wikipedia.org/wiki/Coordinated_Universal_Time"
  - title: "Wikipedia: UTC offset"
    link: "https://en.wikipedia.org/wiki/UTC_offset"
  - title: "Wikipedia: NATO phonetic alphabet"
    link: "https://en.wikipedia.org/wiki/NATO_phonetic_alphabet"
  - title: "Wikipedia: ISO 8601"
    link: "https://en.wikipedia.org/wiki/ISO_8601"
  - title: "Python Docs: datetime"
    link: "https://docs.python.org/3/library/datetime.html"
  - title: "StackOverflow: In an ISO 8601 date, is the T character mandatory?"
    link: "https://stackoverflow.com/questions/9531524/in-an-iso-8601-date-is-the-t-character-mandatory#:~:text=It's%20required%20unless%20the%20%22partners,day%20component%20in%20these%20expressions."
---

*"My time now is 16:44, what is that in UTC time?"* is what I asked myself last week. *"Do we use UTC dates everywhere with no timezone information or do we store timezones into the DB?"* was another question. *"And by the way, if I call `datetime.now()`, am I getting the correct time or should I adjust it with a timezone suffix?"*. This time-business is so delicate. I never had much trouble with date-times, until last week, when I had to create a humble Celery task that needs to be a master of time, that needs to understand how all the dates on all these objects relate to one another. And suddenly I am finding myself appalled by all datetimes with no timezone info. What a grievous mistake it was to allow programmers to forget about timezones, to just call `now()` and hope for the best. How is my super-duper, time-lord of a Celery task supposed to lord the time if a single measly timezone-lacking datetime knocks it out of its balance?

So I had to read a few docs and a few standards to really, truly understand what to do with missing timezones and whether the datetime I am creating is really and truly the exact datetime I want and not one that is 1h before or ahead (my timezone is +01:00, which is very easy to mistake for +00:00).


## <small>What is</small> UTC time

UTC is a global time standard. It defined how time will be measured and coordinated between everybody. But UTC is also used as a **successor of GMT** (=Greenwich Mean Time) to describe the time at the 0° meridian.

In code, we usually denote it with **+00:00** or with a **Z**. The letter Z is used for historical reasons because Z was the name of the timezone using this time. This time is also sometimes called the **Zulu time** since NATO's phonetic alphabet for Z is "Zulu".

**The daylight saving time (=DST) does not affect UTC.** DST simply modifies the ±[hh]:[mm]-part of the date-time: Europe's CTE (=Central European Time) is usually described as `UTC+1`, but during the summer, when DST kicks in, it simply becomes `UTC+2`.


## <small>What is</small> the ISO format / ISO 8601 format

This ISO standard defines how to format dates and date-times without confusion and misunderstandings.

Date format:
- 2020-10-26

Date and time formats:
- 2020-10-26**T**08:15:30**+02:00**
- 2020-10-26**T**08:15:30**Z**
- 20201026**T**081530**Z**
- 2020-10-26**T**08:15:30**.456****+02:00** <- with microseconds

**If the timezone is omitted, the datetime is usually interpreted to be recording the locale time.** But of course, this is up to every programming team to define for themselves.

The **T** is also often omitted. The ISO standard does allow for this, but only if the 2 parties communicating with such dates have agreed to allow it. However, there is no mention of substituting T with a space. But I think we all see that our community has decided that it can correctly understand a datetime with a space and is actively using it everywhere.


## <small>What is</small> UNIX time / Epoch time / POSIX time

Unix time is an **integer**, it's the number of seconds passed since 1st January 1970 UTC - a capriciously chosen date. This date is called the Epoch.

UNIX time **excludes all leap seconds.** It pretends that every day has exactly 24 * 60 * 60 (=86 400) seconds.


## Timezones and UTC offsets

UTC offsets are the ±[hh]:[mm] parts of date-time formats. They are a multiple of 15 minutes and they describe the difference between UTC and the locale time.


## Python in the world of datetime

Python differentiates between *naive* and *aware* datetimes. The first one has no timezone, while the second does has a timezone. Each `datetime` objects has an optional attribute `tzinfo`, which can hold timezone information.

#### How to get the current time

My current time is `2020-10-26T12:30:10Z`, my timezone is +1. Here I get my locale time:

```python
In : from datetime import datetime

In : datetime.now()  # produces a naive datetime
Out: datetime.datetime(2020, 10, 26, 13, 30, 10, 933315)


In : datetime.utcnow()  # produces a naive datetime
Out: datetime.datetime(2020, 10, 26, 12, 30, 10, 933315)
```

Both above functions create a **naive** datetime.

#### How to get the current time with timezone

```python
In : from datetime import datetime, timezone

In : datetime.now(tz=timezone.utc)
Out: datetime.datetime(2020, 10, 26, 12, 30, 10, 933315, tzinfo=datetime.timezone.utc)
```

#### How to create an exact datetime

Here I create the 31st Dec 2020, at midnight UTC time:

```python
In : from datetime import datetime, timezone

In : datetime(2020, 12, 31, 0, 0, 0, tzinfo=timezone.utc)
Out: datetime.datetime(2020, 12, 31, 0, 0, 0, tzinfo=datetime.timezone.utc)
```

And here I create the 31st Dec 2020, at midnight in the timezone +03:00:
```python
In : from datetime import datetime, timedelta, timezone

In : datetime(2020, 12, 31, 0, 0, 0, tzinfo=timezone(timedelta(minutes=3 * 60)))
Out: datetime.datetime(2020, 12, 31, 0, 0, 0, tzinfo=datetime.timezone(datetime.timedelta(seconds=3600))
```

Timezones are set with `timedelta` to describe the UTC offset.

#### How to get the UNIX time of any date / how to turn UNIX time to date

In Python, this format is called "timestamp". And it is not an integer, but a float, so that microseconds can be represented.

```python
In : from datetime import datetime, timezone

# turn a date into a timestamp:
In : d = datetime(2020, 10, ...)
In : d.timestamp()
Out: 1603711810.933315  # the num of seconds since Epoch

# turn the timestamp into a naive date
In : datetime.fromtimestamp(1603711810.933315)
Out: datetime.datetime(2020, 10, 26, 11, 30, 10, 933315)
# turn the timestamp into an aware date
In : datetime.fromtimestamp(1603711810.933315, tz=timezone.utc)
Out: datetime.datetime(2020, 10, 26, 11, 30, 10, 933315, tzinfo=datetime.timezone.utc)
# turn the timestamp into an aware date at UTC+3
In : datetime.fromtimestamp(1603711810.933315, tz=timezone(timedelta(minutes=3 * 60)))
Out: datetime.datetime(2020, 10, 26, 14, 30, 10, 933315, tzinfo=datetime.timezone(datetime.timedelta(seconds=10800)))
```

The POSIX time is always the time at UTC+0, which means that when call `fromtimestamp` with timezone parameter we define only what **the timezone of the result will be, not the timezone of the input value**. When we passed in `UTC+0`, it produced the time `11:30`, when we passed in `UTC+3` it produced `14:30`.


#### How to parse a string into a `datetime`

Use the `datetime.fromisoformat` for this, BUT: not all ISO 8601 strings can be parsed. Only strings of this format can be parsed:

```
YYYY-MM-DD[*HH[:MM[:SS[.fff[fff]]]][+HH:MM[:SS[.ffffff]]]]
```

Using `Z` as the timezone is not supported.

```python
In : datetime.fromisoformat("2020-10-26T12:30+02:00")
Out: datetime.datetime(2020, 10, 26, 12, 30, tzinfo=datetime.timezone(datetime.timedelta(seconds=7200)))

In : datetime.fromisoformat("2020-10-26 12:30:10.998")
Out: datetime.datetime(2020, 10, 26, 12, 30, 10, 998000)
```


#### How to add or remove days/months/years to a datetime

One way is to use `timedelta`:

```python
In : d = datetime.fromisoformat("2020-10-26 12:30:10.555+01:00")
Out: datetime.datetime(2020, 10, 26, 12, 30, 10, 555000, tzinfo=datetime.timezone(datetime.timedelta(seconds=3600)))

# add 1 day
In : d + timedelta(days=1)
Out: datetime.datetime(2020, 10, 27, 12, 30, 10, 555000, tzinfo=datetime.timezone(datetime.timedelta(seconds=3600)))

# add 4 hours
In : d + timedelta(minutes=4 * 60)
Out: datetime.datetime(2020, 10, 26, 16, 30, 10, 555000, tzinfo=datetime.timezone(datetime.timedelta(seconds=3600)))

# subtract a year (given that this is not a leap year)
In : d + timedelta(minutes=365)
Out: datetime.datetime(2019, 10, 27, 12, 30, 10, 555000, tzinfo=datetime.timezone(datetime.timedelta(seconds=3600)))
```

The other is to replace parts of the date, but this can trigger `ValueError`s:

```python
In : d = datetime.fromisoformat("2020-02-29 00:00:00+00:00")
Out: datetime.datetime(2020, 2, 29, 0, 0, tzinfo=datetime.timezone.utc)

# this date 20 years ago:
In : d.replace(year=2000)
Out: datetime.datetime(2000, 2, 29, 0, 0, tzinfo=datetime.timezone.utc)

# change year to 2019, which didn't have Feb 29th:
In: d.replace(year=2019)
---------------------------------------------------------------------------
ValueError
----> 1 d.replace(year=2019)

ValueError: day is out of range for month

```

The `replace` function can be used to replace any part of the datetime: minutes, hours, days, timezone, ...:

```python
In : d = datetime.fromisoformat("2020-02-29 00:00:00+00:00")
Out: datetime.datetime(2020, 2, 29, 0, 0, tzinfo=datetime.timezone.utc)

In : d.replace(year=2019, day=28, tzinfo=timezone(timedelta(minutes=-8 * 60)))
Out: datetime.datetime(2019, 2, 28, 0, 0, tzinfo=datetime.timezone(datetime.timedelta(days=-1, seconds=57600)))
```
