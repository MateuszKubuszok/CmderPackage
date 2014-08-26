Import-Module BitsTransfer

# Paths
################################################################################

$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp        = "$CurrentDir\tmp"
$CmderDir   = "$CurrentDir\cmder"
$CygwinDir  = "$CmderDir\cygwin"
$MsysgitDir = "$CmderDir\vendor\msysgit"

$7zaEXE        = "$CygwinDir\lib\p7zip\7za.exe"
$cabextractEXE = "$CygwinDir\bin\cabextract.exe"
$gitEXE        = "$MsysgitDir\bin\git"
$lnEXE         = "$CygwinDir\bin\ln"
$tarEXE        = "$MsysgitDir\bin\tar.exe"
$unzipEXE      = "$MsysgitDir\bin\unzip.exe"
$wgetEXE       = "$CygwinDir\bin\wget.exe"

# Variables
################################################################################

$cmderURL       = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip'
$cmderTmp       = 'cmder-v1.1.3.zip'
$cmderMrk       = 'cmder-v1.1.3'
$cygwinURL      = 'https://cygwin.com/setup-x86_64.exe'
$cygwinTmp      = 'setup-x86_64.exe'
$cygwinMrk      = 'cygwin'
$aptCygURL      = 'https://apt-cyg.googlecode.com/svn/trunk/apt-cyg'
$aptCygMrk      = 'aptcyg'
$depotToolsURL  = 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
$depotToolsMrk  = 'depottools'
$farURL         = 'http://www.farmanager.com/files/Far30b4040.x64.20140810.7z'
$farTmp         = 'Far30b4040.x64.20140810.7z'
$farMrk         = 'far30b4040.x64.20140810'
$farPluginMrk   = "farplugin-$farMrk-$cmderMrk"
$jvmURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jre-8u20-windows-x64.tar.gz'
$jvmTmp         = 'jre-8u20-windows-x64.tar.gz'
$jvmMrk         = 'jre-8u20'
$jdkURL         = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-windows-x64.exe'
$jdkTmp         = 'jdk-8u20-windows-x64.exe'
$jdkMrk         = 'jdk-8u20'
$clojureURL     = 'http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.zip'
$clojureTmp     = 'clojure-1.6.0.zip'
$clojureMrk     = 'clojure-1.6.0'
$leiningenURL   = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'
$leiningenMrk   = 'leiningen'
$gradleURL      = 'https://services.gradle.org/distributions/gradle-1.11-all.zip'
$gradleTmp      = 'gradle-1.11-all.zip'
$gradleMrk      = 'gradle-1.11'
$atomURL        = 'https://atom.io/download/windows'
$atomTmp        = 'atom-windows.zip'
$atomMrk        = 'atom'
$lightTableURL  = 'https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.7/LightTableWin.zip'
$lightTableTmp  = 'LightTableWin-0.6.7.zip'
$lightTableMrk  = 'lighttable-0.6.7'
$nightCoreURL   = 'https://github.com/oakes/Nightcode/releases/download/0.3.10/nightcode-0.3.10-standalone.jar'
$nightCodeTmp   = 'nightcode-0.3.10-standalone.jar'
$nightCodeMrk   = 'nightcode-0.3.10'
$sublimeTextURL = '"http://c758482.r82.cf2.rackcdn.com/Sublime Text Build 3059 x64.zip"'
$sublimeTextTmp = 'Sublime-Text-Build-3059-x64.zip'
$sublimeTextMrk = 'sublime-text-3059'
$gitPromptMrk   = 'gitprompt'
$symlinksMrk    = 'symlinks'
$iconsMrk       = 'icons'
$settingsMrk    = 'settings'

# Helper functions
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
  if (!(Test-Path $target)) {
    Write-Host "  failed to download $source!"
    exit 1
  } else {
    Write-Host "  $source downloaded successfully"
  }
}

Function CopyDirContent($source, $target) {
  Write-Host "  copying $source into $target..."
  EnsureSourceExists $source
  New-Item $target -type directory -Force
  $overrideSilent = 0x14
  $shell = New-Object -com shell.application
  $content = $shell.NameSpace($source)
  $shell.NameSpace($target).CopyHere($content.items(), $overrideSilent)
  if (Test-Path -Path "$target\*") {
    return 1
  } else {
    Write-Host " failed to copy $source content!"
    exit 1
  }
}

Function EnsureSourceExists($source) {
  if (!(Test-Path $source)) {
    Write-Host "  $source doesn't exists!"
    exit 1
  }
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
  if (!(Test-Path $from)) {
    Write-Host "  failed to symlink $from -> $to!"
    exit 1
  } else {
    Write-Host "  symlink $from -> $to created"
  }
}

# Build logic
################################################################################

Function InstallCmder() {
  Write-Host
  $cmderInstalledMarker = MarkerName($cmderMrk)
  if (!(Test-Path $cmderInstalledMarker)) {
    Write-Host 'Obtaining Cmder:'
    $cmderZIP = DownloadFileIfNecessary $cmderURL $Tmp $cmderTmp
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
  $cygwinInstalledMarker = MarkerName($cygwinMrk)
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host 'Obtaining Cygwin:'
    $cygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp $cygwinTmp
    $cygwinArgs = @(
        '--no-admin', '--upgrade-also', '--quiet-mode',
        '--no-desktop', '--no-startmenu', '--no-shortcuts',
        # Directories `
        '--root', $CygwinDir,
        '--local-package-dir', $Tmp,
        # Sources `
        '--site', 'ftp://mirrors.kernel.org/sourceware/cygwin',
        '--site', 'ftp://ftp.cygwinports.org/pub/cygwinports',
        '--pubkey', 'http://cygwinports.org/ports.gpg',
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
        '-P', 'wget')
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
  $aptCygInstalledMarker = MarkerName($aptcygMrk)
  if (!(Test-Path $aptCygInstalledMarker)) {
    Write-Host 'Obtaining apt-cyg:'
    $aptCygDir = "$cygwinDir\bin"
    $aptCygFile = DownloadFileIfNecessary $aptCygURL $aptCygDir $aptCygTmp
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
  $depotToolsInstalledMarker = MarkerName($depotToolsMrk)
  if (!(Test-Path $depotToolsInstalledMarker)) {
    Write-Host 'Obtaining depot-tools:'
    $depotToolsDir = "$CygwinDir\opt\depot_tools"
    $gitArgs = @('clone', $depotToolsURL, $depotToolsDir)
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
  $farInstalledMarker = MarkerName($farMrk)
  if (!(Test-Path $farInstalledMarker)) {
    Write-Host 'Obtaining Far:'
    DownloadFileIfNecessary $farURL $Tmp $farTmp
    $far7Z  = "tmp/$farTmp"
    $farDir = 'cmder/far'
    $7zaArgs = @('x', $far7Z, "-o$farDir", '-y')
    New-Item $farDir -type directory -Force
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
  $farPluginInstalledMarker = MarkerName($farPluginMrk)
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
  $jvmInstalledMarker = MarkerName($jvmMrk)
  if (!(Test-Path $jvmInstalledMarker)) {
    Write-Host 'Obtaining portable JVM:'
    DownloadFromOracleIfNecessary $jvmURL $Tmp $jvmTmp
    $target = "$CmderDir\jvm"
    New-Item $target -type directory -Force
    $tarArgs = @('-C', "$target", '-xzf', "./tmp/$jvmTmp", '--strip-components=1')
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
  $jdkInstalledMarker = MarkerName($jdkMrk)
  if (!(Test-Path $jdkInstalledMarker)) {
    Write-Host 'Obtaining portable JDK:'
    $jdkEXE = DownloadFromOracleIfNecessary $jdkURL $Tmp $jdkTmp
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
  $clojureInstalledMarker = MarkerName($clojureMrk)
  if (!(Test-Path $clojureInstalledMarker)) {
    Write-Host 'Obtaining Clojure:'
    $clojureZIP = DownloadFileIfNecessary $clojureURL $Tmp $clojureTmp
    $clojureDir = "$CmderDir\clojure"
    if (CopyDirContent "$clojureZIP\$clojureMrk" $clojureDir) {
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
  $leiningenInstalledMarker = MarkerName($leiningenMrk)
  if (!(Test-Path $leiningenInstalledMarker)) {
    Write-Host 'Obtaining Leiningen:'
    $leinDir    = "$CygwinDir\bin"
    $leinBatDir = "$CmderDir\bin"
    DownloadFileIfNecessary $leiningenURL       $leinDir    'lein'
    DownloadFileIfNecessary "$leiningenURL.bat" $leinBatDir 'lein.bat'
    echo $null > $leiningenInstalledMarker
    Write-Host '  Leiningen obtained!'
  } else {
    Write-Host 'Leiningen already obtained'
  }
}

Function InstallGradle() {
  Write-Host
  $gradleInstalledMarker = MarkerName($gradleMrk)
  if (!(Test-Path $gradleInstalledMarker)) {
    Write-Host 'Obtaining Gradle:'
    $gradleZIP = DownloadFileIfNecessary $gradleURL $Tmp $gradleTmp
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
  $atomInstalledMarker = MarkerName($atomMrk)
  if (!(Test-Path $atomInstalledMarker)) {
    Write-Host 'Obtaining Atom:'
    $atomZIP = DownloadWithWgetIfNecessary $atomURL $Tmp $atomTmp
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
  $lightTableInstalledMarker = MarkerName($lightTableMrk)
  if (!(Test-Path $lightTableInstalledMarker)) {
    Write-Host 'Obtaining LightTable:'
    $lightTableZIP = DownloadWithWgetIfNecessary $lightTableURL $Tmp $lightTableTmp
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
  $nightcodeInstalledMarker = MarkerName($nightCodeMrk)
  if (!(Test-Path $nightcodeInstalledMarker)) {
    Write-Host 'Obtaining NightCode:'
    $nightcodeDir = "$CygwinDir\usr\local\bin\nightcode"
    DownloadFileIfNecessary $nightCoreURL $nightcodeDir $nightCodeTmp
    echo $null > $nightcodeInstalledMarker
    Write-Host '  NightCode obtained!'
  } else {
    Write-Host 'NightCode already obtained'
  }
}

Function InstallSublimeText() {
  Write-Host
  $sublimeTextInstalledMarker = MarkerName($sublimeTextMrk)
  if (!(Test-Path $sublimeTextInstalledMarker)) {
    Write-Host 'Obtaining Sublime Text 3:'
    $sublimeTextZIP = DownloadWithWgetIfNecessary $sublimeTextURL $Tmp $sublimeTextTmp
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
  $gitPromptInstalledMarker = MarkerName($gitPromptMrk)
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
  $symlinkCreatedMarker = MarkerName($symlinksMrk)
  if (!(Test-Path $symlinkCreatedMarker)) {
    Write-Host 'Creating symlinks:'
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\atom.exe"         "$CygwinDir\usr\local\bin\atom\atom.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\light-table.exe"  "$CygwinDir\usr\local\bin\LightTable\LightTable.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\nightcode.jar"    "$CygwinDir\usr\local\bin\nightcode\$nightCodeTmp"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\sublime_text.exe" "$CygwinDir\usr\local\bin\sublime-text\sublime_text.exe"
    #echo $null > $symlinkCreatedMarker
    Write-Host '  symlinks created!'
  } else {
    Write-Host 'Symlinks already created'
  }
}

Function DownloadIcons() {
  Write-Host
  $iconsInstalledMarker = MarkerName($iconsMrk)
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
  $settingsInstalledMarker = MarkerName($settingsMrk)
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

Function BuildLogic() {
  Write-Host "current dir: $CurrentDir"
  Write-Host "tmp     dir: $Tmp"
  Write-Host "target  dir: $CmderDir"

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
