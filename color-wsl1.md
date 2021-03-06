# Fixing color on WSL1

WSL terminal's color settings are seriously confusing. First, it only shows you four settings you can change:

![image](https://user-images.githubusercontent.com/1450515/136670628-fe5c4d25-11ea-4dbd-9a4f-a5df01f7da77.png)

But then, without any explanation, it also has this block of 16 colors below:

![image](https://user-images.githubusercontent.com/1450515/136671272-4295c759-cb25-466b-8e79-29c493a1e167.png)

(not the original colors, sorry, I had already been messing with the palette quite a bit by this point;
these are my final colors after going through the process below)

It turns out that by changing the colors in these 16 boxes, you can change the terminal colors for things
other than the basic foreground and background.

But here's the second confusing thing: the colors there don't seem to just be in the order 0,...,15.
Instead, the order seems to be: 0, 4, 2, 6, 1, 5, 3, 7, 8, 12, 10, 14, 9, 13, 11, 15.

In case I have to do this again, I'll just put the RGB values of my favorite colorscheme (a mix of solarized and tango), in the above
order:

```
7,54,66 (Black=color 0)
38,139,210 (Blue=color 4)
133,153,0 (Green=color 2)
42,161,152 (Cyan=color 6)
220,50,47 (Red=color 1)
211,54,130 (Magenta=color 5)
181,137,0 (Yellow=color 3)
238,232,213 (White=color 7)
0,43,54 (BoldBlack=color 8)
114,159,207 (BoldBlue=color 12)
138,226,52 (BoldGreen=color 10)
52,226,226 (BoldCyan=color 14)
203,75,22 (BoldRed=color 9)
108,113,196 (BoldMagenta=color 13)
252,233,79 (BoldYellow=color 11)
253,246,227 (BoldWhite=color 15)
```

The following will print the 16 basic terminal colors;
see [here](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit) for color codes and
[here](https://askubuntu.com/questions/27314/script-to-display-all-terminal-colors) for a similar bash script
(that prints way more colors than i wanted to show).

```bash
for c in "30;40" "31;41" "32;42" "33;43" "34;44" "35;45" "36;46" "37;47" "90;100" "91;101" "92;102" "93;103" "94;104" "95;105" "96;106" "97;107"; do echo -n "$c"; echo -ne "\e[""$c""mHELLO\e[30;107m"; echo ""; done
```
