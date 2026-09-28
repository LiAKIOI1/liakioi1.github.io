@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: -------- 自动获取本机 IPv4 地址 --------
set "ip=未检测到IP"
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do (
    set "raw=%%i"
    set "raw=!raw: =!"
    if not "!raw!"=="" (
        set "ip=!raw!"
        goto :ip_found
    )
)
:ip_found

:: -------- 显示服务器信息 --------
echo ==========================================
echo   当前工作目录: %cd%
echo   启动 HTTP 服务器 (UTF-8 编码)
echo   端口: 8000
echo   本机访问: http://localhost:8000
echo   同网段访问: http://!ip!:8000
echo ==========================================
echo.
echo 直接关闭窗口可停止服务器
echo.

:: -------- 启动 Python 服务器（使用 atexit 保证关闭）--------
python -c "import http.server, socketserver, os, atexit; os.chdir(r'%cd%'); handler = http.server.SimpleHTTPRequestHandler; handler.extensions_map.update({'.html':'text/html; charset=utf-8','.htm':'text/html; charset=utf-8','.txt':'text/plain; charset=utf-8','.css':'text/css; charset=utf-8','.js':'application/javascript; charset=utf-8','.json':'application/json; charset=utf-8'}); httpd = socketserver.TCPServer(('', 8000), handler); atexit.register(httpd.shutdown); print('服务器已启动，等待请求...'); httpd.serve_forever()"

pause