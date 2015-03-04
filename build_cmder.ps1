Import-Module BitsTransfer

# Paths - commonly referred directories and executables
################################################################################

$CurrentDir     = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp            = "$CurrentDir\tmp"
$CmderDir       = "$CurrentDir\cmder"
$ConEmuDir      = "$CmderDir\vendor\conemu-maximus5"
$CygwinDir      = "$CmderDir\cygwin"
$CygwinULBDir   = "$CygwinDir\usr\local\bin"
$MsysgitDir     = "$CmderDir\vendor\msysgit"

$FarDir         = "$CmderDir\far"
$IconsDir       = "$CmderDir\icons"
$PreconfigsDir  = "$CurrentDir\preconfigs"
$AptCygDir      = "$CygwinDir\bin"
$DepotToolsDir  = "$CygwinDir\opt\depot_tools"
$GypDir         = "/opt/gyp"
$ClocDir        = "$CygwinDir\bin"
$JvmDir         = "$CmderDir\jvm"
$JdkDir         = "$CmderDir\jdk"
$ClojureDir     = "$CmderDir\clojure"
$LeinDir        = "$CygwinDir\bin"
$LeinBatDir     = "$CmderDir\bin"
$GradleDir      = "$CmderDir\tools\gradle"
$NodejsDir      = "$CmderDir\node"
$AtomDir        = "$CygwinULBDir\atom"
$LightTableDir  = "$CygwinULBDir\LightTable"
$NightCodeDir   = "$CygwinULBDir\nightcode"
$SublimeTextDir = "$CygwinULBDir\sublime-text"

$7zaEXE         = "$CygwinDir\lib\p7zip\7za.exe"
$CabextractEXE  = "$CygwinDir\bin\cabextract.exe"
$GitEXE         = "$MsysgitDir\bin\git.exe"
$SvnEXE         = "$CygwinDir\bin\svn.exe"
$LnEXE          = "$CygwinDir\bin\ln.exe"
$MsiexecEXE     = 'msiexec.exe'
$TarEXE         = "$CygwinDir\bin\tar.exe"
$Unpack200EXE   = "$JdkDir\bin\unpack200.exe"
$UnzipEXE       = "$MsysgitDir\bin\unzip.exe"
$WgetEXE        = "$CygwinDir\bin\wget.exe"

# Components - subject to change if we want to e.g. update some dependency
################################################################################

$CmderURL       = 'https://github.com/bliker/cmder/releases/download/v1.1.4.1/cmder.zip'
$CmderTmp       = 'cmder-v1.1.4.1.zip'
$CmderMrk       = 'cmder-v1.1.4.1'
$ConEmuURL      = 'https://conemu.github.io/install2.ps1'
$ConEmuMrk      = "conemu-$CmderMrk"
$FarURL         = 'http://www.farmanager.com/files/Far30b4242.x86.20150117.7z'
$FarTmp         = 'Far30b4242.x86.20150117.7z'
$FarMrk         = 'far30b4242.x86.20150117'
$FarPluginMrk   = "farplugin-$FarMrk-$ConEmuMrk"
$IconsMrk       = 'icons'
$SettingsMrk    = 'settings'
$CygwinURL      = 'https://cygwin.com/setup-x86_64.exe'
$CygwinTmp      = 'setup-x86_64.exe'
$CygwinMrk      = 'cygwin'
$AptCygURL      = 'https://apt-cyg.googlecode.com/svn/trunk/apt-cyg'
$AptCygMrk      = 'aptcyg'
$AptCygTmp      = 'apt-cyg'
$GitPromptMrk   = 'gitprompt'
$ClocURL        = 'http://downloads.sourceforge.net/project/cloc/cloc/v1.62/cloc-1.62.exe'
$ClocTmp        = 'cloc.exe'
$ClocMrk        = 'cloc-1.62'
$DepotToolsURL  = 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
$DepotToolsMrk  = 'depottools'
$GypURL         = 'http://gyp.googlecode.com/svn/trunk/'
$GypMrk         = 'gyp'
$JvmURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jre-8u40-windows-x64.tar.gz'
$JvmTmp         = 'jre-8u40-windows-x64.tar.gz'
$JvmMrk         = 'jre-8u40'
$JdkURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-windows-x64.exe'
$JdkTmp         = 'jdk-8u40-windows-x64.exe'
$JdkMrk         = 'jdk-8u40'
$ClojureURL     = 'http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.zip'
$ClojureTmp     = 'clojure-1.6.0.zip'
$ClojureMrk     = 'clojure-1.6.0'
$LeiningenURL   = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'
$LeiningenMrk   = 'leiningen'
$GradleURL      = 'https://services.gradle.org/distributions/gradle-2.2.1-all.zip'
$GradleTmp      = 'gradle-2.2.1-all.zip'
$GradleMrk      = 'gradle-2.2.1'
$NodeJSURL      = 'http://nodejs.org/dist/v0.12.0/x64/node-v0.12.0-x64.msi'
$NodeJSTmp      = 'node-v0.12.0-x64.msi'
$NodeJSMrk      = 'node-v0.12.0'
$AtomURL        = 'https://atom.io/download/windows'
$AtomTmp        = 'atom-windows.zip'
$AtomMrk        = 'atom'
$LightTableURL  = 'https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.7.2/LightTableWin.zip'
$LightTableTmp  = 'LightTableWin-0.7.2.zip'
$LightTableMrk  = 'lighttable-0.7.2'
$NightCodeURL   = 'https://github.com/oakes/Nightcode/releases/download/0.4.4/nightcode-0.4.4-standalone.jar'
$NightCodeTmp   = 'nightcode-0.4.4-standalone.jar'
$NightCodeMrk   = 'nightcode-0.4.4'
$SublimeTextURL = '"http://c758482.r82.cf2.rackcdn.com/Sublime Text Build 3074 x64.zip"'
$SublimeTextTmp = 'Sublime-Text-Build-3074-x64.zip'
$SublimeTextMrk = 'sublime-text-3074'
$SymlinksMrk    = 'symlinks'

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
  '-P', 'git-completion',
  '-P', 'libcrypt-devel',
  '-P', 'libsqlite3-devel',
  '-P', 'make',
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
  '-P', 'curl',
  '-P', 'whois',
  # Category PHP `
  '-C', 'PHP',
  # Category Python `
  '-C', 'Python',
  # Category Ruby `
  '-C', 'Ruby',
  # Shells `
  '-P', 'bash-completion',
  # System `
  '-P', 'dosbox',
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

Function CopyItem($source, $target) {
  $targetDir = split-path -parent $target
  if (!(Test-Path $targetDir)) {
    New-Item $targetDir -type directory -Force
  }
  Copy-Item $source $target
  return (Test-Path $target)
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
    Start-Process $WgetEXE -ArgumentList $wgetArgs -PassThru -Wait -NoNewWindow
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
    Start-Process $WgetEXE -ArgumentList $wgetArgs -PassThru -Wait -NoNewWindow
  }
  EnsureFileDownloaded $source $target
  return $target
}

Function DownloadIconIfNecessary($id, $localName) {
  return DownloadFileIfNecessary "https://www.iconfinder.com/icons/$id/download/ico" $IconsDir "$localName.ico"
}

Function CreateCygwinSymlink($from, $to) {
  if (!(Test-Path $from)) {
    $lnArgs = @('-s', $to, $from)
    Start-Process $LnEXE -ArgumentList $lnArgs -PassThru -Wait -NoNewWindow
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

# Conemu tasks
################################################################################

Function InstallCmder() {
  Write-Host
  $cmderInstalledMarker = MarkerName($CmderMrk)
  if (!(Test-Path $cmderInstalledMarker)) {
    Write-Host 'Obtaining Cmder:'
    $CmderZIP = DownloadFileIfNecessary $CmderURL $Tmp $CmderTmp
    if (CopyDirContent $cmderZIP $CmderDir) {
      echo $null > $cmderInstalledMarker
      Write-Host "  Cmder extracted into $CmderDir!"
    } else {
      Write-Host '  Cmder extraction failed!'
      exit 1
    }
  } else {
    Write-Host "Cmder already extracted"
  }
  $env:Path += ";$MsysgitDir\bin"
}

Function UpgradeConEmu() {
  Write-Host
  $conEmuUpgradedMarker = MarkerName($ConEmuMrk)
  if (!(Test-Path $conEmuUpgradedMarker)) {
    Write-Host 'Upgrading ConEmu:'
    $command = "set ver 'preview'; " +
               "set dst '$ConEmuDir'; " +
               'set lnk $FALSE; ' +
               'set run $FALSE; ' +
               "iex ((new-object net.webclient).DownloadString('$ConEmuURL'))"
    powershell -NoProfile -ExecutionPolicy Unrestricted -Command $command
    if ($?) {
      echo $null > $conEmuUpgradedMarker
      Write-Host "  ConEmu upgraded for $CmderDir!"
    } else {
      Write-Host "  ConEmu upgrade failed!"
      exit 1
    }
  } else {
    Write-Host "ConEmu already upgraded"
  }
}

Function InstallFar() {
  Write-Host
  $farInstalledMarker = MarkerName($FarMrk)
  if (!(Test-Path $farInstalledMarker)) {
    Write-Host 'Obtaining Far:'
    $far7Z = DownloadFileIfNecessary $FarURL $Tmp $FarTmp
    $7zaArgs = @('x', "tmp/$FarTmp", "-o$FarDir", '-y')
    New-Item $FarDir -type directory -Force
    $farInstallation = Start-Process $7zaEXE -ArgumentList $7zaArgs -PassThru -Wait -NoNewWindow
    if ($farInstallation.ExitCode -eq 0) {
      echo $null > $farInstalledMarker
      Write-Host "  Far extracted into $FarDir!"
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
    $target = "$FarDir\Plugins\ConEmu"
    if (CopyDirContent $source $target) {
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

Function DownloadIcons() {
  Write-Host
  $iconsInstalledMarker = MarkerName($IconsMrk)
  if (!(Test-Path $iconsInstalledMarker)) {
    Write-Host 'Obtaining icons:'
    DownloadIconIfNecessary '46956' 'cmd'
    DownloadIconIfNecessary '47749' 'cygwin'
    DownloadIconIfNecessary '23880' 'far'
    DownloadIconIfNecessary '9106'  'java'
    DownloadIconIfNecessary '24734' 'node'
    DownloadIconIfNecessary '8974'  'python'
    DownloadIconIfNecessary '8978'  'ruby'
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
    CopyDirContent $PreconfigsDir $CurrentDir
    echo $null > $settingsInstalledMarker
    Write-Host '  settings copied!'
  } else {
    Write-Host 'Settings already copied'
  }
}

# Cygiwn tasks
################################################################################

Function InstallCygwin() {
  Write-Host
  $cygwinInstalledMarker = MarkerName($CygwinMrk)
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host 'Obtaining Cygwin:'
    $CygwinEXE = DownloadFileIfNecessary $CygwinURL $Tmp $CygwinTmp
    $cygwinArgs = @(
        '--no-admin', '--upgrade-also', '--quiet-mode',
        '--no-desktop', '--no-startmenu', '--no-shortcuts',
        # Directories `
        '--root', $CygwinDir,
        '--local-package-dir', $Tmp) + $CygwinSources + $CygwinPackages
    Write-Host '  Running Cygwin setup...'
    $cygwinInstallation = Start-Process $CygwinEXE -ArgumentList $cygwinArgs -PassThru -Wait -NoNewWindow
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
    $AptCygFile = DownloadFileIfNecessary $AptCygURL $AptCygDir $AptCygTmp
    if (Test-Path $aptCygFile) {
      echo $null > $aptCygInstalledMarker
      Write-Host "  apt-cyg installed into $AptCygDir!"
    } else {
      Write-Host '  apt-cyg installation failed!'
      exit 1
    }
  } else {
    Write-Host 'apt-cyg already installed'
  }
}

Function InstallGitPrompt() {
  Write-Host
  $gitPromptInstalledMarker = MarkerName($GitPromptMrk)
  if (!(Test-Path $gitPromptInstalledMarker)) {
    Write-Host 'Obtaining git-prompt.sh:'
    $source = "$MsysgitDir\etc\git-prompt.sh"
    $target = "$CygwinDir\etc"
    if (CopyItem $source $target) {
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

Function InstallDepotTools() {
  Write-Host
  $depotToolsInstalledMarker = MarkerName($DepotToolsMrk)
  if (!(Test-Path $depotToolsInstalledMarker)) {
    Write-Host 'Obtaining depot-tools:'
    if (!(Test-Path "$DepotToolsDir\.git")) {
      $gitArgs = @('clone', $DepotToolsURL, $DepotToolsDir,
                   '--config', 'core.autocrlf=false',
                   '--config', 'core.safecrlf=true',
                   '--config', 'core.eol=lf')
      New-Item $DepotToolsDir -type directory -Force
      $depotToolsInstallation = Start-Process $GitEXE -ArgumentList $gitArgs -PassThru -Wait -NoNewWindow
      if ($depotToolsInstallation.ExitCode -ne 0) {
        Write-Host '  depottools installation failed!'
        exit 1
      }
    }
    echo $null > $depotToolsInstalledMarker
    Write-Host "  depottools installed into $DepotToolsDir!"
  } else {
    Write-Host 'depottools already installed'
  }
}

Function InstallGyp() {
  Write-Host
  $gypInstalledMarker = MarkerName($GypMrk)
  if (!(Test-Path $gypInstalledMarker)) {
    Write-Host 'Obtaining GYP:'
    if (!(Test-Path "$GypDir\.svn")) {
      $svnArgs = @('checkout', $GypURL, $GypDir)
      New-Item $DepotToolsDir -type directory -Force
      $gypInstallation = Start-Process $SvnEXE -ArgumentList $svnArgs -PassThru -Wait -NoNewWindow
      if ($gypInstallation.ExitCode -ne 0) {
        Write-Host '  GYP installation failed!'
        exit 1
      }
    }
    echo $null > $gypInstalledMarker
    Write-Host "  GYP installed into $GypDir!"
  } else {
    Write-Host 'GYP already installed'
  }
}

Function InstallCloc() {
  Write-Host
  $clocInstalledMarker = MarkerName($ClocMrk)
  if (!(Test-Path $clocInstalledMarker)) {
    Write-Host 'Obtaining cloc:'
    $clocEXE = DownloadFileIfNecessary $ClocURL $Tmp $ClocTmp
    if (CopyItem $clocEXE "$ClocDir\$ClocTmp") {
      echo $null > $clocInstalledMarker
      Write-Host '  cloc obtained!'
    } else {
      Write-Host '  cloc installation failed!'
      exit 1
    }
  } else {
    Write-Host 'cloc already obtained'
  }
}


# Java tasks
################################################################################

Function InstallPortableJVM() {
  Write-Host
  $jvmInstalledMarker = MarkerName($JvmMrk)
  if (!(Test-Path $jvmInstalledMarker)) {
    Write-Host 'Obtaining portable JVM:'
    $jvmTar = DownloadFromOracleIfNecessary $JvmURL $Tmp $JvmTmp
    New-Item $JvmDir -type directory -Force
    $tarArgs = @('-C', "cmder/jvm", '-xzf', "tmp/$JvmTmp", '--strip-components=1')
    $jvmInstallation = Start-Process $TarEXE -ArgumentList $tarArgs -PassThru -Wait -NoNewWindow
    if ($jvmInstallation.ExitCode -eq 0) {
      echo $null > $jvmInstalledMarker
      Write-Host "  JVM installed into $JvmDir!"
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
    $JdkEXE = DownloadFromOracleIfNecessary $JdkURL $Tmp $JdkTmp
    Write-Host '  extracting src.zip...'
    $cabextractArgs = @("$JdkEXE", '-d', "$JdkDir", '-F', 'src.zip', '-q')
    $jdkExtract = Start-Process $CabextractEXE -ArgumentList $cabextractArgs -PassThru -Wait -NoNewWindow
    if ($jdkExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting tools.zip...'
    $cabextractArgs = @("$JdkEXE", '-d', "$JdkDir", '-F', 'tools.zip', '-q')
    $jdkExtract = Start-Process $CabextractEXE -ArgumentList $cabextractArgs -PassThru -Wait -NoNewWindow
    if ($jdkExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting unziping tools.zip...'
    $unzipArgs = @('-q', '-o', "$JdkDir\tools.zip")
    $toolsExtract = Start-Process $UnzipEXE -ArgumentList $unzipArgs -PassThru -Wait -NoNewWindow -WorkingDirectory $JdkDir
    if ($toolsExtract.ExitCode -ne 0) {
      Write-Host '  JDK installation failed!'
      exit 1
    }
    Write-Host '  extracting .pack to .jar...'
    $packFiles = Get-ChildItem $JdkDir -recurse -include *.pack
    Foreach($packFile IN $packFiles) {
      $jarFile = $packFile -replace '\.pack$', '.jar'
      $unpack200Args = @($packFile, $jarFile)
      $unpack200 = Start-Process $Unpack200EXE -ArgumentList $unpack200Args -PassThru -Wait -NoNewWindow
      if ($unpack200.ExitCode -ne 0) {
        Write-Host '  JDK installation failed!'
        exit 1
      }
      Remove-Item $packFile
    }
    Remove-Item "$JdkDir\tools.zip"
    echo $null > $jdkInstalledMarker
    Write-Host "  JDK installed into $JdkDir!"
  } else {
    Write-Host 'Portable JDK already installed'
  }
}

Function InstallClojure() {
  Write-Host
  $clojureInstalledMarker = MarkerName($ClojureMrk)
  if (!(Test-Path $clojureInstalledMarker)) {
    Write-Host 'Obtaining Clojure:'
    $ClojureZIP = DownloadFileIfNecessary $ClojureURL $Tmp $ClojureTmp
    if (CopyDirContent "$clojureZIP\$ClojureMrk" $ClojureDir) {
      echo $null > $clojureInstalledMarker
      Write-Host "  Clojure extracted into $ClojureDir!"
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
    DownloadFileIfNecessary "$LeiningenURL"     $LeinDir    'lein'
    DownloadFileIfNecessary "$LeiningenURL.bat" $LeinBatDir 'lein.bat'
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
    $GradleZIP = DownloadFileIfNecessary $GradleURL $Tmp $GradleTmp
    if (CopyDirContent "$gradleZIP\$GradleMrk" $GradleDir) {
      echo $null > $gradleInstalledMarker
      Write-Host "  Gradle extracted into $GradleDir!"
    } else {
      Write-Host '  Gradle extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Gradle already extracted'
  }
}

# JS tasks
################################################################################

Function InstallNodeJS() {
  Write-Host
  $nodejsInstalledMarker = MarkerName($NodeJSMrk)
  if (!(Test-Path $nodejsInstalledMarker)) {
    Write-Host 'Obtaining portable Node.js:'
    $nodejsMSI = DownloadWithWgetIfNecessary $NodejsURL $Tmp $NodeJSTmp
    $msiexecArgs = @('/a', "$nodejsMSI", '/qb', "TARGETDIR=$Tmp\node")
    $msiexec = Start-Process $MsiexecEXE -ArgumentList $msiexecArgs -PassThru -Wait -NoNewWindow
    if ($msiexec.ExitCode -ne 0) {
      Write-Host '  Node.js extraction failed!'
      exit 1
    }
    if (CopyDirContent "$Tmp\node\nodejs" $NodejsDir) {
      echo $null > $nodejsInstalledMarker
      Write-Host "  Node.js extracted into $NodejsDir!"
    } else {
      Write-Host '  Node.js extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Node.js already extracted'
  }
}

# Editors tasks
################################################################################

Function InstallAtom() {
  Write-Host
  $atomInstalledMarker = MarkerName($AtomMrk)
  if (!(Test-Path $atomInstalledMarker)) {
    Write-Host 'Obtaining Atom:'
    $AtomZIP = DownloadWithWgetIfNecessary $AtomURL $Tmp $AtomTmp
    if (CopyDirContent "$atomZIP\Atom" $AtomDir) {
      echo $null > $atomInstalledMarker
      Write-Host "  Atom extracted into $AtomDir!"
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
    $LightTableZIP = DownloadWithWgetIfNecessary $LightTableURL $Tmp $LightTableTmp
    if (CopyDirContent "$lightTableZIP\LightTable" $LightTableDir) {
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
    $NightCodeJar = DownloadFileIfNecessary $NightCodeURL $Tmp $NightCodeTmp
    if (CopyItem $NightCodeJar "$NightCodeDir\$NightCodeTmp") {
      echo $null > $nightcodeInstalledMarker
      Write-Host '  NightCode obtained!'
    } else {
      Write-Host '  NightCode installation failed!'
      exit 1
    }
  } else {
    Write-Host 'NightCode already obtained'
  }
}

Function InstallSublimeText() {
  Write-Host
  $sublimeTextInstalledMarker = MarkerName($SublimeTextMrk)
  if (!(Test-Path $sublimeTextInstalledMarker)) {
    Write-Host 'Obtaining Sublime Text 3:'
    $sublimeTextZIP = DownloadWithWgetIfNecessary $SublimeTextURL $Tmp $SublimeTextTmp
    if (CopyDirContent $sublimeTextZIP $SublimeTextDir) {
      echo $null > $sublimeTextInstalledMarker
      Write-Host "  Sublime Text 3 extracted into $SublimeTextDir!"
    } else {
      Write-Host '  Sublime Text 3 extraction failed!'
      exit 1
    }
  } else {
    Write-Host 'Sublime Text 3 already extracted'
  }
}

Function CreateSymlinks() {
  Write-Host
  $symlinkCreatedMarker = MarkerName($SymlinksMrk)
  if (!(Test-Path $symlinkCreatedMarker)) {
    Write-Host 'Creating symlinks:'
    CreateCygwinSymlink "$CygwinULBDir\atom.exe"         "$AtomDir\atom.exe"
    CreateCygwinSymlink "$CygwinULBDir\light-table.exe"  "$LightTableDir\LightTable.exe"
    CreateCygwinSymlink "$CygwinULBDir\nightcode.jar"    "$NightCodeDir\$NightCodeTmp"
    CreateCygwinSymlink "$CygwinULBDir\sublime_text.exe" "$SublimeTextDir\sublime_text.exe"
    echo $null > $symlinkCreatedMarker
    Write-Host '  symlinks created!'
  } else {
    Write-Host 'Symlinks already created'
  }
}

# Build logic - order of tasks execution
################################################################################

Function BuildLogic() {
  Write-Host "current dir : $CurrentDir"
  Write-Host "tmp dir     : $Tmp"
  Write-Host "target dir  : $CmderDir"

  # Cmder and Cygwin have to be installed first - they that come up with tools
  # we use later
  InstallCmder
  UpgradeConEmu
  InstallCygwin
  # Now we can install some Cygwin-related utils...
  InstallAptCyg
  InstallDepotTools
  InstallGyp
  InstallCloc
  # ...followed by enhanced capabilities of both Cmder and Cygwin
  InstallFar
  InstallFarPlugin
  InstallPortableJVM
  InstallPortableJDK
  InstallClojure
  InstallLeiningen
  InstallGradle
  InstallNodeJS
  # Now lets add some nice text editors to it
  InstallAtom
  InstallLightTable
  InstallNightCode
  InstallSublimeText
  # Finally we add some personalization - symlinks, ConEmu icons and
  # configuration files
  CreateSymlinks
  DownloadIcons
  InstallGitPrompt
  InstallSettings

  Write-Host
  Write-Host "Cmder built successfully!"
}

# Run script
################################################################################

if ([IntPtr]::size -eq 4) {
  # 32-bit PowerShell
  BuildLogic
} else {
  # 64-bit PowerShell cause some Start-Process to crash - restart task as 32-bit
  Write-Host 'Restarting in 32-bit mode'
  $CurrentScript    = $MyInvocation.MyCommand.Name
  $PowerShell32     = "$env:SystemRoot\syswow64\WindowsPowerShell\v1.0\powershell.exe"
  $PowerShell32Args = @("$CurrentDir\$CurrentScript")
  Start-Process $PowerShell32 -ArgumentList $PowerShell32Args -PassThru -Wait -NoNewWindow
}
