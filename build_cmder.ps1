Import-Module BitsTransfer

# Helper functions
###############################################################################

Function DownloadFileIfNecessary($source, $targetDir, $targetName) {
  $target = $targetDir + $targetName;
  if (!(Test-Path $target)) {
    Write-Host "Downloading $source";
    $webclient = New-Object System.Net.WebClient;
    if (!(Test-Path $targetDir)) {
      New-Item $targetDir -type directory -Force;
    }
	Write-Host "Writing to $target...";
    $webclient.DownloadFile($source, $target);
  }
  EnsureFileDownloaded $source $target;
  return $target;
}

Function EnsureFileDownloaded($source, $target) {
  if (!(Test-Path $target)) {
    Write-Host "Failed to download $source";
    exit 1;
  }
}

# Build logic
################################################################################

$Tmp = 'F:\tmp\'

Function InstallCmder() {
  $cmderURL = 'https://github.com/bliker/cmder/releases/download/v1.1.3/cmder.zip';
  $cmderZIP = DownloadFileIfNecessary $cmderURL $Tmp 'cmder.zip';
}

Function BuildLogic() {
  InstallCmder;
}

# Run script
################################################################################

BuildLogic;
