Import-Module BitsTransfer

# Helper functions
################################################################################

Function DownloadFileIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + '\' + $targetName;
  if (!(Test-Path $target)) {
    $webclient = New-Object System.Net.WebClient;
    if (!(Test-Path $targetDir)) {
      New-Item $targetDir -type directory -Force;
    }
    Write-Host "  downloading $source into $target...";
    $webclient.DownloadFile($source, $target);
  }
  EnsureFileDownloaded $source $target;
  return $target;
}

Function EnsureFileDownloaded($source, $target) {
  if (!(Test-Path $target)) {
    Write-Host "  failed to download $source";
    exit 1;
  } else {
    Write-Host "  $source downloaded successfully";
  }
}

Function ExtractZIPFile($file, $target) {
  Write-Host "  Extracting $file into $target...";
  $shell = New-Object -com shell.application
  $zip = $shell.NameSpace($file)
  $overrideSilent = 0x14
  $shell.NameSpace($target).CopyHere($zip.items(), $overrideSilent)
  return 1;
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
    Write-Host "Obtaining Cmder:";
    $cmderURL = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip';
    $cmderZIP = DownloadFileIfNecessary $cmderURL $Tmp 'cmder.zip';
    New-Item $CmderDir -type directory -Force;
    if (ExtractZIPFile $cmderZIP $CurrentDir) {
      echo $null > $cmderInstalledMarker
      Write-Host "  Cmder extracted into $CmderDir!";
    } else {
      Write-Host "  Cmder extraction failed!";
      exit 1
    }
  } else {
    Write-Host "Cmder already extracted";
  }
}

Function InstallCygwin() {
  Write-Host
  $cygwinInstalledMarker = $Tmp + '\cygwin.marker'
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host "Obtaining Cygwin:";
    $cygwinURL = 'https://cygwin.com/setup-x86_64.exe';
    $cygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp 'setup-x86_64.exe';
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
      Write-Host "  Cygwin installed into $CygwinDir!";
    } else {
      Write-Host '  Cygwin installation failed!';
      Write-Host $cygwinInstallation.ExitCode
      Write-Host $cygwinInstallation.ExitCode
      exit $cygwinInstallation.ExitCode
    }
  } else {
    Write-Host "Cygwin already installed";
  }
  $env:Path = $env:Path + ';' + $CygwinDir + '\bin'
}

Function InstallAptCyg() {
  Write-Host
  $aptCygInstalledMarker = $Tmp + '\aptcyg.marker'
  if (!(Test-Path $aptCygInstalledMarker)) {
    Write-Host "Obtaining apt-cyg:";
    $aptCygURL = "https://apt-cyg.googlecode.com/svn/trunk/apt-cyg"
    $aptCygDir = $cygwinDir + '\bin'
    $aptCygFile = DownloadFileIfNecessary $aptCygURL $aptCygDir 'apt-cyg';
    if (Test-Path $aptCygFile) {
      echo $null > $aptCygInstalledMarker
      Write-Host "  apt-cyg installed into $aptCygDir!";
    } else {
      Write-Host '  apt-cyg installation failed!';
      exit 1;
    }
  } else {
    Write-Host "apt-cyg already installed";
  }
}

Function InstallDepotTools() {
  Write-Host
  $depotToolsInstalledMarker = $Tmp + '\depottools.marker'
  $depotToolsDir = $CygwinDir + '\opt\depot_tools'
  if (!(Test-Path $depotToolsInstalledMarker)) {
    Write-Host "Obtaining depot-tools:";
    $gitEXE = 'git'
    $gitArgs = @(
        'clone'
        'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
        $depotToolsDir)
    $depotToolsInstallation = Start-Process -FilePath $gitEXE -ArgumentList $gitArgs -PassThru -NoNewWindow -Wait
    if ($depotToolsInstallation.ExitCode -eq 0) {
      echo $null > $depotToolsInstalledMarker
      Write-Host "  depottools installed into $depotToolsDir!";
    } else {
      Write-Host '  depottools installation failed!';
      exit 1;
    }
  } else {
    Write-Host "depottools already installed";
  }
}

Function InstallFar() {
  Write-Host
  $farInstalledMarker = $Tmp + '\far.marker'
  if (!(Test-Path $farInstalledMarker)) {
    Write-Host "Obtaining Far:";
    $farURL = 'http://www.farmanager.com/files/Far30b4040.x64.20140810.7z';
    DownloadFileIfNecessary $farURL $Tmp 'Far30b4040.x64.20140810.7z';
    $far7Z = 'tmp/Far30b4040.x64.20140810.7z'
    $farDir = 'cmder/far';
    $7zaEXE = $CygwinDir + '\lib\p7zip\7za.exe';
    $7zaArgs = @('x', $far7Z, "-o$farDir", '-y')
    New-Item $farDir -type directory -Force;
    $farInstallation = Start-Process -FilePath $7zaEXE -ArgumentList $7zaArgs -PassThru -NoNewWindow -Wait -WorkingDirectory '.'
    if ($farInstallation.ExitCode -eq 0) {
      echo $null > $farInstalledMarker
      Write-Host "  Far extracted into $farDir!";
    } else {
      Write-Host "  Far extraction failed!";
      exit 1
    }
  } else {
    Write-Host "Far already extracted";
  }
}

Function BuildLogic() {
  Write-Host "current dir: $CurrentDir"
  Write-Host "tmp dir: $Tmp"
  Write-Host "target dir: $CmderDir"

  InstallCmder;
  InstallCygwin;
  InstallAptCyg;
  InstallDepotTools;
  InstallFar;
  #TODO Install far manager plugin for conemu
  #TODO Install portable JVM
  #TODO Install portable JDK ?
  #TODO Install Clojure
  #TODO Install lein and lein.bat
  #TODO Install gradle-1.11
  #TODO Install atom
  #TODO Install lighttable
  #TODO Install nightcore
  #TODO Install sublime text portable
  #TODO Create symlinks to applications
  #TODO Install git-prompt
  #TODO Install settings

  #TODO Create separate script for adding depot-tools to the windows path
  #TODO Create separate script for building and installing boost
  #TODO Create separate script for cleaning and downloading depottools toolchain
}

# Run script
################################################################################

BuildLogic;
