# update_friendly_links_and_check.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$rootDir = Split-Path -Parent $PSScriptRoot
Write-Host "Workspace Root Directory: $rootDir"

# 5. Verification Check on active HTML files (excluding scratch directory)
$errors = @()

$allHtmlFiles = Get-ChildItem -Path $rootDir -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch '\\scratch\\' }

foreach ($htmlFile in $allHtmlFiles) {
    $fileContent = [System.IO.File]::ReadAllText($htmlFile.FullName, [System.Text.Encoding]::UTF8)
    $relPath = $htmlFile.FullName.Substring($rootDir.Length + 1)
    
    # Check for leftover #friendly-links
    if ($fileContent -match '#friendly-links') {
        $errors += "[$relPath] Contains leftover '#friendly-links' anchor"
    }
    
    # Extract href links (excluding http, https, mailto, javascript, #, and JS template string ${...})
    $matches = [regex]::Matches($fileContent, 'href=["''](?<url>[^"'']+)["'']')
    foreach ($m in $matches) {
        $url = $m.Groups['url'].Value
        if ($url -match '^(http|https|mailto|javascript|#|\$\{)') {
            continue
        }
        
        # Split anchor if present
        $urlNoAnchor = $url.Split('#')[0]
        if ([string]::IsNullOrWhiteSpace($urlNoAnchor)) {
            continue
        }
        
        # Calculate target absolute path
        $dir = $htmlFile.DirectoryName
        $targetPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($dir, $urlNoAnchor))
        
        if (-not (Test-Path $targetPath)) {
            $errors += "[$relPath] Broken link to '$url' (Target not found: $targetPath)"
        }
    }

    # Extract src links (excluding http, https, data:, and JS template strings)
    $srcMatches = [regex]::Matches($fileContent, 'src=["''](?<url>[^"'']+)["'']')
    foreach ($m in $srcMatches) {
        $url = $m.Groups['url'].Value
        if ($url -match '^(http|https|data:|\$\{)') {
            continue
        }
        $urlNoAnchor = $url.Split('#')[0]
        if ([string]::IsNullOrWhiteSpace($urlNoAnchor)) {
            continue
        }
        $dir = $htmlFile.DirectoryName
        $targetPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($dir, $urlNoAnchor))
        if (-not (Test-Path $targetPath)) {
            $errors += "[$relPath] Broken src asset to '$url' (File not found: $targetPath)"
        }
    }
}

if ($errors.Count -eq 0) {
    Write-Host "`n✅ PERFECT SUCCESS: All active site HTML files checked! ZERO BROKEN LINKS & ZERO LEFTOVER ANCHORS FOUND!" -ForegroundColor Green
} else {
    Write-Host "`n❌ ERRORS FOUND:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
}
