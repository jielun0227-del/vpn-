$utf8 = New-Object System.Text.UTF8Encoding $false
$contentPath = "C:\Users\Lenovo\.gemini\antigravity-ide\brain\86421fc6-24ce-44a8-9f76-eb176dd06968\.system_generated\steps\107\content.md"
if (-not (Test-Path $contentPath)) {
    Write-Output "Content file not found at $contentPath"
    exit
}

$content = [System.IO.File]::ReadAllText($contentPath, $utf8)
$startTag = '<div class="_article_shadowrocket-node-timeout-config-invalid-slow-2026_ external-link-icon-enabled vp-doc plume-content" vp-content data-v-3200f0e0>'
$endTag = '</div><!--]--><footer'

$startIdx = $content.IndexOf($startTag)
if ($startIdx -eq -1) {
    $startIdx = $content.IndexOf('plume-content')
    if ($startIdx -ne -1) {
        $startIdx = $content.LastIndexOf('<div ', $startIdx)
    }
}

if ($startIdx -ne -1) {
    $endIdx = $content.IndexOf($endTag, $startIdx)
    if ($endIdx -eq -1) {
        $endIdx = $content.IndexOf('</main>', $startIdx)
    }
    if ($endIdx -ne -1) {
        $len = $endIdx - $startIdx
        $articleHtml = $content.Substring($startIdx, $len)
        $articleHtml = $articleHtml.Replace('</p>', "</p>`r`n").Replace('</h2>', "</h2>`r`n").Replace('</h3>', "</h3>`r`n").Replace('</ul>', "</ul>`r`n").Replace('</ol>', "</ol>`r`n").Replace('</li>', "</li>`r`n").Replace('<blockquote>', "<blockquote>`r`n").Replace('</blockquote>', "</blockquote>`r`n")
        
        $currentDir = (Get-Location).Path
        $outPath = Join-Path $currentDir "scratch/extracted_article.html"
        [System.IO.File]::WriteAllText($outPath, $articleHtml, $utf8)
        Write-Output "Successfully extracted article content to scratch/extracted_article.html"
    } else {
        Write-Output "Could not find end tag."
    }
} else {
    Write-Output "Could not find start tag."
}
