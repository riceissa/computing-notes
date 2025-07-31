## Moving a git repo from one computer to another (while also preserving messy state of directory)

The use-case here is that I have a git repo with a bunch of uncommitted files/scratch work/private credentials that I can't commit,
and I want to just transfer over this entire state of the directory without doing something like a git-pull from the new
computer followed by a separate step of copying over all the uncommitted files.

On the computer that has the git repo:

```
tar -cvpzf archive.tar.gz directory-name/
```

Above, `archive.tar.gz` is supposed to be a new filename; it's the destination.
On the other hand, `directory-name/` is the existing directory to tar up.

On the new computer:

```
tar -xvpzf archive.tar.gz
```

(I'm not sure the `-p` flag does anything when extracting.
There's also a `--same-owner` flag that can be passed when extracting,
but I didn't need to use this to get what I want.)

For tar-ing up a whole bunch of directories separately, something like the following works nicely:

```bash
for $dir in *; do echo tar -cpzf $dir.tar.gz $dir; done
```

The missing `-v` flag so that you can actually notice the error messages, if there are any.

