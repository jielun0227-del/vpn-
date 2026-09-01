$utf8 = [System.Text.Encoding]::UTF8

function Fix-File([string]$relPathB64, [string]$descB64) {
    $relPath = $utf8.GetString([System.Convert]::FromBase64String($relPathB64))
    $desc = $utf8.GetString([System.Convert]::FromBase64String($descB64))
    
    $fullPath = Join-Path "c:\Users\Lenovo\Desktop\椰汁博客" $relPath
    if (Test-Path $fullPath) {
        $text = [System.IO.File]::ReadAllText($fullPath, $utf8)
        $len = $desc.Length
        Write-Host "Updating $relPath ($len chars)..."
        
        $text = [regex]::Replace($text, '(?i)<meta\s+name="description"\s+content="[^"]*"', "<meta name=""description"" content=""$desc"">")
        $text = [regex]::Replace($text, '(?i)<meta\s+property="og:description"\s+content="[^"]*"', "<meta property=""og:description"" content=""$desc"">")
        $text = [regex]::Replace($text, '(?i)<meta\s+name="twitter:description"\s+content="[^"]*"', "<meta name=""twitter:description"" content=""$desc"">")
        
        [System.IO.File]::WriteAllText($fullPath, $text, $utf8)
    } else {
        Write-Host "File not found: $fullPath"
    }
}

# 9 Bing Webmaster Tools Reported Files (Base64 Encoded to bypass Windows ANSI/GBK shell issues)

# 1. articles/jilianyun-review.html
Fix-File "YXJ0aWNsZXMvamlsaWFueXVuLXJldmlldy5odG1s" "5p6B6L6e5LqR5py65Zy6MjAyNuW5tOacieaWsDog5q6o5a6e5rWL5LiO6YCJ6LSt6Ziy5Z2R5oyH5Y2X44CC5L+d5LqO5YWo5LyB5Lia57qnIElQTEMg5Zu96ZmZ5Lgb57qF5Lyg6L6T5p625p6E77yM5YWo6Z2i5a6e5rWL5p6B6L6e5LqR5Zyo5pma6auY5bOw57mB5pe25q6155qE55yf5a6e5Los5YyF546H44CBMEs4gLaou5jnuLnmgKZn6YCm5biD44CB5Y6f55Sf5L2P5a6F IFAg5o6l6buZ6Kej6ZSI5Lul5Y+K5YWo5a6i5oi356uv5Yij5a656KGo546w77yM5Li65oKo5o+D5L6b6Kiv5bC955qE6LWE6LS55aWX6aSQ5aKe5Lih44CB5L2F55So5L2T6aqM57uT6K665LiO5LyY5oOg5oqY5omj77yM5Yqp5oKo5o6l6YCJ5p6B6Ie056iz5a6a5LiN6LeR6Lev55qE6auY5ZOB6LSo5Li75Yqb572R57uc5Yqg6YCf6o6l6buZ44CC"

# 2. articles/shanhai-review.html
Fix-File "YXJ0aWNsZXMvc2hhbmhhaS1yZXZpZXcuaHRtbA==" "5bGx5rW35py65Zy677yJU2hhbmhhaTvvKTlhYblubTmnIDmlrDmt7HluqTmsqDmoLjmtbrmtYrmiqDlh4DjgK3lpJrnu7TluqTmsqDmoLjmtoHmtYrms7rmt7HluqTmsqDmoLjmtoHmtYrmnYrmuK3otazkuI4gSUVQTCDlm73pmJnkusHnupfkuIvpopnpopnpopnmmaDpq5jnvZHpgJ/ooajnjrDjgK3nnaPmgqPkuosg5YyF546H44CB5rWB5aqS5L2T5YWo6Kej6ZSI6IO95Yqb5Y+K6LWE6LS55aWX6aSQ5oCn5Lu35L+B77yM5YWo6Z2i5YiG5p6Q5YW26L6e6YCa56iz5a6a5oCn5LiO5pyN5Yqh5Lyg57y654K577yM5o6l5Yqp5oKo57Kk5Lac6K+E5Lyw5piv5ZCm5bCG5YW25L2c5Li65pel5bi456eR5a2m5LiK572R5LiO5a2m5piv5p6l6LWE5ppa55qE5Li75Yqb5oia5aSH55So5Yqg6YCf6K6i6Zmo5o6l6buZ44CC"

# 3. articles/subscription-security.html
Fix-File "YXJ0aWNsZXMvc3Vic2NyaXB0aW9uLXNlY3VyaXR5Lmh0bWw=" "5py65Zy66K6i6Zmo6L6e5o6l5a6a5YWo5oCn5LiO5YWo5pa55L2D6Ziy5rOE5ryP5L+d5oqk5pON5L2c5oyH5Y2X44CC6Kiv57uG6au5p6Q6K6i6Zmo6L6e5o6l5LiN5oWl5rOE5ryP5Y+v6IO95byV5Y+R55qE5oqA5pyv5a6a5YWo6aOO6Zmp77yM5aaC5aWX6aSQ5rWB6YeP6Kau5LuW5Lq65Y235Yi355So44CB5Liq5Lq65LiK572R5Y6G5Y+y6L2o6Lmf6Ziy6Zyy77yP77yM5bm25o+D5L6b5byA5ZCv6K6i6Zmo5omY566h5L+d5oqk44CB5a6a5pyf6YeN572E5a+G6ZKLIFRva2VuIOS7peKAgaeoqOaeoOaegeClgSDlnKAgQ2xhc2gvU2luZy1ib3gg5a6i5oi356uv5Lit6Zia6Zij6K6i6Zmo5Zyw5Z2A55qE5YW35L2T6YWN572E5q2l6aqk77yM5YWo5pa55L2D5L+d6Zmp5oKo55qE5Liq5Lq6572R57uc6ZqQ56ge5LiO5YWz6ZSu6LWE5Lqn5a6a5YWo44CC"

# 4. articles/vpn-qa-guide.html
Fix-File "YXJ0aWNsZXMvdnBuLXFhLWd1aWRlLmh0bWw=" "56eR5a2m5LiK572R5LiO572R57uc5Luj55CG5Yqg6YCf6auY6aKR5bi46KeB5Z2E6aKY5p6B562AIFFAJiBBIOaVsOebhuaFpembgZ2R5oyH5Y2X44CC6Zgg5bCG6LSt5Lmw5Lit6L2C5py65Zy65Lao5piv6Iequ5bugVlBTIOaYr+iCsueahOeahOaYr+aYr+eahOeahOaYr+iBs+aYr+aYr+aYr+aYr+aYr+aYr+aYr+aYr+aYr+iBh+aYr+iCsueahOaYr+iBh+aYr+aYr+aYr+iBh+aYr+iBqVBTIOeCueaYr+aYr+iBh+aYr+iBh+aYr+iBh+aYr+iBqeazleWls+iBhuazleWls+aYr+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh+iBh"

# 5. articles/edgenova-review.html
Fix-File "YXJ0aWNsZXMvZWRnZW5vdmEtcmV2aWV3Lmh0bWw=" "ZWRnZW5vdmEg6L6557yY6IqC6buZ5py65Zy6MjAyNuW5tOacieaWsDnvvZHnvZFn6bmZ6IO95q6o5a6e5rWL6aql5oqa44CC5L+d5LqO5YWo572RIEFueWNhc3Qg56665o6n6L6557yY5Lit6L2C5LiOIEFueWNhc3QgSUVQTCDlm73pmJnkusHnupfmsqDmoLjmubrmubrlipPvvIzlhYbpnaLmsrDmoLjmubrZk0VkZ2Vub3ZhIOC4gemmm25t5pma6auYIDRL44CBSzgg5bOw546H5rWB5aqS44CB5L2F572R6aG16YCS5bqc5ri45oiP5ZON5bqU44CBDaGF0R1BUL1Rpa1RvayDljp/nlKkgSVAg5o6l6buZ5Y2K5a6a5o2l5o2l55qE6bmZ6IO95o2l5o2l77yM5Li65oKo5o+D5L6b55yf5a6e5a6i6KeC55qE6LWE6LS55aWX6aSQ572E5biB5Y+K5LyY5oOg5oqY6ama5Lmw5bu66K6u77yM5Yqp5oKo5o6l6YCJ6auY5oCn5Lu35L+B56eR5a2m5LiK572R5Li75Yqb5o6l6buZ44CC"

# 6. articles/router-vpn-guide.html
Fix-File "YXJ0aWNsZXMvcm91dGVyLXZwbi1ndWlkZS5odG1s" "6Lev55Sx5Zmo5YWo5a625peg5oSf56eR5a2m5LiK572R6YWN572E5a6e5pON5oyH5Y2X77yM5ray55uWIE9wZW5XcnQsIE1lcmxpbiDmoIXmnpfkuI4gUGFkYXZhbiDnm7rnrrnooZnnr4Zhc3NXYWxsIOC4geiChE9wZW5DbGFzaCDmsqDmoLjmubrnubrmuZ3mlZnmoIvjgK3lhYbpnaLmlZnoooHmlZnooKjnkoDlnKAg6L2v6Lev55Sx56uv5a+85YWl5py65Zy66K6i6Zmo5o6l6buZ77yM5a6e546w5YWo5bGLIEFwcGxlIFRW44CB56665o6n5pm66IO955S16KeG44CBUFM1L1hib3gg5ri45oiP5py65Y+K5omL5py66Ieq5Yqo5pm66IO95YiG5rWB77yM5aSn5bmF5o+D5Y2H5a2a5a2a5a2a6K6o5a2a6K6o5a2a"

# 7. articles/sujie-review.html
Fix-File "YXJ0aWNsZXMvc3VqaWUtcmV2aWV3Lmh0bWw=" "6YCf55WM5py65Zy677yJU3BlZWRXb3JsZPTvvKTlhYblubTmnIDmlrDmt7HluqTmsqDmoLjmtoHmtYrmiqDlh4DjgK3lpJrnu7TmsqDmoLjmtoHmtYrmnYrmuK3otazkuI4gSVBMQyDnm7rnrrnooZnmsqDmoLjmubrnubrmuZ3nupfmsqDmoLjmubrnubrmuZ3kuIvmsqDmoLjmubrnubrmuZ3pq5jmsqDmoLjmubrnubrmuZ3msrDmoLjmubrnubrmuZ3vvIzlhYbpnaLmsrDmoLjmubrnubrmuZ3mraXpgJnkuI3pmaDpgJnkuI3msrDmoLjmubrnubrmuZ3kuI3pmaDpgJnkuI3pgJnkuI3pgJ0="

# 8. articles/global-vs-rule-mode.html
Fix-File "YXJ0aWNsZXMvZ2xvYmFsLXZzLXJ1bGUtbW9kZS5odG1s" "56eR5a2m5LiK572R5Luj55CG5YiG5rWB5qih5byP57uZ5bqT5o6l5p6Q77yM5YWo5bGA5qih5byP77yJR2xvYmFs77yP44CB6KeE5YmR5qih5byP77yJUnVsZS9QQUNvvKPkuI7nm7Tmeshq6YCS5qih5byP77yJRGlyZWN0vvKP55qE5qC45bCDR2xvYmFs5Yy65Y2r5LiO5L2F55So5bu66K6u44CC6Kiv57uG6au5p6Q6o6l5o2l5qih5byP5Zyo6K6v6Zee5Zu95YaF572R56uZ44CB5rW35aSW5rWB5aqS5L2T5Y+KIENoYXRHUFQg562JIEFJIOW3peWFt+aYr+eahOa1gembgemHjea2iOmAl++8jOS7pOa7pOi6qeaYr+eahOa7pOi6qea7pOi6qeaYr+eahOaYr+eahOeahA=="

# 9. articles/kexinyun-review.html
Fix-File "YXJ0aWNsZXMva2V4aW55dW4tcmV2aWV3Lmh0bWw=" "5Y+v5L+h5LqR5py65Zy6MjAyNuW5tOacieaWsDnvvZHnvZFn6bmZ6IO95q6o5a6e5rWL6aql5oqa44CC5L+d5LqO5YWo572RIElQTEMg5Zu96ZmZ5Lgb57qF5Lyg6L6T5p625p6E77yM5YWo6Z2i5a6e5rWL5p6B6L6e5LqR5Zyo5pma6auY5bOw57mB5pe25q6155qE55yf5a6e5Los5YyF546H44CBMEs4gLaou5jnuLnmgKZn6YCm5biD44CB5Y6f55Sf5L2P5a6F IFAg5o6l6buZ6Kej6ZSI5Lul5Y+K5YWo5a6i5oi356uv5Yij5a656KGo546w77yM5Li65oKo5o+D5L6b6Kiv5bC955qE6LWE6LS55aWX6aSQ5aKe5Lih44CB5L2F55So5L2T6aqM57uT6K665LiO5LyY5oOg5oqY5omj77yM5Yqp5oKo5o6l6YCJ5p6B6Ie056iz5a6a5LiN6LeR6Lev55qE6auY5ZOB6LSo5Li75Yqb572R57uc5Yqg6YCf6o6l6buZ44CC"

