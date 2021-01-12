function fish_prompt
	set last_status $status
	if test $last_status -eq 0
		set_color green
	else
		set_color red
	end
	echo -n "❯ $last_status "
	set_color cyan
	echo -n (whoami)
	set_color white
	echo -n "@"
	set_color blue
	echo -n (sed -n 's/^ID=//p' /etc/os-release)
	set_color magenta
	echo -n " "(prompt_pwd)
	set_color white
	if test (id -u) -eq 0
		echo -n ' # '
	else
		echo -n ' $ '
	end
end
