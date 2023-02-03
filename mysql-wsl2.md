# setting up MySQL on WSL2 after upgrading from WSL1

For some reason, after upgrading from WSL1 to WSL2, MySQL would not run correctly. Specifically, starting the service with

```
sudo service mysql status
```

would work, but then typing

```
mysql
```

would result in the error:

```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (13)
```

I ended up using [this answer](https://stackoverflow.com/a/66949451/3422337) on Stack Overflow.
I don't understand it, and the `777` permissions make me nervous, but at least it resulted in
MySQL working again.  I hope to come back to this soon and produce a better solution with
explanations of why things work.
