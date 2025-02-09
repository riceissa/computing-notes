# Setting up MySQL on WSL1

(i forgot to record the steps for the initial setup; do this later. i remember that i had to do something like log in as root and then grant access to my user.)

For some reason, MySQL is not automatically started every time I start up the WSL console. I have to run the following to start MySQL:

```
sudo /etc/init.d/mysql start 
```

When I do this, however, I get the following:

```
su: warning: cannot change directory to /nonexistent: No such file or directory 
```

MySQL still works, but this error is somewhat worrying. Looking around, I found [this answer](https://stackoverflow.com/a/63040661/3422337), which does the trick. Just run:

```
sudo /etc/init.d/mysql stop
sudo usermod -d /var/lib/mysql/ mysql
sudo /etc/init.d/mysql start
```

Verify that the error no longer appears when starting MySQL.


to get mysql to start automatically, i'm trying out the following command which i found [here](https://askubuntu.com/a/416312):

```
sudo update-rc.d mysql defaults
```

(this didn't end up working; will have to figure out something else later)
