This file describes use cases for which I tweaked this package.

Basic usage
===

Package automatically initializes environment variables, namely:

 * `CMDER_PATH` (Cmder root directory),
 * `JAVA_HOME` (`%CMDER_PATH%\jdk`),
 * `JAVA_PATH` (`%CMDER_PATH%\jvm`),
 * `JDK_PATH` (`%CMDER_PATH%\jdk`),
 * `JRE_PATH` (`%CMDER_PATH%\jre`),
 * `GRADLE_PATH` (`%CMDER_PATH%\tools\gradle`),
 * `NODE_PATH` (`%CMDER_PATH%\node`)

and adds them to the `%PATH%` variable, making portable JRE, JDK, Gradle and
Node.js installations available in both Cygwin and CMD.exe terminals.

Settings are stored in `.bat` files used to initialize respective terminals.

Cygwin
---

It automatically configurs `CYGWIN` (`nodosfilewarning winsymlinks:native`)
variable. Settings were added to `cygwin/Cygwin.bat` file used to initialize
Cygwin environment.

Cmd.exe
---

Allows usage of `alias` command similarly to bash terminal. Settings are stored
in `vendor.init.bat` file.

Features
---

Both terminals have text coloring (built-in for bash, clint for CMD), as well as
display Git branch name for current folder.

Preinstalled software
---

 * [Atom](https://atom.io/) text editor - available in `cygwin/usr/local/bin/atom.exe` (or `atom` inside bash),
 * [Count lines of code](http://cloc.sourceforge.net/) - available as `cloc.exe` in bash.
 * [FAR manager](farmanager.com) - available in ConEmu menu,
 * [LightTable](http://www.lighttable.com/) IDE - available in `cygwin/usr/local/bin/light-table.exe` (or `light-table` inside bash),
 * [Nightcode](nightcode.info) IDE - available in `cygwin/usr/local/bin/nightcode.jar` (or `nightcode` inside bash),
 * [Sublime Text](http://www.sublimetext.com/3) text editor - available in `cygwin/usr/local/sublime_text.exe`.

REPLs
===

Conemu has Clojure, Ruby and Python REPLs configured and available in menu out
of the box. Additionaly Clojure comes with Leiningen already installed.

Chromium development
===

As package was created with Chromium building in mind it has some Chromium
toolchain support already added. It has already configured environment
variables (they just need to be enabled in common_variables.bat file):

 * `DEPOT_TOOLS_WIN_TOOLCHAIN` (`1`),
 * `DXSDK_DIR` (`C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)`),
 * `GYP_DEFINES` (`windows_sdk_path="C:\Program Files (x86)\Windows Kits\8.1" component=shared_library`),
 * `GYP_GENERATOR_FLAGS` (`config=Debug`),
 * `GYP_GENERATORS` (`msvs-ninja,ninja`),
 * `GYP_MSVS_VERSION` (`2013e`),
 * `GYP_PARALLEL` (`12`),
 * `VS100COMNTOOLS` (`C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\`),
 * `VS120COMNTOOLS` (`C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\`),
 * `WDK_DIR` (`C:\WinDDK\7600.16385.1`)

and [Depot tools](http://dev.chromium.org/developers/how-tos/depottools) already
checked out in Cygwin in `/opt/depot_tools`. However directory need to be
initialized with `/opt/reinstall_depot_tools.sh` to have Git, specific Python
version GYP and some SDKs downloaded. This must be preceeded by unlocking either
Express or Professional VS2013 toolchain (first one is not supported by Chromium
at the moment).

Once initialized toolchain's Python can be called as `gyp_python` inside Cygwin
and just `python` inside CMD. However to work, GYP required adding path to depot
tools to PATH variable - it ca be done by calling script
`setup_PATH_depottools.ps1` with admin rights.

Environment variables are set inside `cygwin/Cygwin.bat` and `vendor/init.bat`.

**Important!** You still will have to install manually:

* MS Visual Studio Express 13,
* Windows Driver Kit 7.1,
* Windows 8.1 SDK.

in this order.

Other installation scripts
===

Boost 1.55
---

Run `/opt/install_boost.sh` to download, build and install Boost 1.55

Chromium's libchrome and minichromium
---

Run `/opt/install_libchrome.sh` or `/opt/install_mini_chromium.sh` respectively.

Text editor plugins
---

To install some predefined plugins for Atom, Sublime Text or Vim run

 * `/opt/install_atom_plugins.sh`
 * `/opt/install_sublime_text_plugins.sh`
 * `/opt/install_vim_plugins.sh`

respectively.

Known problems
===

(Portable) Sublime Text crashes when you try try to run it from bash terminal.
I don't know how to fix that (or even why it happens).
