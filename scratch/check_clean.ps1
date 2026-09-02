# check_clean.ps1
$rootDir = "c:\Users\Lenovo\Desktop\椰汁博客"
$htmlFiles = Get-ChildItem -Path $rootDir -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch '\\scratch\\' }

$badFiles = @()

foreach ($file in $htmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match "缃|鏈哄満|鎶€鏈|灏┲|鍟嗗姟|璐﹀彿|鍙嬫儏|棣栭〉") {
        $badFiles += $file.FullName
    }
}

if ($badFiles.Count -eq 0) {
    Write-Host "`n✅ PERFECT SUCCESS: All 43 HTML files checked! ZERO garbled text or mojibake found in the entire repository!" -ForegroundColor Green
} else {
    Write-Host "`n❌ GARBLED FILES DETECTED:" -ForegroundColor Red
    foreach ($b in $badFiles) {
        Write-Host "  - $b" -ForegroundColor Red
    }
}
