# monitor-resources.ps1 - Monitor system resources during testing
param(
    [int]$RefreshInterval = 2
)

Write-Host "Chrome Resource Monitor" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

while ($true) {
    Clear-Host
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "=== Chrome Resource Monitor ===" -ForegroundColor Green
    Write-Host "Time: $timestamp" -ForegroundColor Cyan
    Write-Host ""
    
    # Get Chrome processes
    $chromeProcesses = Get-Process chrome -ErrorAction SilentlyContinue
    
    if ($chromeProcesses) {
        $processCount = $chromeProcesses.Count
        $totalMemoryMB = ($chromeProcesses | Measure-Object WorkingSet -Sum).Sum / 1MB
        $totalMemoryGB = $totalMemoryMB / 1024
        
        Write-Host "Chrome Processes: $processCount" -ForegroundColor White
        Write-Host ("Total Memory: {0:N2} GB ({1:N0} MB)" -f $totalMemoryGB, $totalMemoryMB) -ForegroundColor White
        Write-Host ("Avg per Process: {0:N0} MB" -f ($totalMemoryMB / $processCount)) -ForegroundColor White
    } else {
        Write-Host "No Chrome processes found" -ForegroundColor Red
    }
    
    # System stats
    Write-Host ""
    Write-Host "=== System Resources ===" -ForegroundColor Green
    
    # CPU Usage
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue).CounterSamples.CookedValue
    Write-Host ("CPU Usage: {0:N1}%" -f $cpu) -ForegroundColor White
    
    # Memory
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = $os.TotalVisibleMemorySize / 1MB
    $freeRAM = $os.FreePhysicalMemory / 1MB
    $usedRAM = $totalRAM - $freeRAM
    $usedPercent = ($usedRAM / $totalRAM) * 100
    
    Write-Host ("RAM Usage: {0:N1}% ({1:N1} / {2:N1} GB)" -f $usedPercent, ($usedRAM/1024), ($totalRAM/1024)) -ForegroundColor White
    
    # BrowserSync check
    Write-Host ""
    Write-Host "=== BrowserSync Status ===" -ForegroundColor Green
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3001" -UseBasicParsing -TimeoutSec 2
        Write-Host "BrowserSync UI: ONLINE" -ForegroundColor Green
    } catch {
        Write-Host "BrowserSync UI: OFFLINE" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds $RefreshInterval
}

# Save as: monitor-resources.ps1
# Run with: .\monitor-resources.ps1