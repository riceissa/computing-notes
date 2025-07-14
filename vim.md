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
