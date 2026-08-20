# IndexNow Automated Submission Script for Yeju Blog
# Key File: bce435ce6d5142468ee56bab85397bcd.txt
# Key: bce435ce6d5142468ee56bab85397bcd

$hostName = "yzrztop.com"
$apiKey = "bce435ce6d5142468ee56bab85397bcd"
$keyLocation = "https://yzrztop.com/bce435ce6d5142468ee56bab85397bcd.txt"

# Parse sitemap.xml for URLs
[xml]$sitemap = Get-Content "sitemap.xml"
$urlList = @()

foreach ($url in $sitemap.urlset.url) {
    $urlList += $url.loc
}

Write-Host "Found $($urlList.Count) URLs to submit to IndexNow API." -ForegroundColor Cyan

$payload = @{
    host = $hostName
    key = $apiKey
    keyLocation = $keyLocation
    urlList = $urlList
} | ConvertTo-Json -Depth 5

$endpoints = @(
    "https://api.indexnow.org/indexnow",
    "https://www.bing.com/indexnow"
)

foreach ($endpoint in $endpoints) {
    try {
        Write-Host "Submitting to $endpoint..." -NoNewline
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Body $payload -ContentType "application/json; charset=utf-8"
        Write-Host " [SUCCESS 200/202]" -ForegroundColor Green
    } catch {
        Write-Host " [Failed: $($_.Exception.Message)]" -ForegroundColor Yellow
    }
}

Write-Host "IndexNow submission process finished." -ForegroundColor Cyan
