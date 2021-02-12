#!/bin/dash

# Written by Matthew Sirman and Tim Clifford

title_error="Unknown Title"
artist_error="Unknown Artist"

# substring regex matches

# dash has no arrays but i NEEED SPEEED
# idk what this char "" is but it seems like a
# decent delimiter hahaha. I think it might me a CR?
# can type in vim insert mode with Ctrl-V Ctrl-L

# This is disgusting but the last param is an
# arbitrary sed command to run on the title if it matches,
# basically to remove bits you don't want

regex_url_mappings="
.*youtube.*%{F#ff5555}%{F-}
.*twitch.*s/ - Twitch//
"

regex_title_mappings="
"
#.* - Twitchs/ - Twitch//

regex_player_mappings="
spotify%{F#50fa7b}%{F-}
firefox
chromiumBrave
vlcVLC
"

found_currently_playing='0'

if [ -f /tmp/polybar-player-current ]; then
	current_player=$(cat /tmp/polybar-player-current)
else
	current_player=''
fi

# we want to process the current player last for a smooth experience
# sadly -z is a GNUism but oh well
players=$(playerctl -l | sed -z "s/\(.*\)\($current_player\n\)\(.*\)/\1\3\2/")

for player in $players
do
	if [ $(playerctl -p $player status) = 'Playing' ]; then
		found_currently_playing='1'
	else
		if [ $found_currently_playing = '1' ]; then
			# We'd prefer a currently playing player
			continue
		fi
	fi

	title=$( { playerctl -p $player metadata title; } 2>/dev/null )
	if [ $? -ne 0 ]; then
	    title=$title_error
	fi

	artist=$( { playerctl -p $player metadata artist; } 2>/dev/null )
	if [ $? -ne 0 ]; then
	    artist=$artist_error
	fi

	if [ -f $HOME/.mozilla/firefox/*.default-release/sessionstore-backups/recovery.jsonlz4 ]; then
		# Just trust in the black magic please
		url=$(lz4jsoncat $HOME/.mozilla/firefox/*.default-release/sessionstore-backups/recovery.jsonlz4 \
			| jq "$(echo '.windows[] | .tabs[] | .entries[] | select(.title != null) | select(.title | contains("'"$(playerctl -p $player metadata title)"'")) | .url')" \
			| sed 's/^"//;s/"$//')
	else
		url=''
	fi

	if [ "$title" = "$title_error" ] && [ "$artist" = "$artist_error" ]; then
	    continue
	fi

	current_player=$player

	suffix="${player} (Unknown)" # Default

	# Set separator to a newline character
	# for our fucked up data structure

	IFS="
"

	for player_map in $regex_player_mappings; do
		regex=$(echo $player_map | sed 's/.*//')
		icon=$(echo $player_map | sed 's/.*//')
		if echo $player | egrep -q "$regex"; then
			suffix=$icon
			break
		fi
	done

	# Titles take precedence
	for title_map in $regex_title_mappings; do
		regex=$(echo $title_map | sed 's/.*//')
		icon=$(echo $title_map | sed 's/.*\(.*\).*/\1/')
		sedcmd=$(echo $title_map | sed 's/.*//')
		if echo $title | egrep -q "$regex"; then
			suffix=$icon
			if ! [ "$sedcmd" = '' ]; then
				title=$(echo $title | sed "$sedcmd")
			fi
			break
		fi
	done

	# URLs take even more precedence
	for url_map in $regex_url_mappings; do
		regex=$(echo $url_map | sed 's/.*//')
		icon=$(echo $url_map | sed 's/.*\(.*\).*/\1/')
		sedcmd=$(echo $url_map | sed 's/.*//')
		if echo $url | egrep -q "$regex"; then
			suffix=$icon
			if ! [ "$sedcmd" = '' ]; then
				url=$(echo $url | sed "$sedcmd")
			fi
			break
		fi
	done
done
# write the player to a temp file for the play-pause script
# logic for if current_player = '' is on the other side
echo -n $current_player > /tmp/polybar-player-current

# Only output the suffix if there's not much space
# don't force this check to happen if this script doesn't exist
if [ -f $HOME/.config/scripts/islandscape.sh ] \
   && ! $HOME/.config/scripts/islandscape.sh; then
	echo "   $suffix"
else
	# Don't introduce a trailing - if there's no artist
	if echo $artist | egrep -q '^[ \t]*$'; then
		echo "  $title     $suffix"
	else
		echo "  $title  -  $artist     $suffix"
	fi
fi
