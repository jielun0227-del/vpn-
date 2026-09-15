$files = Get-ChildItem -Path "c:\Users\Lenovo\Desktop\椰汁博客" -Filter "*.html" -Recurse

$file = $files[0]
$content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

foreach ($line in $content.Split("`n")) {
    if ($line.Contains("articles.html")) {
        Write-Host "Line found in $($file.Name): $line"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($line)
        $hex = [System.BitConverter]::ToString($bytes)
        Write-Host "Hex: $hex"
    }
}
