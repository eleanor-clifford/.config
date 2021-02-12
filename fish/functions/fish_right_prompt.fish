function fish_right_prompt
	export __fish_git_prompt_show_informative_status
	export __fish_git_prompt_showcolorhints

	#export __fish_git_prompt_color=('')
	#export __fish_git_prompt_color_prefix=
	#export __fish_git_prompt_color_suffix=
	#export __fish_git_prompt_color_bare=
	export __fish_git_prompt_color_merging=blue
	export __fish_git_prompt_color_cleanstate=green
	export __fish_git_prompt_color_dirtystate=yellow
	export __fish_git_prompt_color_invalidstate=red
	export __fish_git_prompt_color_stagedstate=cyan
	#export __fish_git_prompt_color_stashstate=(same as color_flags)
	export __fish_git_prompt_color_untrackedfiles=yellow
	#export __fish_git_prompt_color_upstream=
	export __fish_git_prompt_color_branch=blue
	export __fish_git_prompt_color_branch_detached=red
	#export __fish_git_prompt_color_flags=(--bold blue)

	echo -n G:[(fish_git_prompt|sed 's/^ //;s/[()]//g')]
end
