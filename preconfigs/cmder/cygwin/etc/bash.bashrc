# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.2-3

# /etc/bash.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/bash.bashrc

# Modifying /etc/bash.bashrc directly will prevent
# setup from updating it.

# System-wide bashrc file

# Check that we haven't already been sourced.
[[ -z ${CYG_SYS_BASHRC} ]] && CYG_SYS_BASHRC="1" || return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Exclude *dlls from TAB expansion
export EXECIGNORE="*.dll"

# Set a default prompt of: user@host and current_directory
source /etc/git-prompt.sh
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] $(__git_ps1 "(%s)")\nλ '

# Uncomment to use the terminal colours set in DIR_COLORS
# eval "$(dircolors -b /etc/DIR_COLORS)"
# Uncomment to use the terminal colours set in LS_COLORS
# eval "$(dircolors -b /etc/LS_COLORS)"

alias atom='atom.exe ' \
      light-table='light-table.exe ' \
      nightcode='java -jar nightcode.jar ' \
	    sublime_text='sublime_text.exe ' \
	    gyp_python='/opt/depot_tools/python276_bin/python ' \
	    winpath='cygpath --windows '
