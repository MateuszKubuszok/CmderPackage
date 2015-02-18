#!/bin/sh
SublimeTextDir='/usr/local/bin/sublime-text'
InstalledDir="$SublimeTextDir/Data/Installed Packages"
PackagesDir="$SublimeTextDir/Data/Packages/User"

mkdir -p \
     "$InstalledDir/"
wget "https://sublime.wbond.net/Package Control.sublime-package" \
  -O "$InstalledDir/Package Control.sublime-package"

mkdir -p \
   "$PackagesDir/"
cp "/opt/utils/Package Control.sublime-settings" \
   "$PackagesDir/Package Control.sublime-settings"
cp "/opt/utils/Preferences.sublime-settings" \
   "$PackagesDir/Preferences.sublime-settings"

wget "https://raw.githubusercontent.com/MartinThoma/glpk/master/GLPK.sublime-build" \
  -O "$PackagesDir/GLPK.sublime-build"
wget "https://raw.githubusercontent.com/MartinThoma/glpk/master/GNU-MathProg.tmLanguage" \
  -O "$PackagesDir/GNU-MathProg.tmLanguage"
