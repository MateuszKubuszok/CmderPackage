Import-Module BitsTransfer

# Paths - commonly referred directories and executables
################################################################################

$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp        = "$CurrentDir\tmp"
$CmderDir   = "$CurrentDir\cmder"
$CygwinDir  = "$CmderDir\cygwin"
$MsysgitDir = "$CmderDir\vendor\msysgit"

$7zaEXE        = "$CygwinDir\lib\p7zip\7za.exe"
$CabextractEXE = "$CygwinDir\bin\cabextract.exe"
$GitEXE        = "$MsysgitDir\bin\git"
$LnEXE         = "$CygwinDir\bin\ln"
$TarEXE        = "$MsysgitDir\bin\tar.exe"
$UnzipEXE      = "$MsysgitDir\bin\unzip.exe"
$WgetEXE       = "$CygwinDir\bin\wget.exe"

# Components - subject to change if we want to e.g. update some dependency
################################################################################

$CmderURL       = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip'
$CmderTmp       = 'cmder-v1.1.3.zip'
$CmderMrk       = 'cmder-v1.1.3'
$CygwinURL      = 'https://cygwin.com/setup-x86_64.exe'
$CygwinTmp      = 'setup-x86_64.exe'
$CygwinMrk      = 'cygwin'
$AptCygURL      = 'https://apt-cyg.googlecode.com/svn/trunk/apt-cyg'
$AptCygMrk      = 'aptcyg'
$DepotToolsURL  = 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
$DepotToolsMrk  = 'depottools'
$FarURL         = 'http://www.farmanager.com/files/Far30b4040.x64.20140810.7z'
$FarTmp         = 'Far30b4040.x64.20140810.7z'
$FarMrk         = 'far30b4040.x64.20140810'
$FarPluginMrk   = "farplugin-$FarMrk-$CmderMrk"
$JvmURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jre-8u20-windows-x64.tar.gz'
$JvmTmp         = 'jre-8u20-windows-x64.tar.gz'
$JvmMrk         = 'jre-8u20'
$JdkURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-windows-x64.exe'
$JdkTmp         = 'jdk-8u20-windows-x64.exe'
$JdkMrk         = 'jdk-8u20'
$ClojureURL     = 'http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.zip'
$ClojureTmp     = 'clojure-1.6.0.zip'
$ClojureMrk     = 'clojure-1.6.0'
$LeiningenURL   = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'
$LeiningenMrk   = 'leiningen'
$GradleURL      = 'https://services.gradle.org/distributions/gradle-1.11-all.zip'
$GradleTmp      = 'gradle-1.11-all.zip'
$GradleMrk      = 'gradle-1.11'
$AtomURL        = 'https://atom.io/download/windows'
$AtomTmp        = 'atom-windows.zip'
$AtomMrk        = 'atom'
$LightTableURL  = 'https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.7/LightTableWin.zip'
$LightTableTmp  = 'LightTableWin-0.6.7.zip'
$LightTableMrk  = 'lighttable-0.6.7'
$NightCoreURL   = 'https://github.com/oakes/Nightcode/releases/download/0.3.10/nightcode-0.3.10-standalone.jar'
$NightCodeTmp   = 'nightcode-0.3.10-standalone.jar'
$NightCodeMrk   = 'nightcode-0.3.10'
$SublimeTextURL = '"http://c758482.r82.cf2.rackcdn.com/Sublime Text Build 3059 x64.zip"'
$SublimeTextTmp = 'Sublime-Text-Build-3059-x64.zip'
$SublimeTextMrk = 'sublime-text-3059'
$GitPromptMrk   = 'gitprompt'
$SymlinksMrk    = 'symlinks'
$IconsMrk       = 'icons'
$SettingsMrk    = 'settings'

# Cygwin packages - list of packages to install
################################################################################

$CygwinSources = @(
  # Sources `
  '--site', 'ftp://mirrors.kernel.org/sourceware/cygwin',
  '--site', 'ftp://ftp.cygwinports.org/pub/cygwinports',
  '--pubkey', 'http://cygwinports.org/ports.gpg' `
)

$CygwinPackages = @(
  # Category Admin `
  '-C', 'Admin',
  # Category Archive `
  '-P', 'bzip2',
  '-P', 'cabextract',
  '-P', 'p7zip',
  '-P', 'unzip',
  '-P', 'zip',
  # Category Base `
  '-C', 'Base',
  # Category Devel `
  '-P', 'autoconf',
  '-P', 'bison',
  '-P', 'clang',
  '-P', 'clang-analyser',
  '-P', 'cmake',
  '-P', 'emacs-ocaml',
  '-P', 'flex',
  '-P', 'gcc-ada',
  '-P', 'gcc-core',
  '-P', 'gcc',
  '-P', 'gdb',
  '-P', 'git',
  '-P', 'ocaml',
  '-P', 'ocaml-base',
  '-P', 'ocaml-campl4',
  '-P', 'pylint',
  '-P', 'scons',
  '-P', 'subversion',
  # Category Editors `
  '-P', 'emacs',
  '-P', 'nano',
  '-P', 'vim',
  # Category Math `
  '-P', 'glpk',
  '-P', 'libglpk-devel',
  '-P', 'gmp',
  '-P', 'libgmp-devel',
  '-P', 'gnuplot',
  # Category Net `
  '-P', 'whois',
  # Category PHP `
  '-C', 'PHP',
  # Category Python `
  '-C', 'Python',
  # Category Ruby `
  '-C', 'Ruby',
  # Category Utils `
  '-P', 'ncurses',
  '-P', 'wdiff',
  # Category Web `
  '-P', 'wget' `
)

# Helper functions - things that PS should have out of the box
################################################################################

Function MarkerName($name) {
  return "$Tmp\$name.marker"
}

Function DownloadFileIfNecessary($source, $targetDir, $targetName) {
  $target = "$targetDir\$targetName"
  if (!(Test-Path $target)) {
    $webclient = New-Object System.Net.WebClient
    if (!(Test-Path $targetDir)) {
      New-Item $targetDir -type directory -Force
    }
    Write-Host "  downloading $source into $target..."
    $webclient.DownloadFile($source, $target)
  }
  EnsureFileDownloaded $source $target
  return $target
}

Function EnsureFileDownloaded($source, $target) {
  if (Test-Path $target) {
    Write-Host "  $source downloaded successfully"
    return
  }
  Write-Host "  failed to download $source!"
  exit 1
}

Function CopyDirContent($source, $target) {
  Write-Host "  copying $source into $target..."
  EnsureSourceNotEmpty $source
  if (!(Test-Path $target)) {
    New-Item $target -type directory -Force
  }
  $overrideSilent = 0x14
  $shell = New-Object -com shell.application
  $content = $shell.NameSpace($source)
  $shell.NameSpace($target).CopyHere($content.items(), $overrideSilent)
  if (Test-Path -Path "$target\*") {
    return 1
  }
  Write-Host " failed to copy $source content!"
  exit 1
}

Function EnsureSourceNotEmpty($source) {
  if ($source) {
    return
  }
  Write-Host "  $source doesn't exists!"
  exit 1
}

Function DownloadWithWgetIfNecessary($source, $targetDir, $targetName) {
  $target = "$targetDir\$targetName"
  if (!(Test-Path $target)) {
    $wgetArgs = @($source, '-O', $target)
    Write-Host "  downloading $source into $target..."
    Start-Process -FilePath $wgetEXE -ArgumentList $wgetArgs -PassThru -NoNewWindow -Wait
  }
  EnsureFileDownloaded $source $target
  return $target
}

Function DownloadFromOracleIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + '\' + $targetName
  if (!(Test-Path $target)) {
    $wgetArgs = @(
        '--no-check-certificate', '--no-cookies',
        '--header', '"Cookie: oraclelicense=accept-securebackup-cookie"',
        $source,
        '-O', $target)
    Write-Host "  downloading $source into $target..."
    Start-Process -FilePath $wgetEXE -ArgumentList $wgetArgs -PassThru -NoNewWindow -Wait
  }
  EnsureFileDownloaded $source $target
  return $target
}

Function CreateCygwinSymlink($from, $to) {
  if (!(Test-Path $from)) {
    $lnArgs = @('-s', $to, $from)
    Start-Process -FilePath $lnEXE -ArgumentList $lnArgs -PassThru -NoNewWindow -Wait
  }
  EnsureSymlinkCreated $from $to
}

Function EnsureSymlinkCreated($from, $to) {
  if (Test-Path $from) {
    Write-Host "  symlink $from -> $to created"
    return
  }
  Write-Host "  failed to symlink $from -> $to!"
  exit 1
}

# Tasks
################################################################################

Function InstallCmder() {
  Write-Host
  $cmderInstalledMarker = MarkerName($CmderMrk)
  if (!(Test-Path $cmderInstalledMarker)) {
    Write-Host 'Obtaining Cmder:'
    $CmderZIP = DownloadFileIfNecessary $CmderURL $Tmp $CmderTmp
    if (CopyDirContent $cmderZIP $CurrentDir) {
      echo $null > $cmderInstalledMarker
      Write-Host "  Cmder extracted into $CmderDir!"
    } else {
      Write-Host '  Cmder extraction failed!'
      exit 1
    }
  } else {
    Write-Host "Cmder already extracted"
  }
}

Function InstallCygwin() {
  Write-Host
  $cygwinInstalledMarker = MarkerName($CygwinMrk)
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host 'Obtaining Cygwin:'
    $CygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp $CygwinTmp
    $cygwinArgs = @(
        '--no-admin', '--upgrade-also', '--quiet-mode',
        '--no-desktop', '--no-startmenu', '--no-shortcuts',
        # Directories `
        '--root', $CygwinDir,
        '--local-package-dir', $Tmp) + $CygwinSources + $CygwinPackages
    Write-Host '  Running Cygwin setup...'
    $cygwinInstallation = Start-Process -FilePath $cygwinEXE -ArgumentList $cygwinArgs -PassThru -NoNewWindow -Wait
    if ($cygwinInstallation.ExitCode -eq 0) {
      echo $null > $cygwinInstalledMarker
      Write-Host "  Cygwin installed into $CygwinDir!"
    } else {
      Write-Host '  Cygwin installation failed!'
      Write-Host $cygwinInstallation.ExitCode
      Write-Host $cygwinInstallation.ExitCode
      exit $cygwinInstallation.ExitCode
    }
  } else {
    Write-Host 'Cygwin already installed'
  }
  $env:Path += ";$CygwinDir\bin"
  $env:CYGWIN = 'nodosfilewarning'
}

Function InstallAptCyg() {
  Write-Host
  $aptCygInstalledMarker = MarkerName($AptcygMrk)
  if (!(Test-Path $aptCygInstalledMarker)) {
    Write-Host 'Obtaining apt-cyg:'
    $aptCygDir = "$cygwinDir\bin"
    $AptCygFile = DownloadFileIfNecessary $aptCygURL $aptCygDir $AptCygTmp
    if (Test-Path $aptCygFile) {
      echo $null > $aptCygInstalledMarker
      Write-Host "  apt-cyg installed into $aptCygDir!"
    } else {
      Write-Host '  apt-cyg installation failed!'
      exit 1
    }
  } else {
    Write-Host 'apt-cyg already installed'
  }
}

Function InstallDepotTools() {
  Write-Host
  $depotToolsInstalledMarker = MarkerName($DepotToolsMrk)
  if (!(Test-Path $depotToolsInstalledMarker)) {
    Write-Host 'Obtaining depot-tools:'
    $depotToolsDir = "$CygwinDir\opt\depot_tools"
    $GitArgs = @('clone', $depotToolsURL, $depotToolsDir)
    New-Item $depotToolsDir -type directory -Force
    $depotToolsInstallation = Start-Process -FilePath $gitEXE -ArgumentList $gitArgs -PassThru -NoNewWindow -Wait
    if ($depotToolsInstallation.ExitCode -eq 0) {
      echo $null > $depotToolsInstalledMarker
      Write-Host "  depottools installed into $depotToolsDir!"
    } else {
      Write-Host '  depottools installation failed!'
      exit 1
    }
  } else {
    Write-Host 'depottools already installed'
  }
}

Function InstallFar() {
  Write-Host
  $farInstalledMarker = MarkerName($FarMrk)
  if (!(Test-Path $farInstalledMarker)) {
    Write-Host 'Obtaining Far:'
    DOwnloadFileIfNecessary $farURL $Tmp $FarTmp
    $far7Z  = "tmp/$FarTmp"
    $farDir = 'cmder/far'
    $7zaArgs = @('x', $far7Z, "-o$farDir", '-y')
    New-Item "$CmderDir\far" -type directory -Force
    $farInstallation = Start-Process -FilePath $7zaEXE -ArgumentList $7zaArgs -PassThru -NoNewWindow -Wait -WorkingDirectory '.'
    if ($farInstallation.ExitCode -eq 0) {
      echo $null > $farInstalledMarker
      Write-Host "  Far extracted into $farDir!"
    } else {
      Write-Host "  Far extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Far already extracted"
  }
}

Function InstallFarPlugin() {
  Write-Host
  $farPluginInstalledMarker = MarkerName($FarPluginMrk)
  if (!(Test-Path $farPluginInstalledMarker)) {
    Write-Host 'Obtaining Far plugin for Conemu integration:'
    $source = "$CmderDir\vendor\conemu-maximus5\plugins\ConEmu"
    $target = "$CmderDir\far\Plugins\ConEmu"
    CopyDirContent $source $target
    if (Test-Path $target) {
      echo $null > $farPluginInstalledMarker
      Write-Host "  Far plugin installed into $target!"
    } else {
      Write-Host '  Far plugin installation failed!'
      exit 1
    }
  } else {
    Write-Host 'Far plugin already installed'
  }
}

Function InstallPortableJVM() {
  Write-Host
  $jvmInstalledMarker = MarkerName($JvmMrk)
  if (!(Test-Path $jvmInstalledMarker)) {
    Write-Host 'Obtaining portable JVM:'
    DOwnloadFromOracleIfNecessary $jvmURL $Tmp $JvmTmp
    $target = "$CmderDir\jvm"
    New-Item $target -type directory -Force
    $tarArgs = @('-C', "$target", '-xzf', "./tmp/$JvmTmp", '--strip-components=1')
    $jvmInstallation = Start-Process -FilePath $tarEXE -ArgumentList $tarArgs -PassThru -NoNewWindow -Wait -WorkingDirectory '.'
    if ($jvmInstallation.ExitCode -eq 0) {
      echo $null > $jvmInstalledMarker
      Write-Host "  JVM installed into $target!"
    } else {
      Write-Host "  JVM installation failed!"
      exit 1
    }
  } else {
    Write-Host "Portable JVM already installed"
  }
}

Function InstallPortableJDK() {
  Write-Host
  $jdkInstalledMarker = MarkerName($JdkMrk)
  if (!(Test-Path $jdkInstalledMarker)) {
    Write-Host 'Obtaining portable JDK:'
    $JdkEXE = DownloadFromOracleIfNecessary $jdkURL $Tmp $JdkTmp
    Write-Host '  extracting src.zip...'
    $jdkDir = "$CmderDir\jdk"
    $cabextractArgs = @("$jdkEXE", '-d', "$jdkDir", '-F', 'src.zip', '-q')
    $jdkExtract = Start-Process -FilePath $cabextractEXE -ArgumentList $cabextractArgs -PassThru -NoNewWindow -Wait
    if ($jdkExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting tools.zip...'
    $cabextractArgs = @("$jdkEXE", '-d', "$jdkDir", '-F', 'tools.zip', '-q')
    $jdkExtract = Start-Process -FilePath $cabextractEXE -ArgumentList $cabextractArgs -PassThru -NoNewWindow -Wait
    if ($jdkExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting unziping tools.zip...'
    $unzipArgs = @('-q', '-o', "$jdkDir\tools.zip")
    $toolsExtract = Start-Process -FilePath $unzipEXE -ArgumentList $unzipArgs -PassThru -NoNewWindow -Wait -WorkingDirectory $jdkDir
    if ($toolsExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting .pack to .jar...'
    $packFiles = Get-ChildItem $jdkDir -recurse -include *.pack
    $unpack200EXE = "$jdkDir\bin\unpack200.exe"
    Foreach($packFile IN $packFiles) {
      $jarFile = $packFile -replace '\.pack$', '.jar'
      $unpack200Args = @($packFile, $jarFile)
      $unpack200 = Start-Process -FilePath $unpack200EXE -ArgumentList $unpack200Args -PassThru -NoNewWindow -Wait
      if ($unpack200.ExitCode -ne 0) {
        Write-Host '  JDK installation failed!'
        exit 1
      }
      Remove-Item $packFile
    }
    Remove-Item "$jdkDir\tools.zip"
    echo $null > $jdkInstalledMarker
    Write-Host "  JDK installed into $jdkDir!"
  } else {
    Write-Host 'Portable JDK already installed'
  }
}

Function InstallClojure() {
  Write-Host
  $clojureInstalledMarker = MarkerName($ClojureMrk)
  if (!(Test-Path $clojureInstalledMarker)) {
    Write-Host 'Obtaining Clojure:'
    $ClojureZIP = DownloadFileIfNecessary $clojureURL $Tmp $ClojureTmp
    $clojureDir = "$CmderDir\clojure"
    if (CopyDirContent "$clojureZIP\$ClojureMrk" $clojureDir) {
      echo $null > $clojureInstalledMarker
      Write-Host "  Clojure extracted into $clojureDir!"
    } else {
      Write-Host '  Clojure extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Clojure already extracted'
  }
}

Function InstallLeiningen() {
  Write-Host
  $leiningenInstalledMarker = MarkerName($LeiningenMrk)
  if (!(Test-Path $leiningenInstalledMarker)) {
    Write-Host 'Obtaining Leiningen:'
    $leinDir    = "$CygwinDir\bin"
    $leinBatDir = "$CmderDir\bin"
    DOwnloadFileIfNecessary $leiningenURL       $leinDir    'lein'
    DOwnloadFileIfNecessary "$leiningenURL.bat" $leinBatDir 'lein.bat'
    echo $null > $leiningenInstalledMarker
    Write-Host '  Leiningen obtained!'
  } else {
    Write-Host 'Leiningen already obtained'
  }
}

Function InstallGradle() {
  Write-Host
  $gradleInstalledMarker = MarkerName($GradleMrk)
  if (!(Test-Path $gradleInstalledMarker)) {
    Write-Host 'Obtaining Gradle:'
    $GradleZIP = DownloadFileIfNecessary $gradleURL $Tmp $GradleTmp
    $gradleDir = "$CmderDir\tools"
    if (CopyDirContent $gradleZIP $gradleDir) {
      echo $null > $gradleInstalledMarker
      Write-Host "  Gradle extracted into $gradleDir!"
    } else {
      Write-Host '  Gradle extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Gradle already extracted'
  }
}

Function InstallAtom() {
  Write-Host
  $atomInstalledMarker = MarkerName($AtomMrk)
  if (!(Test-Path $atomInstalledMarker)) {
    Write-Host 'Obtaining Atom:'
    $AtomZIP = DownloadWithWgetIfNecessary $atomURL $Tmp $AtomTmp
    $atomDir = "$CygwinDir\usr\local\bin\atom"
    if (CopyDirContent "$atomZIP\Atom" $atomDir) {
      echo $null > $atomInstalledMarker
      Write-Host "  Atom extracted into $atomDir!"
    } else {
      Write-Host '  Atom extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Atom already extracted'
  }
}

Function InstallLightTable() {
  Write-Host
  $lightTableInstalledMarker = MarkerName($LightTableMrk)
  if (!(Test-Path $lightTableInstalledMarker)) {
    Write-Host 'Obtaining LightTable:'
    $LightTableZIP = DownloadWithWgetIfNecessary $lightTableURL $Tmp $LightTableTmp
    $lightTableDir = "$CygwinDir\usr\local\bin\LightTable"
    if (CopyDirContent "$lightTableZIP\LightTable" $lightTableDir) {
      echo $null > $lightTableInstalledMarker
      Write-Host "  LightTable extracted into $LightTableDir!"
    } else {
      Write-Host '  LightTable extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'LightTable already extracted'
  }
}

Function InstallNightCode() {
  Write-Host
  $nightcodeInstalledMarker = MarkerName($NightCodeMrk)
  if (!(Test-Path $nightcodeInstalledMarker)) {
    Write-Host 'Obtaining NightCode:'
    $nightcodeDir = "$CygwinDir\usr\local\bin\nightcode"
    DOwnloadFileIfNecessary $nightCoreURL $nightcodeDir $NightCodeTmp
    echo $null > $nightcodeInstalledMarker
    Write-Host '  NightCode obtained!'
  } else {
    Write-Host 'NightCode already obtained'
  }
}

Function InstallSublimeText() {
  Write-Host
  $sublimeTextInstalledMarker = MarkerName($SublimeTextMrk)
  if (!(Test-Path $sublimeTextInstalledMarker)) {
    Write-Host 'Obtaining Sublime Text 3:'
    $SublimeTextZIP = DownloadWithWgetIfNecessary $sublimeTextURL $Tmp $SublimeTextTmp
    $sublimeTextDir = "$CygwinDir\usr\local\bin\sublime-text"
    if (CopyDirContent $sublimeTextZIP $sublimeTextDir) {
      echo $null > $sublimeTextInstalledMarker
      Write-Host "  Sublime Text 3 extracted into $sublimeTextDir!"
    } else {
      Write-Host '  Sublime Text 3 extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Sublime Text 3 already extracted'
  }
}

Function InstallGitPrompt() {
  Write-Host
  $gitPromptInstalledMarker = MarkerName($GitPromptMrk)
  if (!(Test-Path $gitPromptInstalledMarker)) {
    Write-Host 'Obtaining git-prompt.sh:'
    $source = "$MsysgitDir\etc\git-prompt.sh"
    $target = "$CygwinDir\etc"
    Copy-Item $source $target
    if (Test-Path $target) {
      echo $null > $gitPromptInstalledMarker
      Write-Host "  git-prompt.sh installed into $target!"
    } else {
      Write-Host '  git-prompt.sh installation failed!'
      exit 1
    }
  } else {
    Write-Host 'git-prompt.sh already installed'
  }
}

Function CreateSymlinks() {
  Write-Host
  $symlinkCreatedMarker = MarkerName($SymlinksMrk)
  if (!(Test-Path $symlinkCreatedMarker)) {
    Write-Host 'Creating symlinks:'
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\atom.exe"         "$CygwinDir\usr\local\bin\atom\atom.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\light-table.exe"  "$CygwinDir\usr\local\bin\LightTable\LightTable.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\nightcode.jar"    "$CygwinDir\usr\local\bin\nightcode\$NightCodeTmp"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\sublime_text.exe" "$CygwinDir\usr\local\bin\sublime-text\sublime_text.exe"
    #echo $null > $symlinkCreatedMarker
    Write-Host '  symlinks created!'
  } else {
    Write-Host 'Symlinks already created'
  }
}

Function DownloadIcons() {
  Write-Host
  $iconsInstalledMarker = MarkerName($IconsMrk)
  if (!(Test-Path $iconsInstalledMarker)) {
    Write-Host 'Obtaining icons:'
    $iconsDir = "$CmderDir\icons"
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/46956/download/ico' $iconsDir 'cmd.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/47749/download/ico' $iconsDir 'cygwin.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/23880/download/ico' $iconsDir 'far.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/9106/download/ico'  $iconsDir 'java.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/8974/download/ico'  $iconsDir 'python.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/8978/download/ico'  $iconsDir 'ruby.ico'
    echo $null > $iconsInstalledMarker
    Write-Host '  icons obtained!'
  } else {
    Write-Host 'Icons already obtained'
  }
}

Function InstallSettings() {
  Write-Host
  $settingsInstalledMarker = MarkerName($SettingsMrk)
  if (!(Test-Path $settingsInstalledMarker)) {
    Write-Host 'Copying settings:'
    $source = "$CurrentDir\preconfigs"
    $target = $CurrentDir
    CopyDirContent $source $target
    echo $null > $settingsInstalledMarker
    Write-Host '  settings copied!'
  } else {
    Write-Host 'Settings already copied'
  }
}

# Build logic - order of tasks execution
################################################################################

Function BuildLogic() {
  Write-Host "current dir : $CurrentDir"
  Write-Host "tmp dir     : $Tmp"
  Write-Host "target dir  : $CmderDir"

  InstallCmder
  InstallCygwin
  InstallAptCyg
  InstallDepotTools
  InstallFar
  InstallFarPlugin
  InstallPortableJVM
  InstallPortableJDK
  InstallClojure
  InstallLeiningen
  InstallGradle
  InstallAtom
  InstallLightTable
  InstallNightCode
  InstallSublimeText
  CreateSymlinks
  DownloadIcons
  InstallGitPrompt
  InstallSettings

  Write-Host
  Write-Host "Cmder built successfully!"
}

# Run script
################################################################################

BuildLogic
