for ($i=1; $i -le 10; $i++) {
  Write-Host "Attempting to run filebeat"
  $process = Start-Process -FilePath filebeat.exe -Wait -PassThru -ArgumentList $args
  if ($process.ExitCode -eq 0) { break }
  Start-Sleep 10
}
exit $process.ExitCode
