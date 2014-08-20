cmder package builder
===

Builds cmder portable installation with sevaral features preinstalled:

 * Cygwin environment,
 *

Enabling running scripts
---

When you see warning:

    File build_cmder.ps1 cannot be loaded because the execution of scripts is
    disabled on thi s system. Please see "get-help about_signing" for more
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

Libusb
---

File can be found on [http://sourceforge.net/projects/libusb-win32/files/latest/download](sourceforge).
