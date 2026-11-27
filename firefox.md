# Setting up Firefox on a new computer

## Extensions

Starting in 2021, I decided to reduce the number of extensions I use after
learning more about how little auditing goes on for browser extensions and
case-studies like The Great Suspender (where the original author sold it to
some sketchy people who then put in spyware). In particular, I only use
extensions that have a "Recommended" status in Firefox.

* uBlock Origin
* Video DownloadHelper (usually disabled, but I enable it whenever I want to use it)

## Settings

* "Open previous windows and tabs" → change to true
* "Ctrl+Tab cycles through tabs in recently used order" → change to true
* Website language → Preferred languages → add Japanese to the list. This makes it so that kanji do not use the Chinese variants.
* "Ask where to save files before downloading" → change to true
* "Always show scrollbars" → change to true
* "Show search terms in the address bar on results pages" → uncheck this (turns off the annoying thing where if I do a keyword search, then press Ctrl-l to highlight the address bar, then type a new thing, it just does another search with that keyword search instead of going to the URL I wanted to go to)
* Turn off popup when selecting text in the PDF viewer:
  Open `about:config`,
  search for `pdfjs.enableHighlightFloatingButton`,
  double click to change the value to `false`.
  ([Source](https://www.reddit.com/r/firefox/comments/1ovey93/can_i_disable_the_popup_comment_highlight_i_get/))
* Use old-style (transparent purplish blue) text selection in PDFs:
  Open `about:config`,
  search for `pdfjs.enableSelectionRendering`,
  double click to change the value to `false`.
  (Source: conversation with Claude Fable 5.)
* "Enable link previews" → "Shortcut: Click and hold the link for 1 second (long press)" → change to false
* On the new page screen:
  * Right click on bookmarks toolbar → Bookmarks Toolbar → Never show
  * Click the pencil "Customize" button. Turn off Shortcuts, Widgets, and Stories.
  * Right click on the top bar → Customize Toolbar → Remove the flexible space on either side of the URL bar, remove the Sidebars thing on the very left, and remove the Account button. When finished, the URL bar should be: (forward) (back) (refresh) (URL bar, taking up all available space) (downloads; only shown when some file has been downloaded during the session) (extensions; looks like a puzzle piece) (ublock origin) (hamburger menu).
    The Sidebars thing sometimes comes back but removing it the second time seems to get rid of it permanently.
    Also remove the "Search and manage tabs" thing that shows up on the same row as the tabs.
* In the settings search bar, search for "sponsor", and disable all the sponsored things like "sponsored shortcuts", "suggestions from sponsors", and so on.
* "Use AI to suggest tabs and a name for tab groups" → change to false
* "Drag tabs together to create tab groups" → change to false

## Custom keyword search

Firefox has two places to add keyword searches. One of them is in the settings,
and it's easier to use but does not allow unquoted (non-URL-encoded) strings.
The other option is to add it via a bookmark.

The ones with `%s` below can be added via settings, but the ones with `%S` only
work in the bookmarks (because the input string must _not_ be URL-encoded in order
to work).

Add these via Additional search engines → Add search engine:

```
Wikipedia
https://en.wikipedia.org/w/index.php?search=%s&title=Special%3ASearch
!w

Amazon
https://www.amazon.com/s?k=%s
!a

Reddit
https://www.google.com/search?q=site%3Areddit.com+%s
!r

YouTube
https://www.youtube.com/results?search_query=%s
!yt

Brave
https://search.brave.com/search?q=%s
(blank keyword; make this the default)

The Free Dictionary
https://www.thefreedictionary.com/%s
!d

etymonline
https://www.etymonline.com/search?q=%s
!e
```

Add these via bookmarks:

```
Internet Archive
https://web.archive.org/web/*/%S
!ia

Internet Archive save
https://web.archive.org/save/%S
!ias

Internet Archive save 2
https://web.archive.org/save/%S
!save
```
