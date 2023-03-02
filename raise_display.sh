#!/bin/bash
#
# helper, raise in front the terminal with the display as it's name
winid_display=$(wmctrl -l | awk '/display$/ { print $1}')
if [[ -n $winid_display ]]
then
  wmctrl -i -a $winid_display
fi
