# Quick Start Commands for BrowserSync NFT Setup

## 1. Start BrowserSync with UniSat proxy
```bash
# Option A: Using config file
npx browser-sync start --config bs-config.js

# Option B: Direct command (if config has issues)
npx browser-sync start --proxy "https://unisat.io" --host "192.168.254.146" --no-open --no-notify
```

## 2. Test with 2 Chrome profiles first
```batch
# Open command prompt and run:
launch-chrome-test.bat
```

## 3. Create all 215 profile directories
```powershell
# Open PowerShell and run:
.\create-profiles.ps1
```

## 4. Launch profiles in batches for testing
```powershell
# Test with 10 profiles
.\launch-chrome-batch.ps1 -TotalProfiles 10

# Test with 25 profiles
.\launch-chrome-batch.ps1 -TotalProfiles 25 -BatchSize 5

# Test with 50 profiles
.\launch-chrome-batch.ps1 -TotalProfiles 50 -BatchSize 10

# Full 215 profiles
.\launch-chrome-batch.ps1 -TotalProfiles 215 -BatchSize 20
```

## 5. Monitor system resources
```powershell
# In a separate PowerShell window:
.\monitor-resources.ps1
```

## 6. Emergency shutdown all Chrome
```powershell
# If needed to close all Chrome instances:
Get-Process chrome | Stop-Process -Force
```

## File Summary:
- `bs-config.js` - BrowserSync configuration
- `create-profiles.ps1` - Creates 215 profile directories
- `launch-chrome-test.bat` - Simple launcher for 2 profiles
- `launch-chrome-batch.ps1` - Advanced batch launcher with delays
- `monitor-resources.ps1` - Real-time resource monitoring

## URLs to remember:
- BrowserSync UI: http://localhost:3001
- Proxied UniSat: http://localhost:3000
- Target page: http://localhost:3000/market/brc20?tick=ligo
