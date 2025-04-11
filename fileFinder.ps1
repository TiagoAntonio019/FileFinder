param (
    [parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ })]
    [string]$directory,

    [string]$outputFile
)

$now = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$outputFile = Join-Path -Path $outputFile -ChildPath "finderResult-$now.csv"

$job = Start-Job -ScriptBlock {
    param($dir)
    Get-ChildItem -Path $dir -Recurse -File | Where-Object {
        $_.Name -match '\(\s*\d+\s*\)'
    }
} -ArgumentList $directory

$spinner = @('|','/','-','\')
$i = 0

while ($job.State -eq 'Running') {
    Write-Host -NoNewline "`r[$($spinner[$i % $spinner.Length])] Working hard..."
    Start-Sleep -Milliseconds 150
    $i++
}

$arrayoffiles = Receive-Job $job
Remove-Job $job

$arrayoffiles | Select-Object FullName, Length, LastWriteTime |
    Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
Write-Host "`n`nDone, the output has been saved in: $outputFile`n`n" -ForegroundColor Green

$Delete = Read-Host "Would you like to delete the files? [Y] or anything else to skip"

if ($Delete -eq 'Y') {
    $arrayoffiles | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force -ErrorAction Stop
            Write-Host "Deleted: $($_.FullName)" -ForegroundColor Green
        } catch {
            Write-Host "Failed to delete: $($_.FullName)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Files not deleted." -ForegroundColor Yellow
}

Write-Host "All clean" -ForegroundColor Green
