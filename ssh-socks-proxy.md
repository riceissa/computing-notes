# How to start a SOCKS proxy using ssh and connect to it using Firefox

On your local machine (not on the VPS), run:

```
ssh -D 8123 -N Your_VPS_name
```

The `-D` flag starts a SOCKS proxy at the specified port (the port number can be any unused number, I think).
The `-N` flag I'm not entirely sure what it does, but the man page says it's useful for forwarding.


Now in Firefox, go to `about:preferences` in the URL bar.
Search "network" to find the Network Settings, then click Settings.

![image](https://user-images.githubusercontent.com/1450515/143175876-aa321b75-a76f-486c-9e57-1c6d7b9b5c69.png)

(By default, my Firefox had "Use system proxy settings".)

Now just fill in the "Manual proxy settings" using `127.0.0.1` (localhost) as the host, and the same port number as was specified in the ssh command:

![image](https://user-images.githubusercontent.com/1450515/143175993-11e39ee9-e014-423f-b547-3704bbd3129c.png)

Then click OK. Try going to a site like https://whatismyipaddress.com/ to verify it worked.
