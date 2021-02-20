#!/bin/sh
# Git helper for things i keep having to do with this repo
if [ $# -ne 1 ]; then
	echo "Incorrect number of arguments"
	exit 1
fi
case "$1" in
	--help )
		echo \
"Usage: ./gith.sh [OPTION]
Execute common git workflows for this repository

  --help                display this help and exit
  --push                push the last commit before the metaconf was applied
  --pull                pull the latest config, automatically handling metaconf
  --reset               revert to before the metaconf, keeping any changes"
		;;
	--push )
		# Check valid state
		log=$(git log --oneline --no-decorate | awk '{print $2}')
		if [ "$(echo "$log" | head -n1)" = "METACONF_APPLIED" ] &&
				! echo "$log" | tail -n +2 | grep -q "METACONF_APPLIED"; then
			# Last commit metaconf, no previous metaconf commits
			if [ "$(git diff HEAD)" = "" ]; then
				# Clean working tree
				git checkout HEAD~
				git push origin HEAD:master -f
				git switch -
			else
				git add .
				git stash
				git checkout HEAD~
				git push origin HEAD:master -f
				git switch -
				git stash pop
			fi
		elif ! echo "$log" | grep -q "METACONF_APPLIED"; then
			git push
		else
			echo "Invalid state for push"
			exit 1
		fi
		;;
	--pull )
		# Check valid state
		log=$(git log --oneline --no-decorate | awk '{print $2}')
		if [ "$(echo "$log" | head -n1)" = "METACONF_APPLIED" ] &&
				! echo "$log" | tail -n +2 | grep -q "METACONF_APPLIED"; then
			# Last commit metaconf, no previous metaconf commits
			if [ "$(git diff HEAD)" = "" ]; then
				# Clean working tree
				git reset --hard HEAD~
				git pull
				./install.sh --update
			else
				git add .
				git stash
				git reset --hard HEAD~
				git pull
				./install.sh --update
				git stash pop
			fi
		elif ! echo "$log" | grep -q "METACONF_APPLIED"; then
			git pull
		else
			echo "Invalid state for pull"
			exit 1
		fi
		;;
	--reset )
		# Check valid state
		log=$(git log --oneline --no-decorate | awk '{print $2}')
		if [ "$(echo "$log" | head -n1)" = "METACONF_APPLIED" ] &&
				! echo "$log" | tail -n +2 | grep -q "METACONF_APPLIED"; then
			# Last commit metaconf, no previous metaconf commits
			if [ "$(git diff HEAD)" = "" ]; then
				# Clean working tree
				git reset --hard HEAD~
			else
				git add .
				git stash
				git reset --hard HEAD~
				git stash pop
			fi
		else
			echo "Invalid state for reset"
		fi
esac
