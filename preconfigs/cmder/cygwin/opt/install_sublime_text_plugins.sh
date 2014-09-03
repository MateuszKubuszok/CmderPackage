#!/bin/bash
mkdir -p \
     '/usr/local/bin/sublime-text/Installed Packages/'
wget 'https://sublime.wbond.net/Package Control.sublime-package' \
  -O '/usr/local/bin/sublime-text/Installed Packages/Package Control.sublime-package'

mkdir -p '/usr/local/bin/sublime-text/Packages/User/'
echo '{
  "installed_packages":
  [
    "Ada",
    "Bison",
    "C++11",
    "Coco R Syntax Highlighting",
    "CoffeeScript",
    "CSS3",
    "Git",
    "GitGutter",
    "Grails",
    "jQuery",
    "HTML5",
    "MSBuild",
    "nginx",
    "Sass",
    "Scheme",
    "SideBarEnhancements",
    "SublimeCodeIntel",
    "SublimeLinter",
    "SublimeLinter-contrib-clang",
    "SublimeREPL",
    "stposh",
    "Swift",
    "Theme - Soda"
  ]
}
' > "/usr/local/bin/sublime-text/Packages/User/Package Control.sublime-settings"
