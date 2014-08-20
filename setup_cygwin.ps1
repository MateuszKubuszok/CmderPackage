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

# Config
################################################################################

$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$Tmp = $CurrentDir + '\tmp'
$CmderDir = $CurrentDir + '\cmder'
$CygwinDir = $CmderDir + '\cygwin'

# Run cygwin setup if needed
################################################################################

Function SetupCygwin() {
  $cygwinURL = 'https://cygwin.com/setup-x86_64.exe';
  $cygwinEXE = DownloadFileIfNecessary $cygwinURL $Tmp 'setup-x86_64.exe';
  $cygwinArgs = @(
    '--no-admin', '--upgrade-also', '--package-manager',
    '--no-desktop', '--no-startmenu', '--no-shortcuts',
    # Directories `
    '--root', $CygwinDir,
    '--local-package-dir', $Tmp,
    # Sources `
    '--site', 'ftp://mirrors.kernel.org/sourceware/cygwin',
    '--site', 'ftp://ftp.cygwinports.org/pub/cygwinports',
    '--pubkey', 'http://cygwinports.org/ports.gpg')
  Start-Process -FilePath $cygwinEXE -ArgumentList $cygwinArgs -NoNewWindow -Wait
}

# Run script
################################################################################

SetupCygwin;
