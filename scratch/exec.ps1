$p = Get-Command python -ErrorAction SilentlyContinue
if ($p) {
    & $p.Path "scratch/run_py_fixes.py"
} else {
    # Fallback try py
    & py "scratch/run_py_fixes.py"
}
