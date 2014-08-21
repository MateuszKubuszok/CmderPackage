Import-Module BitsTransfer

# Helper functions
################################################################################

Function DownloadFileIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + '\' + $targetName
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
    Write-Host "  failed to download $source"
    exit 1
  } else {
    Write-Host "  $source downloaded successfully"
  }
}

Function ExtractZIPFile($file, $target) {
  Write-Host "  Extracting $file into $target..."
  New-Item $target -type directory -Force
  $overrideSilent = 0x14
  $shell = New-Object -com shell.application
  $zip = $shell.NameSpace($file)
  $shell.NameSpace($target).CopyHere($zip.items(), $overrideSilent)
  return 1
}

Function DownloadWithWgetIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + '\' + $targetName
  if (!(Test-Path $target)) {
    $wgetEXE = $CygwinDir + '\bin\wget.exe'
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
    $wgetEXE = $CygwinDir + '\bin\wget.exe'
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

Function CreateWindowsSymlink($from, $to) {
  if (!(Test-Path $to)) {
    $cmd = 'cmd'
    $args = @('/c', 'mklink', '$from', '$to')
    Start-Process $cmd -Verb RunAs -ArgumentList $args
  }
  EnsureSymlinkCreated $from $to
}

Function CreateCygwinSymlink($from, $to) {
  if (!(Test-Path $to)) {
    $cmd = $CygwinDir + '\bin\ln'
    $args = @('-s', '$to', '$from')
    Start-Process -FilePath $cmd -ArgumentList $args -PassThru -NoNewWindow -Wait
  }
  EnsureSymlinkCreated $from $to
}

Function EnsureSymlinkCreated($from, $to) {
  if (!(Test-Path $from)) {
    Write-Host "  failed to symlink $from -> $to"
    exit 1
  } else {
    Write-Host "  symlink $from -> $to created"
  }
}

# Build logic
################################################################################

$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp = $CurrentDir + '\tmp'
$CmderDir = $CurrentDir + '\cmder'
$CygwinDir = $CmderDir + '\cygwin'

Function InstallCmder() {
  Write-Host
  $cmderInstalledMarker = $Tmp + '\cmder.marker'
  if (!(Test-Path $cmderInstalledMarker)) {
    Write-Host "Obtaining Cmder:"
    $cmderURL = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip'
    $cmderZIP = DownloadFileIfNecessary $cmderURL $Tmp 'cmder.zip'
    if (ExtractZIPFile $cmderZIP $CurrentDir) {
      echo $null > $cmderInstalledMarker
      Write-Host "  Cmder extracted into $CmderDir!"
    } else {
      Write-Host "  Cmder extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Cmder already extracted"
  }
}

Function InstallCygwin() {
  Write-Host
  $cygwinInstalledMarker = $Tmp + '\cygwin.marker'
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host "Obtaining Cygwin:"
    $cygwinURL = 'https://cygwin.com/setup-x86_64.exe'
    $cygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp 'setup-x86_64.exe'
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
    Write-Host "Cygwin already installed"
  }
  $env:Path += ";$CygwinDir\bin"
}

Function InstallAptCyg() {
  Write-Host
  $aptCygInstalledMarker = $Tmp + '\aptcyg.marker'
  if (!(Test-Path $aptCygInstalledMarker)) {
    Write-Host "Obtaining apt-cyg:"
    $aptCygURL = "https://apt-cyg.googlecode.com/svn/trunk/apt-cyg"
    $aptCygDir = $cygwinDir + '\bin'
    $aptCygFile = DownloadFileIfNecessary $aptCygURL $aptCygDir 'apt-cyg'
    if (Test-Path $aptCygFile) {
      echo $null > $aptCygInstalledMarker
      Write-Host "  apt-cyg installed into $aptCygDir!"
    } else {
      Write-Host '  apt-cyg installation failed!'
      exit 1
    }
  } else {
    Write-Host "apt-cyg already installed"
  }
}

Function InstallDepotTools() {
  Write-Host
  $depotToolsInstalledMarker = $Tmp + '\depottools.marker'
  if (!(Test-Path $depotToolsInstalledMarker)) {
    Write-Host "Obtaining depot-tools:"
    $depotToolsDir = $CygwinDir + '\opt\depot_tools'
    $gitEXE = 'git'
    $gitArgs = @(
        'clone'
        'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
        $depotToolsDir)
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
    Write-Host "depottools already installed"
  }
}

Function InstallFar() {
  Write-Host
  $farInstalledMarker = $Tmp + '\far.marker'
  if (!(Test-Path $farInstalledMarker)) {
    Write-Host "Obtaining Far:"
    $farURL = 'http://www.farmanager.com/files/Far30b4040.x64.20140810.7z'
    DownloadFileIfNecessary $farURL $Tmp 'Far30b4040.x64.20140810.7z'
    $far7Z = 'tmp/Far30b4040.x64.20140810.7z'
    $farDir = 'cmder/far'
    $7zaEXE = $CygwinDir + '\lib\p7zip\7za.exe'
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
  $farPluginInstalledMarker = $Tmp + '\farplugin.marker'
  if (!(Test-Path $farPluginInstalledMarker)) {
    Write-Host "Obtaining Far plugin for Conemu integration:"
    $source = $CmderDir + '\vendor\conemu-maximus5\plugins\ConEmu'
    $target = $CmderDir + '\far\Plugins\ConEmu'
    New-Item $target -type directory -Force
    $overrideSilent = 0x14
    $shell = New-Object -com shell.application
    $directory = $shell.NameSpace($source)
    $shell.NameSpace($target).CopyHere($directory.items(), $overrideSilent)
    if (Test-Path $target) {
      echo $null > $farPluginInstalledMarker
      Write-Host "  Far plugin installed into $target!"
    } else {
      Write-Host "  Far plugin installation failed!"
      exit 1
    }
  } else {
    Write-Host "Far plugin already installed"
  }
}

Function InstallPortableJVM() {
  Write-Host
  $jvmInstalledMarker = $Tmp + '\jvm.marker'
  if (!(Test-Path $jvmInstalledMarker)) {
    Write-Host "Obtaining portable JVM:"
    $jvmURL = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jre-8u20-windows-x64.tar.gz'
    DownloadFromOracleIfNecessary $jvmURL $Tmp 'jre-8u20-windows-x64.tar.gz'
    $target = $CmderDir + '\jvm'
    New-Item $target -type directory -Force
    $tarEXE = $CmderDir + '\vendor\msysgit\bin\tar.exe'
    $tarArgs = @('-C', $target, '-xzf', './tmp/jre-8u20-windows-x64.tar.gz', '--strip-components=1')
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

Function InstallClojure() {
  Write-Host
  $clojureInstalledMarker = $Tmp + '\clojure.marker'
  if (!(Test-Path $clojureInstalledMarker)) {
    Write-Host "Obtaining Clojure:"
    $clojureURL = 'http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.zip'
    $clojureZIP = DownloadFileIfNecessary $clojureURL $Tmp 'clojure-1.6.0.zip'
    $clojureDir = $CmderDir + '\clojure'
    if (ExtractZIPFile ($clojureZIP + '\clojure-1.6.0') $clojureDir) {
      echo $null > $clojureInstalledMarker
      Write-Host "  Clojure extracted into $clojureDir!"
    } else {
      Write-Host "  Clojure extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Clojure already extracted"
  }
}

Function InstallLeiningen() {
  Write-Host
  $leiningenInstalledMarker = $Tmp + '\leiningen.marker'
  if (!(Test-Path $leiningenInstalledMarker)) {
    Write-Host "Obtaining Leiningen:"
    $leinDir = $CygwinDir + '\bin'
    $leinBarDir = $CmderDir + '\bin'
    DownloadFileIfNecessary 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein' $leinDir 'lein'
    DownloadFileIfNecessary 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat' $leinBarDir 'lein.bat'
    echo $null > $leiningenInstalledMarker
    Write-Host "  Leiningen obtained!"
  } else {
    Write-Host "Leiningen already obtained"
  }
}

Function InstallGradle() {
  Write-Host
  $gradleInstalledMarker = $Tmp + '\gradle.marker'
  if (!(Test-Path $gradleInstalledMarker)) {
    Write-Host "Obtaining Gradle:"
    $gradleURL = 'https://services.gradle.org/distributions/gradle-1.11-all.zip'
    $gradleZIP = DownloadFileIfNecessary $gradleURL $Tmp 'gradle-1.11-all.zip'
    $gradleDir = $CmderDir + '\tools'
    if (ExtractZIPFile $gradleZIP $gradleDir) {
      echo $null > $gradleInstalledMarker
      Write-Host "  Gradle extracted into $gradleDir!"
    } else {
      Write-Host "  Gradle extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Gradle already extracted"
  }
}

Function InstallAtom() {
  Write-Host
  $atomInstalledMarker = $Tmp + '\atom.marker'
  if (!(Test-Path $atomInstalledMarker)) {
    Write-Host "Obtaining Atom:"
    $atomURL = 'https://atom.io/download/windows'
    $atomZIP = DownloadWithWgetIfNecessary $atomURL $Tmp 'atom-windows.zip'
    $atomDir = $CygwinDir + '\usr\local\bin\atom'
    if (ExtractZIPFile "$atomZIP\Atom" $atomDir) {
      echo $null > $atomInstalledMarker
      Write-Host "  Atom extracted into $atomDir!"
    } else {
      Write-Host "  Atom extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Atom already extracted"
  }
}

Function InstallLightTable() {
  Write-Host
  $lightTableInstalledMarker = $Tmp + '\lighttable.marker'
  if (!(Test-Path $lightTableInstalledMarker)) {
    Write-Host "Obtaining LightTable:"
    $lightTableURL = 'https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.7/LightTableWin.zip'
    $lightTableZIP = DownloadWithWgetIfNecessary $lightTableURL $Tmp 'LightTableWin.zip'
    $lightTableDir = $CygwinDir + '\usr\local\bin'
    if (ExtractZIPFile $lightTableZIP $lightTableDir) {
      echo $null > $lightTableInstalledMarker
      Write-Host "  LightTable extracted into $LightTableDir!"
    } else {
      Write-Host "  LightTable extraction failed!"
      exit 1
    }
  } else {
    Write-Host "Atom already extracted"
  }
}

Function InstallNightCode() {
  Write-Host
  $nightcodeInstalledMarker = $Tmp + '\nightcode.marker'
  if (!(Test-Path $nightcodeInstalledMarker)) {
    Write-Host "Obtaining NightCode:"
    $leinDir = $CygwinDir + '\usr\local\bin\nightcode'
    DownloadFileIfNecessary 'https://github.com/oakes/Nightcode/releases/download/0.3.10/nightcode-0.3.10-standalone.jar' $leinDir 'nightcode-0.3.10-standalone.jar'
    echo $null > $nightcodeInstalledMarker
    Write-Host "  NightCode obtained!"
  } else {
    Write-Host "NightCode already obtained"
  }
}

Function InstallSublimeText() {
  Write-Host
  $sublimeTextInstalledMarker = $Tmp + '\sublimetext.marker'
  if (!(Test-Path $sublimeTextInstalledMarker)) {
    Write-Host "Obtaining Sublime Text 3:"
    $sublimeTextURL = '"http://c758482.r82.cf2.rackcdn.com/Sublime Text Build 3059 x64.zip"'
    $sublimeTextZIP = DownloadWithWgetIfNecessary $sublimeTextURL $Tmp 'SublimeText3.zip'
    $sublimeTextDir = $CygwinDir + '\usr\local\bin\sublime-text'
    New-Item $sublimeTextDir -type directory -Force
    $overrideSilent = 0x14
    $shell = New-Object -com shell.application
    $zip = $shell.NameSpace($sublimeTextZIP)
    $shell.NameSpace($sublimeTextDir).CopyHere($zip, $overrideSilent)
    echo $null > $sublimeTextInstalledMarker
    Write-Host "  Sublime Text 3 extracted into $sublimeTextDir!"
  } else {
    Write-Host "Sublime Text 3 already extracted"
  }
}

Function InstallGitPrompt() {
  Write-Host
  $gitPromptInstalledMarker = $Tmp + '\gitprompt.marker'
  if (!(Test-Path $gitPromptInstalledMarker)) {
    Write-Host "Obtaining git-prompt.sh:"
    $source = $CmderDir + '\vendor\msysgit\etc\git-prompt.sh'
    $target = $CygwinDir + '\etc'
    Copy-Item $source $target
    if (Test-Path $target) {
      echo $null > $gitPromptInstalledMarker
      Write-Host "  git-prompt.sh installed into $target!"
    } else {
      Write-Host "  git-prompt.sh installation failed!"
      exit 1
    }
  } else {
    Write-Host "git-prompt.sh already installed"
  }
}

Function CreateSymlinks() {
  Write-Host
  $symlinkCreatedMarker = $Tmp + '\symlinks.marker'
  if (!(Test-Path $symlinkCreatedMarker)) {
    Write-Host "Creating symlinks:"
    CreateWindowsSymlink "$CmderDir\tools\atom" "$CygwinDir\usr\local\bin\atom"
    CreateWindowsSymlink "$CmderDir\tools\LightTable" "$CygwinDir\usr\local\bin\LightTable"
    CreateWindowsSymlink "$CmderDir\tools\sublime-text" "$CygwinDir\usr\local\bin\sublime-text"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\atom.exe" "$CygwinDir\usr\local\bin\atom\atom.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\light-table.exe" "$CygwinDir\usr\local\bin\LightTable\LightTable.exe"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\nightcode.jar" "$CygwinDir\usr\local\bin\nightcode\nightcode-0.3.10-standalone.jar"
    CreateCygwinSymlink "$CygwinDir\usr\local\bin\sublime-text.exe" "$CygwinDir\usr\local\bin\sublime-text\sublime-text.exe"
    echo $null > $symlinkCreatedMarker
    Write-Host "  symlinks created!"
  } else {
    Write-Host "Symlinks already created"
  }
}

Function DownloadIcons() {
  Write-Host
  $iconsInstalledMarker = $Tmp + '\icons.marker'
  if (!(Test-Path $iconsInstalledMarker)) {
    Write-Host "Obtaining icons:"
    $iconsDir = $CmderDir + '\icons'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/46956/download/ico' $iconsDir 'cmd.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/47749/download/ico' $iconsDir 'cygwin.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/23880/download/ico' $iconsDir 'far.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/9106/download/ico' $iconsDir 'java.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/8974/download/ico' $iconsDir 'python.ico'
    DownloadFileIfNecessary 'https://www.iconfinder.com/icons/8978/download/ico' $iconsDir 'ruby.ico'
    echo $null > $iconsInstalledMarker
    Write-Host "  icons obtained!"
  } else {
    Write-Host "Icons already obtained"
  }
}

Function InstallSettings() {
  Write-Host
  $settingsInstalledMarker = $Tmp + '\settings.marker'
  if (!(Test-Path $settingsInstalledMarker)) {
    Write-Host "Copying settings:"
    $overrideSilent = 0x14
    $shell = New-Object -com shell.application
    $source = $shell.NameSpace($CurrentDir + '\preconfigs')
    $target = $shell.NameSpace($CurrentDir)
    $target.CopyHere($source.items(), $overrideSilent)
    echo $null > $settingsInstalledMarker
    Write-Host "  settings copied!"
  } else {
    Write-Host "Settings already copied"
  }
}

Function BuildLogic() {
  Write-Host "current dir: $CurrentDir"
  Write-Host "tmp dir: $Tmp"
  Write-Host "target dir: $CmderDir"

  InstallCmder
  InstallCygwin
  InstallAptCyg
  InstallDepotTools
  InstallFar
  InstallFarPlugin
  InstallPortableJVM;
  #TODO Install portable JDK ?
  InstallClojure
  InstallLeiningen
  InstallGradle
  InstallAtom
  InstallLightTable
  InstallNightCode
  InstallSublimeText
  #CreateSymlinks
  DownloadIcons
  InstallGitPrompt
  InstallSettings

  #TODO Create separate script for adding depot-tools to the windows path
  #TODO Create separate script for building and installing boost
  #TODO Create separate script for cleaning and downloading depottools toolchain
}

# Run script
################################################################################

BuildLogic
