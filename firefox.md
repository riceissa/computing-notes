# Setting up Firefox on a new computer

## Extensions

Starting in 2021, I decided to reduce the number of extensions I use after
learning more about how little auditing goes on for browser extensions and
case-studies like The Great Suspender (where the original author sold it to
some sketchy people who then put in spyware). In particular, I only use
extensions that have a "Recommended" status in Firefox.

* uBlock Origin
* ClearURLs
* Video DownloadHelper (usually disabled, but I enable it whenever I want to use it)

## Settings

* "Open previous windows and tabs" → change to true
* "Ctrl+Tab cycles through tabs in recently used order" → change to true
* "Choose your preferred language for displaying pages" → add Japanese to the list. This makes it so that kanji do not use the Chinese variants.
* "Always ask you where to save files" → change to true
* "Always show scrollbars" → change to true

## Custom keyword search

Firefox has two places to add keyword searches. One of them is in the settings,
and it's easier to use but does not allow unquoted (non-URL-encoded) strings.
The other option is to add it via a bookmark.

The ones with `%s` below can be added via settings, but the ones with `%S` only
work in the bookmarks (because the input string must _not_ be URL-encoded in order
to work).

Add these via Settings → Search Shortcuts:

```
!w
https://en.wikipedia.org/w/index.php?search=%s&title=Special%3ASearch

!a
https://www.amazon.com/s?k=%s

!r
https://www.google.com/search?q=site%3Areddit.com+%s

!yt
https://www.youtube.com/results?search_query=%s
```

Add these via bookmarks:

```
!ia
https://web.archive.org/web/*/%S

!ias
https://web.archive.org/save/%S

!save
https://web.archive.org/save/%S
```
