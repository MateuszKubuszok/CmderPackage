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

Function BuildLogic() {
  Write-Host "current dir: $CurrentDir"
  Write-Host "tmp dir: $Tmp"
  Write-Host "target dir: $CmderDir"
  InstallCmder;
}

# Run script
################################################################################

BuildLogic;
