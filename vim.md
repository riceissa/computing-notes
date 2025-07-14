# Vim

By default in Vim (not Neovim), using `:set spell` and then `zg` on a misspelled word to
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
