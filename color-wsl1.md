# Fixing color on WSL1

The following will print the 16 basic terminal colors;
see [here](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit) for color codes and
[here](https://askubuntu.com/questions/27314/script-to-display-all-terminal-colors) for a similar bash script
(that prints way more colors than i wanted to show).

```bash
for c in "30;40" "31;41" "32;42" "33;43" "34;44" "35;45" "36;46" "37;47" "90;100" "91;101" "92;102" "93;103" "94;104" "95;105" "96;106" "97;107"; do echo -n "$c"; echo -ne "\e[""$c""mHELLO\e[30;107m"; echo ""; done
```
