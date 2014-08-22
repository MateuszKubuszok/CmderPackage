cmder package builder
===

Builds cmder portable installation with several features preinstalled:

 * Cygwin environment,
 * apt-cyg script,
 * depot_tools,
 * portable installation of JRE and JDK,
 * Gradle build system,
 * Clojure REPL and Leiningen,
 * Python REPL,
 * Ruby REPL,
 * Far manager,
 * some preconfiguration:
   * Cmder have Cygwin, Clojure REPL, Python REPL and Ruby REPL tasks
     out of the box,
   * git-prompt in Cygwin,
   * environment variables (PATH, JAVA_PATH, etc) set dunamically on Cmder
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

Cygwin can be further configured by running:

    .\setup_cygwin.ps1

and choosing packages to install/remove.

Libusb
---

File can be found on [http://sourceforge.net/projects/libusb-win32/files/latest/download](sourceforge).

TODO
---

  - [ ] Create separate script for adding depot-tools to the windows path.
  - [ ] Create separate script for building and installing boost.
  - [ ] Create separate script for cleaning and downloading depottools
        Windows toolchain.

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

[https://code.google.com/p/conemu-maximus5/](Conemu) - contains original Conemu
software without any additional addons.

### Cmder

[http://bliker.github.io/cmder/](Cmder) - portable installation of
Conemu with preinstalled enhancements for CMD console.

### Cygwin

[https://cygwin.com/](Cygwin) - POSIX environment for Windows system. Contains
many ported packages.

### apt-cyg

[https://code.google.com/p/apt-cyg/](apt-cyg) - script for Cygwin allowing
package management in a apt-get like manner.

### depot_tools

[http://www.chromium.org/developers/how-tos/depottools](depot_tools) - scripts
useful when working with Google code.

### Gradle

[http://www.gradle.org/downloads](Gradle) - build system (mainly) for Java.

### Far manager

[http://www.farmanager.com/](Far manager) - Total Commander like manager in
a command line.

### Java JRE and JDK

[http://www.oracle.com/technetwork/java/javase/downloads/index.html](Java) -
Oracle's Java platform and development kit.

### Clojure

[http://clojure.org/](Clojure) - Clojure programming language.

[http://leiningen.org/](Leiningen) - builder for Clojure applications.

### Python

[https://www.python.org/](Python) - Python programming language.

### Ruby

[https://www.ruby-lang.org/](Ruby) - Ruby programming language.
