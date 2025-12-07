## For Git repositories

To check if a git repo can just be deleted (because all the data in the repo is already on GitHub/remote), run the script [here](https://github.com/riceissa/dotfiles/blob/master/.local/bin/check-git-repo-can-be-deleted.sh).
Once that script is installed and available in `PATH`, it can be used like this inside of the root of the Git repo:

```bash
check-git-repo-can-be-deleted.sh
```

If there is no output, that means the Git repo _should_ be safe to delete.
If there is any output, that means that the repo has _something_ (untracked file, uncommitted changes to tracked file, unpushed commits, stashed changes, etc.) that is not in the remote.

If a Git repo needs to be backed up, use the instructions [here](tar.md#moving-a-git-repo-from-one-computer-to-another-while-also-preserving-messy-state-of-directory).

## Syncing up directories

Let's say I have a folder called `Music` on one of my backup drives, and another folder that is also called `Music` on another backup drive.
These folders probably started out the same, and in fact one of them may have been the basis of the other.
It would be nice to merge these two folders so that there is just one master music collection.
Here's how I've been doing this so far:

```bash
rsync -rcv --dry-run --itemize-changes /older/Music/ /newer/Music/
```

Above, `/older/Music/` is the path to the music folder that is probably older, i.e., the folder that you want to copy _from_, and `/newer/Music/` is the music folder that is probably newer, i.e., the music folder that you are copying _to_, the one that is going to become the "master" music collection.
The trailing `/` in the path is important; it tells rsync to match the folders up and only compare what's inside.
Without the slash on the source (older), it would try to copy the entire Music folder into the destination, so that you'd end up with `/newer/Music/Music`.
