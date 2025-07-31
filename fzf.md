## Installing fzf for Bash

On newer versions of fzf, just add this line to `~/.bashrc`:

```bash
eval "$(fzf --bash)"
```

On older versions of fzf, you must find the location of the `key-bindings.bash` file:

```bash
find / -name "key-bindings.bash" 2>/dev/null
```

On Ubuntu and similar distros, the location should be `/usr/share/doc/fzf/examples/key-bindings.bash`
and you can add the following to your bashrc:

```bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
```

On Fedora and similar distros, the location should be `/usr/share/fzf/shell/key-bindings.bash`
and you can add the following to your bashrc:

```bash
[ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash
```
