#!/bin/bash
mkdir -p \
     '/usr/local/bin/sublime-text/Data/Installed Packages/'
wget 'https://sublime.wbond.net/Package Control.sublime-package' \
  -O '/usr/local/bin/sublime-text/Data/Installed Packages/Package Control.sublime-package'

mkdir -p \
   '/usr/local/bin/sublime-text/Data/Packages/User/'
cp '/opt/utils/Package Control.sublime-settings' \
   '/usr/local/bin/sublime-text/Data/Packages/User/Package Control.sublime-settings'
cp '/opt/utils/Preferences.sublime-settings' \
   '/usr/local/bin/sublime-text/Data/Packages/User/Preferences.sublime-settings'

wget 'https://raw.githubusercontent.com/MartinThoma/glpk/master/GLPK.sublime-build' \
  -O '/usr/local/bin/sublime-text/Data/Packages/User/GLPK.sublime-build'
wget 'https://raw.githubusercontent.com/MartinThoma/glpk/master/GNU-MathProg.tmLanguage' \
  -O '/usr/local/bin/sublime-text/Data/Packages/User/GNU-MathProg.tmLanguage'
