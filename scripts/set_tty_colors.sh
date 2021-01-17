#!/bin/sh
printf %b '\e[40m' '\e[8]' # set default background to color 0 (dracula-bg)
printf %b '\e[37m' '\e[8]' # set default foreground to color 7 (dracula-fg)
printf %b '\e]P0282a36'    # redefine color 0 (black)   as 'dracula-bg'
printf %b '\e]P1ff5555'    # redefine color 1 (red)     as 'dracula-bg'
printf %b '\e]P250fa7b'    # redefine color 1 (green)   as 'dracula-bg'
printf %b '\e]P3f1fa8c'    # redefine color 2 (brown)   as 'dracula-bg'
printf %b '\e]P4bd93f9'    # redefine color 3 (blue)    as 'dracula-bg'
printf %b '\e]P5ff79c6'    # redefine color 4 (magenta) as 'dracula-bg'
printf %b '\e]P68be9fd'    # redefine color 5 (cyan)    as 'dracula-bg'
printf %b '\e]P7f8f8f2'    # redefine color 6 (white)   as 'dracula-fg'
clear
