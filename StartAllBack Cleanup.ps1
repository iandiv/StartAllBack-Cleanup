Write-Output  ''
Write-Output  'StartAllBack CleanUp by iandiv'
Write-Output  'This script will clean up the registry keys'
Write-Output  ''
Write-Output  'CAUTION!! Use this scripts at your own risk. '
Write-Output  'I am not responsible for any damage that may occur as a result of running this script.'
Write-Output  ''
Write-Output 'Do you want to begin?'
$x = Read-Host '[Y/N]'
if (-Not($x -eq "Y" -or ($x -eq "y"))) {
    Write-Output  'cancelled by user!'
    exit
}
Write-Output  ''

$keys = Get-Item -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\* | Select-Object -ExpandProperty Name
$keys = $keys | Where-Object { $_ -cmatch '\{[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{8}.*$' }

foreach ($key in $keys) {
    # Write-Output  ('key found:' + $key)

    #look for subkeys
    $subkeys = Get-Item -Path ('Registry::' + $key + "\*") | Select-Object -ExpandProperty Name
    $subkeys_count = $subkeys | Measure-Object | Select-Object -ExpandProperty Count
    if (-Not ($subkeys_count -eq 0)) {
        continue
    }

    Write-Output  '' 
    Write-Output  ('Cleaning..:')
    Write-Output  '' 
    Remove-Item -Path ('Registry::' + $key)
    
    
}

Write-Output  ('Cleaned Successfully!')
Write-Output  '' 
Write-Output  'Restarting explorer...'
stop-process -name explorer –force
Write-Output  '' 
Write-Output  'All DONE' 
Write-Output  '' 
Write-Host "Press any key to Exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('%{F4}')
