# IndexNow Submission Script for yzrztop.com
$hostName = "yzrztop.com"
$apiKey = "bce435ce6d5142468ee56bab85397bcd"
$keyLocation = "https://yzrztop.com/bce435ce6d5142468ee56bab85397bcd.txt"
$sitemapPath = "$PSScriptRoot\sitemap.xml"

if (-not (Test-Path $sitemapPath)) {
    Write-Host "Error: sitemap.xml not found at $sitemapPath" -ForegroundColor Red
    exit 1
}

[xml]$xmlContent = Get-Content $sitemapPath -Encoding UTF8
$urls = @($xmlContent.urlset.url.loc)

Write-Host "Found $($urls.Count) URLs in sitemap.xml" -ForegroundColor Green

$payload = @{
    host        = $hostName
    key         = $apiKey
    keyLocation = $keyLocation
    urlList     = $urls
} | ConvertTo-Json -Depth 5

$endpoints = @(
    "https://api.indexnow.org/indexnow",
    "https://www.bing.com/indexnow"
)

foreach ($endpoint in $endpoints) {
    Write-Host "Submitting to $endpoint ..." -NoNewline
    try {
        $response = Invoke-WebRequest -Uri $endpoint -Method Post -ContentType "application/json; charset=utf-8" -Body ([System.Text.Encoding]::UTF8.GetBytes($payload)) -UseBasicParsing
        Write-Host " Success (HTTP $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host " Failed: $_" -ForegroundColor Red
    }
}
