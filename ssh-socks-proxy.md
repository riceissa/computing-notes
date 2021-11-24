# How to start a SOCKS proxy using ssh and connect to it using Firefox

## Set up the proxy

On your local machine (not on the VPS), run:

```
ssh -D 8123 -N Your_VPS_name
```

The `-D` flag starts a SOCKS proxy at the specified port (the port number can be any unused number, I think).
The `-N` flag I'm not entirely sure what it does, but the man page says it's useful for forwarding.

Some flags that are sometimes recommended on guides but don't seem to be necessary:

* `-f`: this one "hides" the ssh process to the background (kind of like ctrl-z on the shell).
  I don't like this since to stop the proxy, you have to use ps/pgrep to find the ssh process and then kill it.
  I am already using multiple shells or tmux anyway, so I don't mind ssh taking up the shell.
* `-C`: this just compresses the data. The man page says "will only slow down things on fast networks". I'm not
  sure I've noticed any difference.

## Firefox options

Now in Firefox, go to `about:preferences` in the URL bar.
Search "network" to find the Network Settings, then click Settings.

![image](https://user-images.githubusercontent.com/1450515/143175876-aa321b75-a76f-486c-9e57-1c6d7b9b5c69.png)

(By default, my Firefox had "Use system proxy settings".)

Now just fill in the "Manual proxy settings" using `127.0.0.1` (localhost) as the host, and the same port number as was specified in the ssh command:

![image](https://user-images.githubusercontent.com/1450515/143175993-11e39ee9-e014-423f-b547-3704bbd3129c.png)

Then click OK. Try going to a site like https://whatismyipaddress.com/ to verify it worked.

To stop the proxy, just process ctrl-c in the shell. Now if you reload a page in Firefox, you should get a connection error.
Once the proxy has been stopped, go back into Firefox network settings and switch back to "Use system proxy settings".

## Windows options

Alternatively, instead of entering the proxy info into Firefox, it's possible to do this at the OS level.
This alternative method will also work for other apps.  This is especially useful for Chrome, since
Chrome doesn't offer an option for entering proxy info.

The steps I used that work are from [here](https://www.reddit.com/r/techsupport/comments/4j0l35/windows_10_route_all_traffic_through_socks5_proxy/d333zxc/):

* Open Control Panel (not Settings!)
* Network and Internet -> Internet Options
* A window will pop up. Now go to the Connections tab.
* Click "LAN settings" button; this will open another popup.
* Check the box that says "Use a proxy server for your LAN"
* Click Advanced; this will open yet another popup.
* Enter info in Socks, but leave the others blank. (You may need to uncheck "Use the same proxy server for all protocols" first.) It should look like this:

  ![image](https://user-images.githubusercontent.com/1450515/143207129-9fde4a05-42a2-42f0-b265-21d908b628b3.png)

* Click OK close this window.
* Click OK again to close the previous window.
* Click OK yet again.
* Now try going to a site like https://whatismyipaddress.com/ to verify it worked.
