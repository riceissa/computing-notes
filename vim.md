# Vim

## Vim on Fedora

I prefer using the terminal Vim rather than GVim. However, I still want Vim with
clipboard support enabled. On Fedora, the terminal Vim with clipboard support
can be installed via:

```bash
sudo dnf install vim-X11
```

(In particular, don't install `vim-enhanced`, which is the package that gets
recommended when you type `vim` in the command-line without having Vim installed.
It does _not_ have clipboard support.)

Now Vim can be run using the command `vimx`. I found this annoying, as on
Debian-based systems I am used to just typing `vim` to get the clipboard-enabled
terminal Vim. To fix this, I created a symlink:

```bash
sudo ln -sv /usr/bin/vimx /usr/bin/vim
```

I tried using a Bash alias at first, but this turned out to not work well
because certain programs don't use Bash aliases so couldn't find a command
named `vim`. For example, `crontab -e` seems to use plain sh so complains with
the following if you use the alias approach:

```
/bin/sh: line 1: vim: command not found
crontab: "vim" exited with status 127
```

## vimrc on Fedora

Fedora does some annoying things in `/etc/vimrc`.

First, it sets the `viminfo` option to only remember 20 files' worth of
marks, which is a problem for me because I like having the restore-cursor
autocommand to jump to where I was last time when I edited a particular file.
By default, Vim remembers 100 files' worth of marks, which is much better.
I like to just reset to the default value:

```vim
set viminfo&
```

Second, Fedora's `/etc/vimrc` has a broken implementation of
`:help restore-cursor` that does not check whether the buffer is a git commit window,
which means that if you try to write a commit message, your cursor might be in
a random spot in the file. So I delete this
autocommand. A working implementation is already in `defaults.vim` which ships
with Vim, so I don't know why they decided that adding it in again was a good
idea.

```vim
if exists('#fedora#BufReadPost *')
  autocmd! fedora BufReadPost *
endif
```

I submitted a bug report here: <https://bugzilla.redhat.com/show_bug.cgi?id=2404651>
and hopefully it will be fixed soon.

## spellfile not set

By default in Vim (as well as Neovim), using `:set spell` and then `zg` on a misspelled word to
attempt to add it to the spell file brings up the following error:

```
E764: Option 'spellfile' is not set
```

For years, I had followed the advice of this error message by setting a `spellfile` like this:

```vim
set spellfile=~/.spell.en.utf-8.add
```

However, recently I read in `:help spellfile` the following:

```
When a word is added while this option is empty Vim will set it for
you: Using the first directory in 'runtimepath' that is writable.  If
there is no "spell" directory yet it will be created.  For the file
name the first language name that appears in 'spelllang' is used,
ignoring the region.
```

Since the `spellfile` option was initially empty, according to this help page,
Vim should have set it for me!  What's going on? I checked my runtime path and
it contained `~/.vim`, so it should have created a file named
`~/.vim/spell/en.utf-8.add`.

The problem, it turns out, is that if `~/.vim` does not exist, then Vim won't
create _that_ directory, although if `~/.vim` _does_ exist, then Vim will create
`~/.vim/spell`.

So the better solution to solving the spell file problem (instead of following
the error message's advice and setting the `spellfile` option) is simply:

```bash
mkdir ~/.vim
```

Now doing `zg` will name and create the spellfile automatically and will add
the misspelled word to the list of known words.

## C switch cases

Vim's default C indenting options for switch cases are kind of insane in my
opinion. They look like this:

```c
switch (a) {
    case 1: {
                a++;
            } break;
    case 2:
        a++;
        break;
}
```

The closing curly brace gets indented to match the column of the opening one,
rather than just being indented to the case label, the way that closing braces
usually get indented.

The following option makes it so that the closing curly brace gets the more
intuitive indent:

```vim
set cinoptions=l1
```

Now switch statements will look like this:

```c
switch (a) {
    case 1: {
        a++;
    } break;
    case 2:
        a++;
        break;
}
```

If you don't want the case labels to be indented further than the switch statement
itself, you can also add `:0` like this:

```vim
set cinoptions=l1,:0
```

## Why `set nohlsearch`

One of the few changes to the defaults that Neovim made that I disagree with
is `set hlsearch`, which highlights search matches.

There are two kinds of searches in my experience:

1. Searching for navigation: I have a specific spot I want to go to,
   either on the current visible part of the screen, or off-screen, and I
   just want to go there. This is no different than using some other
   motion like `f<char>` or `W`, or moving around with Ctrl-f, etc.
2. Searching to find all of something: I maybe want to see all the places
   where a variable is being used, and so I want to see all the instances
   of the searched string.

In my experience, (1) is a lot more frequent than (2), but only (2) benefits
from having matches highlighted. So having hlsearch turned on by default
(which is only on Neovim) is distracting, because I usually just want to put
my cursor in a particular spot and go on with what I was trying to do.

## Why `set hidden`

I kind of like the discipline of always saving buffers before making them no
longer visible on the screen. But leaving 'hidden' off turns out to have a
nasty side effect which is that all of the undo history for a buffer gets
forgotten when it goes out of view! I could probably fix that by setting an
undofile, but I don't know if I like the idea of persistent undos across
different editing sessions. So for now, I will just turn on 'hidden'.

In my opinion, the `hidden` option specifies too many things at once that
are really orthogonal. There's
"do you want to forget the undo history (and generally unload the buffer, as if you did `:bd`)
when a buffer becomes invisible?"
and then there's
"do you want to be able to make buffers invisible even if they have unsaved changes?"


## Clipboard management

In my vimrc, I have the following:

```vim
if has('clipboard') && (v:version > 703 || (v:version == 703 && has('patch074')))
  set clipboard^=unnamedplus
endif
```

I resisted turning this on for a long time, even coming up with complicated
plugins to ease access to the system clipboard. But at some point I had the
thought that when I use Emacs, unnamedplus is the default behavior, and I've
never had a problem with it when using Emacs, so why should I have a problem
with it when using Vim? Emacs does have a setting called
`save-interprogram-paste-before-kill`, and turning that on saves the system
clipboard to the kill ring before doing a copy operation within Emacs, which
means you can't accidentally overwrite what you were about to paste into
Emacs by e.g. deleting something else before pasting. As far as I know, Vim
doesn't have a setting like this. But the whole reason why
`save-interprogram-paste-before-kill` is useful in Emacs is that in Emacs, if
you select some text and then press C-y to paste, it won't paste to replace
the selected text; instead, it just inserts the contents of the paste at the
cursor, completely ignoring the selection, which motivates killing the
region first before pasting. Vim doesn't have this problem, so Vim doesn't
really need `save-interprogram-paste-before-kill`. All of this to say that
I've been trying unnamedplus out for a bit now and I like it.

## Working with tags

I really like Neovim's default of:

```vim
set tags=./tags;,tags
```

It's not obvious _why_ this is the best value for this setting, so I thought
I would explain why.

The option has two comma-separated values, `./tags;` and `tags`.

`./tags;` means "search for a file named `tags` (that's what the `tags` means)
in the directory that the current file is in, i.e. whatever `:echo
expand('%:h')` outputs (that's what the `./` means). And then if a tags file is
not found there, keep recursing upwards from that directory until a tags file
is found (that's what the `;` means)".

For more information, see:

* `:help tags-option` for what the `./` means
* `:help file-searching` for what the `;` means

I like this because sometimes I want to navigate via tags when I am editing
a file that isn't part of my current project/working directory. If so, I
wouldn't want Vim to use the tags file associated with my current project;
instead, I want Vim to use the tags file that is near the file I am editing.
So we prioritize searching the tags file closest to the current file being
edited.

However, there is another scenario that I've encountered, where I am editing
files in my project directory most of the time, but I've downloaded a
library I am using in some different spot on my computer for reference, or
maybe it's in `/usr/include`. In such a case, I don't actually have a tags
file in the library directory (because I want to keep the library directory
clean, or because it's `/usr/include` so I don't have write permissions);
instead, I use `ctags -a --kinds-C=+p -R /path/to/library` to append to my
current ctags file, so that I have one big tags file with both tags for my
own code and the library. In this case, I want Vim to also look for the tags
file in my current working directory, i.e. whatever `:pwd` outputs. That's
what the final `tags` means: search in the pwd.

## Making the mouse work in Vim under tmux

By default in Vim the mouse does not work at all. I like to do:

```vim
if has('mouse')
  set mouse=nvi
endif
```

so that the mouse works in normal, visual, and insert mode.
I should explain the insert mode part, since people who have read
_Practical Vim_ will know about the "go back to normal mode when you
pause your thoughts" idea: if you're reaching for the mouse, then
haven't you by definition paused the thought you had while typing,
in order to do something else? That's what I thought for a long time,
but then I encountered a situation where I was typing something, but
then as I was typing, I had the man page open in a separate tab, and
wanted to look something up. I could have exited insert mode, but
I had instinctively reached for the mouse to scroll a bit in the man
page split, and was surprised to find the screen didn't scroll, and
instead my cursor moved! So that experience convinced me that having
`i` in the `mouse` option is actually useful.

However, even after turning the mouse on, mouse dragging will not
work as expected in Vim under tmux. When you release the mouse,
the visual selection will expand to the expected location, but as
you are dragging the mouse around, the visual selection won't update.
To fix this, you need to set the correct value of `ttymouse`.
Something like this:

```vim
if !has('nvim') && exists('$TMUX')
  set ttymouse=xterm2
endif
```

My final mouse configuration looks like this:

```vim
silent! while 0
  silent! set mouse=nvi
silent! endwhile
if has('mouse')
  set mouse=nvi
  if !has('nvim') && exists('$TMUX')
    set ttymouse=xterm2
  endif
endif
```

(The `silent! while 0` and `if 1` are for doing conditional action based on whether
Vim was compiled with `+eval` or not.)

## Rust textwidth

Vim sets the textwidth to 99 for Rust files by default, which I find
annoying (I prefer either 80 if I'm formatting comments or no hard limit
so that my lines don't unpredictably wrap, so a limit of 99 is both too
large and too small!).

```vim
autocmd FileType rust setlocal textwidth=0
```

## formatprg

By default, Go and Rust files have formatprg=gofmt and
formatprg=rustfmt, respectively. This may seem ideal, but actually, I
prefer to run gofmt/rustfmt in bulk via gofmt -w or rustfmt src, and
also gofmt and rustfmt don't format long comments, and comments are
pretty much the only thing I use commands like gq for. So basically gq
becomes useless in Go and Rust files, which is not what I want. By
setting this to be empty, the default Vim formatter takes over, and
comment formatting works as usual.

```vim
autocmd FileType go,rust setlocal formatprg=
```

## makeprg

Vim tries to be smart by setting the makeprg for Rust files to use Cargo
if Cargo is detected and otherwise use rustc. However, when it uses
rustc, it tries to run rustc on the current file, which is annoying
(since the file I happen to be editing may not be the main/entrypoint of
the project). For now, I am setting it back to just 'make', as I will
probably usually have a makefile.

```vim
autocmd FileType rust if &makeprg =~# '^rustc ' | setlocal makeprg=make | endif
```

## Haskell shebang

Make shebang lines be highlighted as comments in Haskell files, so that
Haskell files can be used as scripts, with `#!/usr/bin/env runhaskell`.
The default highlighting makes the line all red, which is visually
jarring.

```vim
autocmd FileType haskell syntax match hsLineComment '^#!.*'
```

## formatoptions

Many filetype plugins add the 'o' and this is really annoying; I like it
when the comment character automatically gets inserted if I hit enter,
but not when I use o to start a new line. It's not possible to set this
as a normal option along with the other formatoptions above, because the
filetype plugins get sourced after the vimrc file, so the 'o' will just
get added later. So we need to run this as an autocommand.

```vim
set formatoptions=tcrqj
autocmd FileType * set formatoptions-=o
```

## Better j and k

I am trying out the following as an experiment.
When programming I don't really mind
the default behavior of Vim (i.e. moving by logical lines, not visual lines)
and I even like it better, but when editing
markup files like Markdown, it's nice to not have to constantly think about
what is a visual vs logical line.

In visual line and visual block modes, as well as in the quickfix window,
I also always want to move by logical lines, so I check for those as well.

```vim
if 1
  nnoremap <expr> j v:count > 0 \|\| &filetype ==# 'qf' ? 'j' : 'gj'
  nnoremap <expr> k v:count > 0 \|\| &filetype ==# 'qf' ? 'k' : 'gk'
  xnoremap <expr> j mode() ==# 'V' \|\| mode() ==# "\<C-V>" \|\| v:count > 0 ? 'j' : 'gj'
  xnoremap <expr> k mode() ==# 'V' \|\| mode() ==# "\<C-V>" \|\| v:count > 0 ? 'k' : 'gk'
endif
```

The `if 1` is because `<expr>` mappings don't work in vim-tiny.

## Visual star search for Vim

Neovim has visual star search by default. The following is an implementation
for Vim.

This implementation most closely resembles
https://github.com/nelstrom/vim-visual-star-search which is what I used for
years, back when I was using lots of plugins. But now I've [decided to not
use any plugins](#why-no-vim-plugins), so as to simplify my Vim configuration. I thought I could
just live without visual star search, but I've reached for it on a number of
occasions, so I decided to try to reimplement it from scratch, referencing
other implementations but really trying to understand what is going on.

In doing so, I discovered that Drew Neil's implementation has a flaw in that if
you put your cursor on a question mark, press `v`, then press `#` to search
backwards, then press `/` to start a forward search, then press up-arrow to go
back in history, the search pattern displayed is `\V\?` which is actually an
invalid search string!

The problem is that because the search history was
created using `#`, we passed `?` to the list of characters to escape in the
call to `escape()`, which means that the search history now contains `\?` even
when later performing a forward search (somewhat confusingly, `\?` is a valid
search pattern when doing a backward search but not when doing a forward
search).

I think that Drew Neil did this so that when he does the actual
search in the mapping, as he does with `?<C-R>=@/<CR><CR>` the search actually
works; if he hadn't escaped the `?` then doing `?<C-R>=@/<CR><CR>` would search
for just `\V` which is not what we want (the problem is that `@/` gets set to
`\V?` but when doing a backward search, a trailing `?` gets ignored as it is the
bookend to the search command).

And I think he decided to do the actual
search with the complicated `?<C-R>=@/<CR><CR>` instead of just `?<CR>` because
he wanted to make sure to add the visual star search to the search history
(Vim doesn't add to the search history if you just do `/<CR>` or `?<CR>` even if
it's the first time you've done that search). He probably just didn't know
about `histadd()`, which programmatically adds the search term to the history,
so then we can get away with doing just `/<CR>` for the actual search. And
that means we no longer need to escape `/` or `?` because Vim automatically does
the proper escaping when switching the search direction (try it: search
forward for `?` and then search backward but up-arrow to grab the previous
search; you'll find that the `?` got escaped to become `\?`; for some odd
reason this doesn't seem to work in reverse, so maybe Drew Neil's
implementation shouldn't be considered wrong...), which means that we don't
run into weird issues when repeating the search in a different direction. As
a bonus, doing visual star on a long visual selection won't prompt us to
press enter.

My implementation is here:
<https://github.com/riceissa/dotfiles/blob/5b324dd55d05df287001873f550e833ecfbdebb1/.vimrc#L121-L135>

## Why no `c_comment_strings`

It might sound nice to highlight strings in comments.
But this one turned out to have false
positives which was very annoying. For example, in a C file if you have a
comment that looks like:

```c
// you'll ... 'blah'
```

then everything between the first two single quotes (rather than everything
between the second and third single quotes) is highlighted in a different
color than the rest of the comment.

```vim
unlet! c_comment_strings
```

I thought not sourcing defaults.vim would mean that I don't need to do this
anymore in my vimrc, but Fedora's `/etc/vimrc` has the same thing, and
there is no way to tell Vim to not use the system vimrc (other than aliasing
the `vim` command to something like `vim -u ~/.vimrc`) so I'll just have
to keep this.

## Why `c_no_curly_error`

I came across this one while working through the book Crafting Interpreters.
In default Vim, with a macro like:

```c
#define BOOL_VAL(value)   ((Value){VAL_BOOL, {.boolean = value}})
```

the curly braces get colored with a red background, indicating some sort of
error. Apparently this is because in ancient versions of C, this sort of
thing was not allowed. But this is totally legal in most versions of C. The
following makes it so that this kind of macro is not highlighted in red. For
more, see `:help ft-c-syntax`.

```vim
let c_no_curly_error = 1
```

## Why `nostartofline`

I kind of prefer that when I toggle buffers with Ctrl-^ the cursor doesn't
move when I toggle back to the buffer I was on. However, this also changes
the behavior of a bunch of other movements, which I might not like.

```vim
set nostartofline
```

## rsi.vim

These are basically taken from Tim Pope's rsi.vim, but [I didn't want to use
any plugins](#why-no-vim-plugins), so I just
reimplemented the subset of mappings that I find particularly useful. See
also `:help emacs-keys`.

```vim
inoremap <C-A> <C-O>^
inoremap <C-X><C-A> <C-A>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>
inoremap <C-B> <Left>
cnoremap <C-B> <Left>
silent! while 0
  inoremap <C-D> <Del>
  inoremap <C-E> <End>
  inoremap <C-F> <Right>
  cnoremap <C-F> <Right>
  cnoremap <C-X><C-E> <C-F>
silent! endwhile
if 1
  inoremap <expr> <C-D> col(".") >= col("$") ? "<C-D>" : "<Del>"
  cnoremap <expr> <C-D> getcmdpos() > strlen(getcmdline()) ? "<C-D>" : "<Del>"
  inoremap <expr> <C-E> col(".") >= col("$") ? "<C-E>" : "<End>"
  inoremap <expr> <C-F> col(".") >= col("$") ? "<C-F>" : "<Right>"
  cnoremap <expr> <C-F> getcmdpos() > strlen(getcmdline()) ? &cedit : "<Right>"
  cnoremap <expr> <C-X><C-E> &cedit
endif
```

`<expr>` mappings don't work in vim-tiny so I give alternative fallback options.

## Markdown underscores

Underscores in Markdown files usually mean emphasis, so should not be
counted as part of the word. The following autocommand
makes searching for emphasized phrases
work with motions like `*`. For example, if a string like `_hello world_`
appears in a Markdown document, pressing `*` when the cursor is on the `h`
would by default search for the string `_hello`. Having the following
autocommand makes it search for `hello` instead, producing symmetry with
`*`-style emphasis like `*hello world*`.

```vim
autocmd FileType markdown setlocal iskeyword-=_
```

## Fix gc in vim files in Neovim

Fix gc motions in Neovim; for some reason by default Neovim doesn't add
a space after the quote.

```vim
autocmd FileType vim setlocal commentstring=\"\ %s
```

## Disable vim hints

This disables the annoying explanation that pops up every time you press
Ctrl-f in command mode.

```vim
if exists('#vimHints')
  autocmd! vimHints
endif
```

## Python indent

I find the default indentation style for lists and dictionaries really
annoying.

For example, in default Vim/Neovim, lists get indented like this:

```python
lst = [
        "a",
        "b",
        "c",
        ]
```

The following variables will change the indentation settings to make
lists look like this instead:

```python
lst = [
    "a",
    "b",
    "c",
]
```

See `:help ft-python-indent` for what the following means.

```vim
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.closed_paren_align_last_line = 0
let g:pyindent_open_paren = '&sw'
```

The documentation uses `v:false` instead of `0` but I've found that this causes an error on older versions of Vim
from before `v:false` was introduced.  Rather than checking for the exact patch number, and then doing
something else for older versions of Vim, or something complicated like that, I've decided to just
use `0` which evaluates to false and produces the same behavior.

The extra line for `g:pyindent_open_paren` is for older versions of Vim that don't use the
`g:python_indent` dictionary. Having both styles of configuration doesn't seem to confuse
either newer or older versions of Vim, so instead of checking for a patch number (which is
not easy, given that updates to Vim runtime files often appear between patches, rather
than being patches themselves), I have decided to just include both styles of configuration.
There is no equivalent of `closed_paren_align_last_line` in the older, `g:pyindent_*` style
of configuration, so that's why there's nothing there in place of it.

## wildoptions

Tab-completing in command mode in Vim by default shows matches horizontally,
meaning only a few matches can be shown on the screen. Having `pum` in the
`wildoptions` makes matches be displayed vertically instead (just like in
insert mode), allowing more matches to be shown. Including `tagfile` shows
the kind and location of tag when doing `:tag <Ctrl-D>` which seems helpful,
but I mostly only included it because it's included by default in Neovim.

```vim
silent! while 0
  set wildoptions=tagfile
  silent! set wildoptions=pum,tagfile
silent! endwhile
if has('nvim') || has('patch-8.2.4325')
  set wildoptions=pum,tagfile
else
  set wildoptions=tagfile
endif
```

Patch 8.2.4325 is the patch in Vim where `pum` became available; before that
version, Vim gives an error message if you try to set `wildoptions` with `pum`.
See `:help patches-9` in Vim and then search for "4325".

The -eval version is a bit weird, but basically, we set `wildoptions` to just
`tagfile`, because that is always possible. And then, we try to set it to also
include `pum`, but we do so under `silent!` because if `pum` is not a valid
value on an older Vim version, we don't want to see an error message for that.
The end result is that this implements the same logic as the +eval version, but
in a kind of wacky way.

## Make the escape key more responsive

```vim
set ttimeout ttimeoutlen=50
```

## Loading defaults.vim from vimrc

If you _don't_ have a vimrc, then Vim will automatically source defaults.vim
for you. But if you have an empty vimrc, then Vim _won't_ source defaults.vim.
So if you have any vimrc at all, and you want defaults.vim to be sourced,
you need to explicitly tell Vim to load defaults.vim.

The following is the recommended way to load defaults.vim;
see `:help defaults.vim`.

```vim
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif
```

## File type plugins, syntax highlighting, EditorConfig, commentary, matchit, man.vim

Newer versions of Vim ship with some useful plugins like EditorConfig,
commentary.vim-like commenting, and a way to browse man pages.
But even though Vim _ships with_ these plugins, they are not enabled
by default. So here's how I enable them:

<https://github.com/riceissa/dotfiles/blob/88f1a8c690123e4b83b9c3b3a2ae5df907bc4e65/.vimrc#L5-L23>

The initial conditional check is because on Neovim, all of these plugins are
loaded by default.

The other checks look complicated, but they are just there to only do things
if they weren't already done by a system vimrc file, and also to
prevent error messages from being displayed in
older versions of Vim that don't have these plugins.

## Picking separate light and dark themes with automatic switching based on OS theme

I like to use a light terminal during the day and a dark terminal
at night. My OS has a global light/dark switch. Is there a way to get
Vim to respect this, and automatically switch themes based on the OS theme?

Here is the only way I've figured out how to do this. It only works with
the combination of kitty as the terminal and Neovim as the Vim variant.

Add an autocommand like the following:

```vim
autocmd OptionSet background
  \   if &background ==# 'light'
  \ |   colorscheme vim
  \ |   set notermguicolors
  \ | else
  \ |   colorscheme default
  \ |   set termguicolors
  \ | endif
  \ | let &ft = &ft
```

And also make sure that you do _not_ have a bare `set background` anywhere else
in your vimrc (having this seems to confuse Neovim and it will not try to touch
the `background` option ever again). The `termguicolors` is just because I
prefer the default Vim theme without termguicolors, but I prefer the default
Neovim theme with termguicolors.

The only downside I've observed is that if you start Neovim with certain filetypes
(like `.vim` files), then in light mode there is a slight flicker where the screen
is black for a split second and then becomes the correct light color. But starting
Neovim with just `nvim` (without filename) or opening other filetypes (like C files)
doesn't have this problem. I don't know what's special about the `.vim` files.

The `let &ft = &ft` might seem absurd, but it's a hack to prevent
italics and bold from disappearing from markup files.
Try this:

```bash
nvim --clean hello.md
```

Now type:

```markdown
*hello* **hello**
```

There should be italics and bold that you can see. Now do:

```vim
:colorscheme vim
```

The italics and bold should disappear! This is _not_ because
the vim theme doesn't have italics and bold; it actually does,
but changing the colorscheme hid the markup. To get it back,
do this:

```
let &ft = &ft
```

Telling Neovim to re-register the filetype of the current buffer
for some reason brings back the markup! I hope this will be fixed
in future versions so that this kind of hack is not needed.

And here is a more complicated version that I came up with to try to fix the
spelling highlighting so that it uses undercurls. In the end I decided the
complexity of this approach was not worth the slight visual improvement, but
I'm saving it here just in case:

```vim
" The first if-case in the following must be run as an autocommand because
" every time 'background' changes, Neovim resets the highlight for the
" spelling back to the default.
autocmd OptionSet background
      \   if has('nvim-0.10') && exists('$TERM') && ($TERM ==# 'xterm-kitty' || $TERM ==# 'xterm-256color')
      \ |   highlight SpellBad   ctermbg=NONE cterm=undercurl
      \ |   highlight SpellCap   ctermbg=NONE cterm=undercurl
      \ |   highlight SpellLocal ctermbg=NONE cterm=undercurl
      \ |   highlight SpellRare  ctermbg=NONE cterm=undercurl
      \ | elseif &background ==# 'dark'
      \ |   highlight clear SpellBad
      \ |   highlight clear SpellCap
      \ |   highlight clear SpellLocal
      \ |   highlight clear SpellRare
      \ |   highlight SpellBad   cterm=underline ctermfg=167 gui=undercurl guifg=#cd5c5c guisp=#cd5c5c
      \ |   highlight SpellCap   cterm=underline ctermfg=111 gui=undercurl guifg=#75a0ff guisp=#75a0ff
      \ |   highlight SpellLocal cterm=underline ctermfg=222 gui=undercurl guifg=#ffde9b guisp=#ffde9b
      \ |   highlight SpellRare  cterm=underline ctermfg=112 gui=undercurl guifg=#9acd32 guisp=#9acd32
      \ | elseif &background ==# 'light'
      \ |   highlight clear SpellBad
      \ |   highlight clear SpellCap
      \ |   highlight clear SpellLocal
      \ |   highlight clear SpellRare
      \ |   highlight SpellBad   term=reverse   ctermbg=224 gui=undercurl guisp=Red
      \ |   highlight SpellCap   term=reverse   ctermbg=81  gui=undercurl guisp=Blue
      \ |   highlight SpellLocal term=underline ctermbg=14  gui=undercurl guisp=DarkCyan
      \ |   highlight SpellRare  term=reverse   ctermbg=225 gui=undercurl guisp=Magenta
      \ | endif
      " \ | let &filetype = &filetype
```

## Why `set nocompatible`

When Vim detects the presence of a vimrc file, it automatically sets nocompatible.
So in most situations I don't need to manually set nocompatible in my vimrc.
But Debian-based systems use vim-tiny by default, which lacks many of the
features of normal Vim (like `+eval`) and also sets `compatible` by default.
This means in particular that they include the `C` option in `cpoptions`,
which disallows backslash line continuation. Since I use backslash line continuation
in my vimrc, without the `set nocompatible`, the vimrc file will result in errors.
See `:help E10` for more information.

Now, I don't really want to support vim-tiny,
as I don't really expect to use it much. But I at least don't want my vimrc
to throw a bunch of warnings if my vimrc happens to get sourced by vim-tiny
before a feature-full Vim version gets installed.
So that's why I've decided to add that extra line to force `nocompatible`
at the start of my vimrc, even though it's not necessary in most variants of Vim.

## Why no Vim plugins

Starting in July 2025, I decided to stop using plugins for Vim
(other than the plugins that ship with Vim, namely EditorConfig, comment,
matchit, and man.vim).
Instead, I just have a single vimrc file (currently around 350 lines) with all my
configuration. Here I talk about some of the reasons I made this switch.
In short the reason is "because plugins increase the complexity of my Vim setup
and increase surface area for annoying problems", but in more detail:

- Supply chain attacks. Most Vim plugins are just repos on GitHub that are
  maintained by one person, or sometimes a small group of people. Theoretically
  GitHub could detect if a plugin is compromised, but I don't think GitHub has
  the resources to be checking these random repos with any regularity. Browser
  extensions have had issues where random companies buy the rights to the
  extension and then inject malicious code. Package repos for programming
  languages (like npm) have had supply chain attacks in recent years. I don't
  think Vim plugin authors are particularly exceptional compared to these other
  situations, so it seems like the safest thing to do is to not rely on
  plugins.

  Even before I stopped using plugins, I had a system in place where I
  used specific commit hashes of each plugin, so that the plugin couldn't
  randomly get "upgraded" to some potentially malicious version (but of course,
  that means that if there's a security issues with a plugin, I won't get that
  update unless I manually grab the new commit hash).

- Many plugins are kind of janky compared to base Vim. I've had problems with
  surround, gutentags, and splitjoin in particular, where I like the general
  thing that the plugin aims to do, but in some weird edge cases I run into
  problems and I don't really feel like reporting a bug or the project is
  unmaintained.

  Sometimes, the plugins are essentially/unavoidably janky due to the way Vim
  exposes functionality to plugin authors (e.g. vim-repeat).

- Lack of respect for user by changing stuff in backwards-incompatible ways.
  This one mainly applies to fugitive. I got so used to typing `:Gwr` and then
  suddenly that stopped working and I had to type `:GWr` (with a capital W)
  instead, and for every single fugitive command I had to remember if there was a capital
  letter or a lowercase letter.
  Or I was used to typing `:Gst` but then that stopped working and I
  had to type `:G` instead. (I might be recalling one of these incorrectly, but
  there was definitely something along these lines.)

- Some plugins work well on Linux but not Windows, or less well on Windows.
  Due to the way Git works on Windows, fugitive never worked well on Windows so
  I got into a habit of just using the GitBash terminal for all my git stuff.

- Hassle of managing the installation; needing to get a plugin manager, then
  install the plugins. And now Vim has its own package system with `:packadd`,
  but it's even more annoying to use compared to vim-plug. And Neovim is now
  planning to add an even more advanced package manager that will probably work
  like vim-plug, but it won't be in Vim so then my configuration won't be
  compatible across Vim and Neovim. It's just a complete mess.

- I will be slightly less annoyed whenever I need to use a Vim or vi or
  something that doesn't have my configuration. I'm setting enough options and
  mappings that if I ever need to use an unconfigured Vim I will notice this
  pretty much immediately and be pretty annoyed, but plugins tend to add even
  more complicated functionality that is not easy to replicate in stock Vim, so
  I would be even more annoyed if I had to use stock Vim after getting used to
  plugins.

I notice a pattern here where maybe it's fugitive that's the problem; but
fugitive is also the most useful plugin probably, so it's tricky!
