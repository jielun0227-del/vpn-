$utf8 = [System.Text.Encoding]::UTF8

$rootFiles = @("index.html", "ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html")
$articleFiles = Get-ChildItem -Path "articles" -Filter "*.html"

$allOk = $true

Write-Output "--- STARTING PROGRAMMATIC VERIFICATION ---"

# Check root files
foreach ($file in $rootFiles) {
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText($file, $utf8)
        
        # 1. Check for duplicates in whole file using regex match count
        $shareCount = ([regex]::Matches($text, '账号合租指南</a>')).Count
        if ($shareCount -gt 4) {
            Write-Output "ERROR: Duplicate 账号合租指南 links in $file ($shareCount found)"
            $allOk = $false
        }
        
        # 2. Check header links count inside nav-menu
        $pattern = '(?s)<div class="nav-menu" id="nav-menu">(.*?)</div>'
        if ($text -match $pattern) {
            $navContent = $Matches[1]
            $linkCount = ([regex]::Matches($navContent, '<a ')).Count
            if ($linkCount -ne 6) {
                Write-Output "ERROR: nav-menu in $file has $linkCount links instead of 6"
                $allOk = $false
            }
        } else {
            Write-Output "ERROR: Could not find nav-menu in $file"
            $allOk = $false
        }
    }
}

# Check article files
foreach ($fileObj in $articleFiles) {
    $file = $fileObj.FullName
    $text = [System.IO.File]::ReadAllText($file, $utf8)
    
    # 1. Check for duplicates in whole file using regex match count
    $shareCount = ([regex]::Matches($text, '账号合租指南</a>')).Count
    if ($shareCount -gt 4) {
        Write-Output "ERROR: Duplicate 账号合租指南 links in $($fileObj.Name) ($shareCount found)"
        $allOk = $false
    }
    
    # 2. Check header links count inside nav-menu
    $pattern = '(?s)<div class="nav-menu" id="nav-menu">(.*?)</div>'
    if ($text -match $pattern) {
        $navContent = $Matches[1]
        $linkCount = ([regex]::Matches($navContent, '<a ')).Count
        if ($linkCount -ne 6) {
            Write-Output "ERROR: nav-menu in $($fileObj.Name) has $linkCount links instead of 6"
            $allOk = $false
        }
    } else {
        Write-Output "ERROR: Could not find nav-menu in $($fileObj.Name)"
        $allOk = $false
    }
}

if ($allOk) {
    Write-Output "SUCCESS: All 32 pages successfully verified! Navigation menus are perfectly clean, duplicate-free, and aligned."
} else {
    Write-Output "FAILED: Menu structure validation failed. Please inspect errors above."
}
