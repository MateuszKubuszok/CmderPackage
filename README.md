cmder package builder
===

Builds cmder portable installation with sevaral features preinstalled:

 * Cygwin environment,
 * apt-cyg script,
 * depot_tools,
 * some preconfiguration files.

Enabling running scripts
---

When you see warning:

    File build_cmder.ps1 cannot be loaded because the execution of scripts is
    disabled on this system. Please see "get-help about_signing" for more
    details

run following line in a powershell with admin rights:

    Set-ExecutionPolicy RemoteSigned

and confirm your choice with `Y`.

Building
---

Run in a powershell (make sure you are running the one located in `syswow64` not
`system32`):

    .\build_cmder.ps1

In the process several windows might appear. Let them do the job. Some of them
will allow you to choose some configurations. You can change them if you know
what you are doing.

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

Disclaimer
---

I am not an author of any of those software. This builder merely puts together
several software pieces and add some initial configuration to it.

Used software
---

### Conemu

[https://code.google.com/p/conemu-maximus5/](Conemu) - constains original Conemu
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
