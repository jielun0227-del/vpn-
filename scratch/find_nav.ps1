$utf8 = [System.Text.Encoding]::UTF8
$text = [System.IO.File]::ReadAllText("articles.html", $utf8)
$lines = $text.Split("`n")
for ($i=0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains("nav-menu") -or $line.Contains("nav-container")) {
        $num = $i + 1
        $trim = $line.Trim()
        Write-Output "$($num) : $trim"
    }
}
