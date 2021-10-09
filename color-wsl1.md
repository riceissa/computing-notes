# Fixing color on WSL1

WSL terminal's color settings are seriously confusing. First, it only shows you four settings you can change:

![image](https://user-images.githubusercontent.com/1450515/136670628-fe5c4d25-11ea-4dbd-9a4f-a5df01f7da77.png)

But then, without any explanation, it also has this block of 16 colors below:

![image](https://user-images.githubusercontent.com/1450515/136670636-33593031-7b7b-424b-89c0-014f5f218d25.png)

It turns out that by changing the colors in these 16 boxes, you can change the terminal colors for things
other than the basic foreground and background.

But here's the second confusing thing: the colors there don't seem to just be in the order 0,...,15.

The following will print the 16 basic terminal colors;
see [here](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit) for color codes and
[here](https://askubuntu.com/questions/27314/script-to-display-all-terminal-colors) for a similar bash script
(that prints way more colors than i wanted to show).

```bash
for c in "30;40" "31;41" "32;42" "33;43" "34;44" "35;45" "36;46" "37;47" "90;100" "91;101" "92;102" "93;103" "94;104" "95;105" "96;106" "97;107"; do echo -n "$c"; echo -ne "\e[""$c""mHELLO\e[30;107m"; echo ""; done
```
