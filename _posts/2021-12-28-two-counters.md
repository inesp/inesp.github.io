---
title: "Programming patterns: 2 counters in a loop"
tags: ["Code Patterns", "Algorithms"]
excerpt_separator: <!--more-->
biblio:
---

Here's the problem: I have 1 timeline, but 2 types of events appear on this timeline. I want to use events of type 1 as borders in my timeline, these borders will separate events of type 2 into groups.

For example: I want to know which bird sings first every morning after sunrise. I have a list of sunrises for the last month and a list of singing events. How do I get the result without doing a 2-level nested loop?

{% include image.html alt="" src="2_counters.jpg" %}

 <!--more-->


## A 2-level loop will always work (but it will be the slowest)

I want to end up with a list of pairs of the sunrise time and the first song time.

A loop like this will always work:

```python
for sunrise in sunrises:
  for bird_song in bird_songs:
    # if the song happened before the sunrise, check the next song
    if bird_song.start_at < sunrise.at:
      continue

    # if the song happened on the next day, then let's move to the next sunrise
    if bird_song.start_at > sunrise.day_ends_at:
      break

    sunrise.first_bird_song = bird_song
    # once we found our first song, we can move on to the next sunrise
    break

```

But it is looping over the `bird_songs` too many times. For each sunrise, we start looping over `bird_songs` from the 1st song on. Time-wise a classical 2-level loop is considered to take about $O(N^2)$ time.

True, in our case, we loop over 2 different lists, we have S number of sunrises and B number of bird songs, so we get O(S \* B). Then we also `break` out from the loop when we find the correct song, so we don't really do the full B number of loops for every sunrise. But these estimations are always made with the worst-case scenario in mind, which is in our case: we have 10 million bird songs and all of them happen on the first day and before the sunrise, which brings us right into O(S \* B).


## One loop, two counters moving it forward

To make the above loop faster, we would need to loop over `sunrises` and `bird_songs` in alternation. We need to stop the `bird_songs` loop when we find the desired song, move `sunrises` 1 iteration further and then continue looping over `bird_songs` at the exact location, where we stopped looping before.

```python

sunrise_counter = 0
song_counter = 0

while sunrise_counter < len(sunrises) and song_counter < len(bird_songs):
  bird_song = bird_songs[song_counter]
  sunrise = sunrises[sunrise_counter]

  # if the song happened before the sunrise, check the next song
  if bird_song.start_at < sunrise.at:
    song_counter += 1
    continue

  # if the song happened on the next day, then let's move to the next sunrise
  if bird_song.start_at > sunrise.day_ends_at:
    sunrise_counter += 1
    continue

  sunrise.first_bird_song = bird_song
  # once we found our first song, we can move on to the next sunrise and next song
  song_counter += 1
  sunrise_counter += 1

```

This `while`-loop is extremely similar to the 2-level loop from above. It has the same `if`-statements and the same `comments`, but its time complexity is $O(S + B)$ instead of $(S * B)$. With 30 sunrises and 10M bird songs, we land at ~10M operations instead of 300M operations.

The biggest drawback of this approach: it's much more difficult to read and maintain. This too is an important aspect of the code.

Choose the one, which brings you more benefits.
