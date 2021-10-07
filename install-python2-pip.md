# Installing pip for python2 on Ubuntu in 2021

Ubuntu still seems to have a package/command called `python2`, but all the python2-* packages have been removed
from the repos. Here's what I had to do to get this working (why did I need python2? because [wikiteam](https://github.com/WikiTeam/wikiteam)
still requires python2).

```
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python2 get-pip.py
# verify we have installed pip:
python2 -m pip -V

# if that worked, we can get on with business, e.g.:
python2 -m pip install --upgrade -r requirements.txt
```
