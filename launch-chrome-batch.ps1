# launch-chrome-batch.ps1 - Launch Chrome profiles in batches for load testing
param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [string]$ProfileBase = "C:\ChromeProfiles",
    [string]$Url = "http://localhost:3000/market/brc20?tick=ligo",
    [int]$TotalProfiles = 10,
    [int]$BatchSize = 5,
    [int]$BatchDelaySeconds = 5,
    [int]$StartProfile = 1
)

Write-Host "Chrome Batch Launcher for Load Testing" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Total Profiles: $TotalProfiles" -ForegroundColor Cyan
Write-Host "Batch Size: $BatchSize" -ForegroundColor Cyan
Write-Host "Delay Between Batches: $BatchDelaySeconds seconds" -ForegroundColor Cyan
Write-Host "Starting from: Profile$StartProfile" -ForegroundColor Cyan
Write-Host "URL: $Url" -ForegroundColor Yellow
Write-Host ""

# Verify Chrome exists
if (!(Test-Path $ChromePath)) {
    Write-Error "Chrome not found at: $ChromePath"
    exit 1
}

$launched = 0
$currentBatch = 1
$totalBatches = [Math]::Ceiling($TotalProfiles / $BatchSize)

for ($i = $StartProfile; $i -lt ($StartProfile + $TotalProfiles); $i++) {
    $profileDir = Join-Path $ProfileBase "Profile$i"
    
    # Check if profile directory exists
    if (!(Test-Path $profileDir)) {
        Write-Warning "Profile$i directory not found, creating..."
        New-Item -ItemType Directory -Path $profileDir | Out-Null
    }
    
    # Chrome arguments
    $args = @(
        "--user-data-dir=`"$profileDir`"",
        "--no-first-run",
        "--no-default-browser-check",
        "--disable-popup-blocking",
        "--disable-translate",
        "`"$Url`""
    )
    
    # Launch Chrome
    Write-Host "Launching Profile$i..." -NoNewline
    try {
        Start-Process -FilePath $ChromePath -ArgumentList $args
        $launched++
        Write-Host " OK" -ForegroundColor Green
    } catch {
        Write-Host " FAILED" -ForegroundColor Red
        Write-Error $_.Exception.Message
    }
    
    # Check if we need to pause between batches
    if ($launched % $BatchSize -eq 0 -and $launched -lt $TotalProfiles) {
        Write-Host ""
        Write-Host "Batch $currentBatch/$totalBatches complete. Waiting $BatchDelaySeconds seconds..." -ForegroundColor Yellow
        
        # Show countdown
        for ($j = $BatchDelaySeconds; $j -gt 0; $j--) {
            Write-Host "`rNext batch in $j seconds..." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 1
        }
        Write-Host "`r                                    `r" -NoNewline
        
        $currentBatch++
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Successfully launched $launched profiles!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Check BrowserSync UI: http://localhost:3001" -ForegroundColor White
Write-Host "2. Verify all profiles connected" -ForegroundColor White
Write-Host "3. Test click/input synchronization" -ForegroundColor White
Write-Host "4. Monitor resources with: .\monitor-resources.ps1" -ForegroundColor White

# Save as: launch-chrome-batch.ps1
# Examples:
# .\launch-chrome-batch.ps1 -TotalProfiles 10
# .\launch-chrome-batch.ps1 -TotalProfiles 50 -BatchSize 10 -BatchDelaySeconds 3
# .\launch-chrome-batch.ps1 -TotalProfiles 215 -BatchSize 20 -StartProfile 1