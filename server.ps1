# 椰汁博客 本地 PowerShell 静态服务器 (超安全自适应版)
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Listening on http://localhost:8080/..."

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # 安全地获取请求的 URL 路径，防御 Null 引用
        $url = "/index.html"
        if ($request -ne $null -and $request.Url -ne $null -and $request.Url.LocalPath -ne $null) {
            $url = $request.Url.LocalPath
        }
        
        Write-Host "--- REQUEST: $url"
        
        if ($url -eq "/" -or $url -eq "") {
            $url = "/index.html"
        }
        
        # 清理路径，防止路径穿越和格式错误
        $cleanUrl = $url.Replace("..", "")
        $cleanUrl = $cleanUrl.Trim("/")
        $cleanUrl = $cleanUrl.Replace("/", "\")
        
        # 稳健的基础路径获取，优先使用 $PSScriptRoot，若为空则退回本地目录
        $basePath = $PSScriptRoot
        if ($basePath -eq $null -or $basePath -eq "") {
            $basePath = "."
        }
        
        $localPath = Join-Path $basePath $cleanUrl
        Write-Host "RESOLVED PATH: $localPath"
        
        $exists = $false
        if ($cleanUrl -ne "" -and $localPath -ne $null) {
            $exists = Test-Path $localPath -PathType Leaf
        }
        Write-Host "EXISTS: $exists"
        
        if ($exists) {
            try {
                $content = [System.IO.File]::ReadAllBytes($localPath)
                
                # 判断 Mime Type
                $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
                $contentType = "text/plain"
                if ($ext -eq ".html" -or $ext -eq ".htm") { $contentType = "text/html; charset=utf-8" }
                elseif ($ext -eq ".css") { $contentType = "text/css; charset=utf-8" }
                elseif ($ext -eq ".js") { $contentType = "application/javascript; charset=utf-8" }
                elseif ($ext -eq ".png") { $contentType = "image/png" }
                elseif ($ext -eq ".jpg" -or $ext -eq ".jpeg") { $contentType = "image/jpeg" }
                elseif ($ext -eq ".svg") { $contentType = "image/svg+xml" }
                
                $response.ContentType = $contentType
                $response.ContentLength64 = $content.Length
                $response.OutputStream.Write($content, 0, $content.Length)
                Write-Host "RESPONSE: 200 OK ($contentType)"
            } catch {
                Write-Host "ERROR SENDING FILE: $_"
                $response.StatusCode = 500
            }
        } else {
            $response.StatusCode = 404
            $buf = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.ContentType = "text/plain; charset=utf-8"
            $response.ContentLength64 = $buf.Length
            $response.OutputStream.Write($buf, 0, $buf.Length)
            Write-Host "RESPONSE: 404 Not Found"
        }
        
        try {
            $response.OutputStream.Close()
        } catch {
            Write-Host "ERROR CLOSING CONNECTION: $_"
        }
    }
} finally {
    $listener.Stop()
}
