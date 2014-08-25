cmder package builder
===

Builds [cmder](http://bliker.github.io/cmder/) portable installation with
several features preinstalled:

 * [Cygwin](https://cygwin.com/) environment,
 * [apt-cyg](https://code.google.com/p/apt-cyg/) script,
 * [depot_tools](http://www.chromium.org/developers/how-tos/depottools),
 * portable installation of [JRE and JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html),
 * [Gradle](http://www.gradle.org/downloads) build system,
 * [Clojure](http://clojure.org/) REPL and [Leiningen](http://leiningen.org/)
   builder,
 * [Python](https://www.python.org/) REPL,
 * [Ruby](https://www.ruby-lang.org/) REPL,
 * [Far](http://www.farmanager.com/) manager,
 * some preconfiguration:
   * Cmder have Cygwin, Clojure REPL, Python REPL and Ruby REPL
     [tasks](https://code.google.com/p/conemu-maximus5/wiki/SettingsTasks)
     out of the box,
   * [git-prompt](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
     in Cygwin,
   * environment variables (PATH, JAVA_PATH, etc) set dynamically on Cmder
     startup.

Enabling running scripts
---

When you see warning:

    File build_cmder.ps1 cannot be loaded because the execution of scripts is
    disabled on this system. Please see "get-help about_signing" for more
    details

run following line in a PowerShell with admin rights:

    Set-ExecutionPolicy RemoteSigned

and confirm your choice with `Y`.

Building
---

Run in a PowerShell (make sure you are running the one located in `syswow64` not
`system32`):

    .\build_cmder.ps1

In the process Cygwin installer will appear - let it do the job. If you want to
change installation use `setup_cygwin.ps1` script.

If Cygwin installation crashes at the beginning try switching from x86 to x64
PowerShell (or from x64 to x86).

Cygwin setup
---

Once Cygwin is installed it can be further configured by running:

    .\setup_cygwin.ps1

and choosing packages to install/remove.

Boost and depottools
---

To install boost run:

    /opt/install_boost.sh

in Cygwin console. Depot tools can be similarly (re)installed with command:

    /opt/reinstall_depot_tools.sh

Depottools directory can then be added to PATH with `seet_PATH_depottools.ps1`
(run with administrator's priviledges).

Libusb
---

File can be found on [sourceforge](http://sourceforge.net/projects/libusb-win32/files/latest/download).

License
---

Scripts and configs are published with Apache 2.0 license. As such anyone can
use them and modify to their needs.

Disclaimer
---

I am not an author of any of those software. This builder merely puts together
several software pieces and add some initial configuration to it.

All credits goes to the authors of their respective product.

Used software
---

Software downloaded by script to put together a nice toolchain.

### Conemu

[Conemu](https://code.google.com/p/conemu-maximus5/) - contains original Conemu
software without any additional addons.

[Cmder](http://bliker.github.io/cmder/) - portable installation of
Conemu with preinstalled enhancements for CMD console.

[Far manager](http://www.farmanager.com/) - Total Commander like manager in
a command line.

### Cygwin

[Cygwin](https://cygwin.com/) - POSIX environment for Windows system. Contains
many ported packages.

[apt-cyg](https://code.google.com/p/apt-cyg/) - script for Cygwin allowing
package management in a apt-get like manner.

### depot_tools

[depot_tools](http://www.chromium.org/developers/how-tos/depottools) - scripts
useful when working with Google code.

### Java JRE and JDK

[Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) -
Oracle's Java platform and development kit.

[Gradle](http://www.gradle.org/downloads) - build system (mainly) for Java.

### Clojure

[Clojure](http://clojure.org/) - Clojure programming language.

[Leiningen](http://leiningen.org/) - builder for Clojure applications.

### Python

[Python](https://www.python.org/) - Python programming language.

### Ruby

[Ruby](https://www.ruby-lang.org/) - Ruby programming language.
