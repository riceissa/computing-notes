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
a random spot in the file. So I clear out the augroup that contains this
autocommand. A working implementation is already in `defaults.vim` which ships
with Vim, so I don't know why they decided that adding it in again was a good
idea.

```vim
if exists('#fedora')
  autocmd! fedora
endif
```

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

## Clipboard management

In my vimrc, I have the following:

```vim
if has('clipboard')
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
  set mouse=nv
endif
```

so that the mouse works in normal mode and visual mode.

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
if has('mouse')
  set mouse=nv
  if !has('nvim') && exists('$TMUX')
    set ttymouse=xterm2
  endif
endif
```

## Restore cursor in Neovim

Vim has a restore-cursor autocommand in `defaults.vim`, but Neovim does
not ship with such an autocommand. They do list it in the help files
though. I just copy the version in `:help restore-cursor`.

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

In visual line and visual block modes, I also always want to move by
logical lines, so I check for those as well.

```vim
nnoremap <expr> j v:count > 0 ? 'j' : 'gj'
nnoremap <expr> k v:count > 0 ? 'k' : 'gk'
xnoremap <expr> j mode() ==# 'V' \|\| mode() ==# "\<C-V>" \|\| v:count > 0 ? 'j' : 'gj'
xnoremap <expr> k mode() ==# 'V' \|\| mode() ==# "\<C-V>" \|\| v:count > 0 ? 'k' : 'gk'
```

## Visual star search for Vim

Neovim has visual star search by default. The following is an implementation
for Vim.

This implementation most closely resembles
https://github.com/nelstrom/vim-visual-star-search which is what I used for
years, back when I was using lots of plugins. But now I've decided to not
use any plugins, so as to simplify my Vim configuration. I thought I could
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

```vim
if !has('nvim')
  function! s:VisualStarSearch()
    let temp = @s
    normal! gv"sy
    let search = '\V' . substitute(escape(@s, '\'), '\n', '\\n', 'g')
    call setreg('/', search)
    call histadd('/', search)
    let @s = temp
  endfunction
  xnoremap * :<C-U>call <SID>VisualStarSearch()<CR>/<CR>
  xnoremap # :<C-U>call <SID>VisualStarSearch()<CR>?<CR>
endif
```

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

## Show number of matches when searching

Neovim has this by default, but in Vim you can do:

```vim
set shortmess-=S
```

## Why `nostartofline`

I kind of prefer that when I toggle buffers with Ctrl-^ the cursor doesn't
move when I toggle back to the buffer I was on. However, this also changes
the behavior of a bunch of other movements, which I might not like.

```vim
set nostartofline
```

## rsi.vim

These are basically taken from Tim Pope's rsi.vim, but I didn't want to use
any plugins (which would increase the complexity of my Vim setup), so I just
reimplemented the subset of mappings that I find particularly useful. See
also `:help emacs-keys`.

```vim
inoremap <C-A> <C-O>^
inoremap <C-X><C-A> <C-A>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>
inoremap <expr> <C-E> col(".") >= col("$") ? "<C-E>" : "<End>"
inoremap <expr> <C-F> col(".") >= col("$") ? "<C-F>" : "<Right>"
cnoremap <expr> <C-F> getcmdpos() > strlen(getcmdline()) ? &cedit : "<Right>"
inoremap <C-B> <Left>
cnoremap <C-B> <Left>
inoremap <expr> <C-D> col(".") >= col("$") ? "<C-D>" : "<Del>"
cnoremap <expr> <C-D> getcmdpos() > strlen(getcmdline()) ? "<C-D>" : "<Del>"
```

## Markdown underscores

Underscores in Markdown files usually mean emphasis, so should not be
counted as part of the word. This makes searching for emphasized phrases
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
annoying. See `:help ft-python-indent` for what the following means.

```vim
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.closed_paren_align_last_line = v:false
```

## wildoptions

Tab-completing in command mode in Vim by default shows matches horizontally,
meaning only a few matches can be shown on the screen. Having 'pum' in the
following option makes matches be displayed vertically instead (just like in
insert mode), allowing more matches to be shown. Including 'tagfile' shows
the kind and location of tag when doing `:tag <Ctrl-D>` which seems helpful,
but I mostly only included it because it's included by default in Neovim.

```vim
if has('nvim') || has('patch-8.2.4325')
  set wildoptions=pum,tagfile
else
  set wildoptions=tagfile
endif
```

Patch 8.2.4325 is the patch in Vim where `pum` became available; before that
version, Vim gives an error message if you try to set wildoptions with pum.
See `:help patches-9` in Vim and then search for "4325".

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

## EditorConfig, commentary, man.vim

Newer versions of Vim ship with some useful plugins like EditorConfig,
commentary.vim-like commenting, and a way to browse man pages.
But even though Vim _ships with_ these plugins, they are not enabled
by default. So here's how I enable them:

```vim
if !has('nvim')
  silent! packadd! editorconfig
  silent! packadd! comment
  runtime ftplugin/man.vim
  set keywordprg=:Man
endif
```

The conditional check is because on Neovim, all of these plugins are
loaded by default.

The `silent!` is to prevent error messages from being displayed in
older versions of Vim that don't have these plugins.

## Default theme in Neovim

I find the new default Neovim light theme to be too low-contrast and
feel like all the colors blend together making it hard to distinguish
different parts of the syntax, but I like the new default dark theme. So
toggle some options whenever the background color changes.

```vim
if has('nvim-0.10')
  autocmd OptionSet background
    \   if &background ==# 'light'
    \ |   colorscheme vim
    \ |   set notermguicolors
    \ | else
    \ |   colorscheme default
    \ |   set termguicolors
    \ | endif
    \ | let &ft = &ft
endif
```

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

## Why `set nocompatible`

I source defaults.vim, so in most situations I don't need to set nocompatible.
But Debian-based systems use vim-tiny by default, which doesn't have the +eval
feature. So the line that sources defaults.vim is never run. This means that
later on in the file, when I use some backslash escapes for line continuation,
Vim complains about syntax errors. Now, I don't really want to support vim-tiny,
as I don't really expect to use it much. But I at least don't want my vimrc
to throw a bunch of warnings if my vimrc happens to get sourced by vim-tiny.
So that's why I've decided to add that extra line to force nocompatible
at the start of my vimrc, even though it's included in defaults.vim.
