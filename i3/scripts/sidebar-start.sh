#!/bin/bash
conky &
sleep 0.2; i3-msg '[class="Conky"] move absolute position 0px 2159px'
echo 0 > $HOME/.i3/sidebar-isshown
