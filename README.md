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
 * [Node.js](http://nodejs.org/) Node.js REPL,
 * [Python](https://www.python.org/) REPL,
 * [Ruby](https://www.ruby-lang.org/) REPL,
 * [Far](http://www.farmanager.com/) manager,
 * portable versions of text editors and IDEs:
   * [Atom](https://atom.io/) text editor,
   * [LightTable](http://www.lighttable.com/) IDE,
   * [Nightcode](nightcode.info) IDE,
   * [Sublime Text](http://www.sublimetext.com/3) text editor,
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

Cygwin setup crashes when started in x64 PowerShell, so script ensures that it
will be run only with PowerShell x86.

Run in a PowerShell:

    .\build_cmder.ps1

In the process Cygwin installer will appear - let it do the job. If you want to
change installation use `setup_cygwin.ps1` script.

Once build is completed run `Cmder.exe` and let it update Conemu to its newest
version. With older one (distributed with Cmder) startup errors might appear,
and some functionalities (like copying text by highlighting) are not available.

Cygwin setup
---

Once Cygwin is installed it can be further configured by running:

    .\setup_cygwin.ps1

and choosing packages to install/remove.

Installation troubleshoting
---

 * **Cygwin installation takes forever/fails** - some packages are available
   only on mirrors.kernel.org. For some reason the site has sometimes problems
   with FTP transfer and Cygwin Setup cannot either connect or has very slow
   transfer. You can try to restart script (it saves your progress so you won't
   have to install the same thing twice), or try to rerun it some time later.
 * **Gradle installation freezes even though all files are extracted** - Gradle
   actually hav > 10k files to extract, many of them so small that you might not
   notice, that they are still being extracted when you check directory size
   only. Wait a litte bit more.
 * **Editors (Atom, Light Table, Sublime Text) fail to extract** - for some
   reason, uknown to me, even though file is downloaded on first try script
   might show error that it cannot find it and thus is unable to extract files.
   I can only guess that it is some sort of race condition or other error on my
   part resulting in call for extraction just before filesystem knows that
   downloaded file arrived. Rerunning script helps (one might need to remove
   `symlinks.mrk` file to try to create symlinks again).

Portability
---

Basically whole package was build with portability in mind. OTTOOMH only
`set_PATH_depottools.ps1` modifies `PATH` environment vairable and so it would
require running (and cleaning after) on every system.

I have noticed though that when package is synchronized with e.g. Copy.com
software, symlinks (NTFS's junctions) get broken and functionality depending on
them stops working. Therefore one needs to choose method of transfering the
whole installation that would preserve them if he want to make use of its
portability.

Usage
---

Details on how to use of added features and programs can be found
[here](USAGE.md).

Libusb
---

If needed file can be found on
[sourceforge](http://sourceforge.net/projects/libusb-win32/files/latest/download).

License
---

Scripts and my own configs are published with Apache 2.0 license. As such anyone
can use them and modify to their needs. Configs being modifications are licensed
like their originals.

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

[GYP](https://code.google.com/p/gyp/) - Chromium's builder.

### Java JRE and JDK

[Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) -
Oracle's Java platform and development kit.

[Gradle](http://www.gradle.org/downloads) - build system (mainly) for Java.

[SBT](http://www.scala-sbt.org/) - Simple Build Tool written in Scala.

### Clojure

[Clojure](http://clojure.org/) - Clojure programming language.

[Leiningen](http://leiningen.org/) - builder for Clojure applications.

### Node.js

[Node.js](http://nodejs.org/) - JS development platform.

### Python

[Python](https://www.python.org/) - Python programming language.

### Ruby

[Ruby](https://www.ruby-lang.org/) - Ruby programming language.

### Atom

[Atom](https://atom.io/) - Atom text editor.

### LightTable

[LightTable](http://www.lighttable.com/) - LightTable Clojure IDE.

### NightCode

[Nightcode](nightcode.info) - Nightcode Clojure IDE.

### Sublime Text

[Sublime Text](http://www.sublimetext.com/3) - Sublime Text 3 text editor.

### Apt-Cyg

[apt-cyg](https://github.com/transcode-open/apt-cyg) - apt-get like manager for
Cygwin.

### CLOC

[CLOC](http://cloc.sourceforge.net/) - Count Lines of Code.
