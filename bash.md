# Clean up bash history

Having `HISTCONTROL=ignoreboth:erasedups` keeps the command history within a
single bash session unique (which deals with annoying things like having to
up-arrow multiple times to skip past duplicates), but at the end of the session
bash will just append all the unique commands from that session to
`~/.bash_history`, so `~/.bash_history` will have duplicates of any command
that was run in more than one terminal session.

The following command will remove any duplicates from `~/.bash_history`:

```bash
wc -l ~/.bash_history && tac ~/.bash_history | awk '!seen[$0]++' | tac > ~/.bash_history.tmp && cat ~/.bash_history.tmp > ~/.bash_history && rm ~/.bash_history.tmp && wc -l ~/.bash_history
```
