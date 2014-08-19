Import-Module BitsTransfer

# Helper functions
###############################################################################

Function DownloadFileIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + '\' + $targetName;
  if (!(Test-Path $target)) {
    $webclient = New-Object System.Net.WebClient;
    if (!(Test-Path $targetDir)) {
      New-Item $targetDir -type directory -Force;
    }
	Write-Host "	Downloading $source into $target...";
    $webclient.DownloadFile($source, $target);
  }
  EnsureFileDownloaded $source $target;
  return $target;
}

Function EnsureFileDownloaded($source, $target) {
  if (!(Test-Path $target)) {
    Write-Host "	Failed to download $source";
    exit 1;
  }
}

Function ExtractZIPFile($file, $target) {
  Write-Host "	Extracting $file into $target...";
  $shell = New-Object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items()) {
    $shell.NameSpace($target).CopyHere($item)
  }
  return 1;
}

# Build logic
################################################################################

$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp = $CurrentDir + '\tmp'
$CmderDir = $CurrentDir + '\cmder'
$CygwinDir = $CmderDir + '\cygwin'

Function InstallCmder() {
  $cmderInstalledMarker = $Tmp + '\cmder.marker'
  if (!(Test-Path $cmderInstalledMarker)) {
    Write-Host "Obtaining cmder:";
    $cmderURL = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip';
    $cmderZIP = DownloadFileIfNecessary $cmderURL $Tmp 'cmder.zip';
	if (ExtractZIPFile $cmderZIP $CurrentDir) {
	  echo $null > $cmderInstalledMarker
	  Write-Host "cmder extracted";
	} else {
	  Write-Host "cmder extraction failed!";
	  exit 1
	}
  } else {
    Write-Host "cmder already extracted";
  }
}

Function InstallCygwin() {
  $cygwinInstalledMarker = $Tmp + '\cygwin.marker'
  if (!(Test-Path $cygwinInstalledMarker)) {
    Write-Host "Obtaining Cygwin:";
    $cygwinURL = 'https://cygwin.com/setup-x86_64.exe';
    $cygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp 'setup-x86_64.exe';
    $cygwinArgs = @(
        '--no-admin', '--upgrade-also', '--no-desktop', '--no-startmenu',
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
    Write-Host '	Running Cygwin setup...'
    $cygwinInstallation = Start-Process -FilePath $cygwinEXE -ArgumentList $cygwinArgs -NoNewWindow -Wait
	if ($cygwinInstallation.ExitCode -eq 0) {
	  echo $null > $cygwinInstalledMarker
	  Write-Host "Cygwin installed into $CygwinDir";
	} else {
	  Write-Host 'Cygwin installation failed!';
	  exit 1
	}
  } else {
    Write-Host "Cygwin already installed";
  }
}

Function BuildLogic() {
  Write-Host "current dir: $CurrentDir"
  Write-Host "tmp dir: $Tmp"
  Write-Host "target dir: $CmderDir"
  InstallCmder;
  InstallCygwin;
}

# Run script
################################################################################

BuildLogic;
