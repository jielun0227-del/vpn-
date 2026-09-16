@echo off
"C:\Program Files\Git\cmd\git.exe" push -u origin main
powershell -ExecutionPolicy Bypass -File .\submit_indexnow.ps1
pause

