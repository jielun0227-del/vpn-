# Run python script apply_seo_fixes.py
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py) {
    & python scratch/apply_seo_fixes.py
} else {
    Write-Host "Python not found in path, running PowerShell update script..."
}
