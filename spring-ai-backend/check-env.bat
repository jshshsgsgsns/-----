@echo off
REM 环境配置检查脚本 (Windows版本)
REM 用于验证开发环境是否正确配置

echo ======================================
echo   环境配置检查工具
echo   Spring Boot + Spring AI 酒店管理系统
echo ======================================
echo.

set PASS_COUNT=0
set FAIL_COUNT=0
set WARN_COUNT=0

REM 检查命令
:check_command
where %1 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] %1 已安装
    set /a PASS_COUNT=%PASS_COUNT%+1
    exit /b 0
) else (
    echo [FAIL] %1 未安装
    set /a FAIL_COUNT=%FAIL_COUNT%+1
    exit /b 1
)

REM 检查版本
:check_version
where %1 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f "tokens=*" %%i in ('%1 %2 2^>^&1') do (
        echo [OK] %1 版本: %%i
    )
    set /a PASS_COUNT=%PASS_COUNT%+1
    exit /b 0
) else (
    echo [FAIL] %1 未安装
    set /a FAIL_COUNT=%FAIL_COUNT%+1
    exit /b 1
)

REM 检查环境变量
:check_env_var
if defined %1 (
    echo [OK] 环境变量 %1 已设置
    set /a PASS_COUNT=%PASS_COUNT%+1
    exit /b 0
) else (
    echo [WARN] 环境变量 %1 未设置
    set /a WARN_COUNT=%WARN_COUNT%+1
    exit /b 1
)

REM 检查文件
:check_file
if exist "%~1" (
    echo [OK] 文件 %~1 存在
    set /a PASS_COUNT=%PASS_COUNT%+1
    exit /b 0
) else (
    echo [FAIL] 文件 %~1 不存在
    set /a FAIL_COUNT=%FAIL_COUNT%+1
    exit /b 1
)

REM 检查目录
:check_directory
if exist "%~1" (
    echo [OK] 目录 %~1 存在
    set /a PASS_COUNT=%PASS_COUNT%+1
    exit /b 0
) else (
    echo [FAIL] 目录 %~1 不存在
    set /a FAIL_COUNT=%FAIL_COUNT%+1
    exit /b 1
)

echo 1. 检查操作系统
echo --------------------------------------
ver
echo.

echo 2. 检查Java环境
echo --------------------------------------
call :check_version "java" "-version"
call :check_version "javac" "-version"
echo.

echo 3. 检查Maven环境
echo --------------------------------------
call :check_version "mvn" "-version"
echo.

echo 4. 检查Node.js环境（前端开发）
echo --------------------------------------
call :check_version "node" "-v"
call :check_version "npm" "-v"
echo.

echo 5. 检查Git环境
echo --------------------------------------
call :check_version "git" "--version"
echo.

echo 6. 检查MySQL环境
echo --------------------------------------
call :check_command "mysql"
call :check_command "mysqldump"
echo.

echo 7. 检查Docker环境（可选）
echo --------------------------------------
call :check_command "docker"
call :check_command "docker-compose"
echo.

echo 8. 检查环境变量
echo --------------------------------------
call :check_env_var "DASHSCOPE_API_KEY"
call :check_env_var "DB_URL"
call :check_env_var "DB_USERNAME"
call :check_env_var "DB_PASSWORD"
call :check_env_var "SPRING_PROFILES_ACTIVE"
echo.

echo 9. 检查端口占用
echo --------------------------------------
netstat -ano | findstr ":8080" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] 端口 8080 已在使用
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [WARN] 端口 8080 未使用
    set /a WARN_COUNT=%WARN_COUNT%+1
)

netstat -ano | findstr ":8081" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] 端口 8081 已在使用
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [WARN] 端口 8081 未使用
    set /a WARN_COUNT=%WARN_COUNT%+1
)

netstat -ano | findstr ":3306" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] 端口 3306 已在使用
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [WARN] 端口 3306 未使用
    set /a WARN_COUNT=%WARN_COUNT%+1
)
echo.

echo 10. 检查项目文件
echo --------------------------------------
call :check_file "pom.xml"
call :check_file "src\main\resources\application.yml"
call :check_file "src\main\resources\application-dev.yml"
call :check_file "src\main\resources\schema.sql"
call :check_directory "src\main\java\com\ai\hotel"
echo.

echo 11. 检查网络连接
echo --------------------------------------
ping -n 1 8.8.8.8 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] 网络连接正常
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [FAIL] 网络连接失败
    set /a FAIL_COUNT=%FAIL_COUNT%+1
)
echo.

echo 12. 检查Maven中央仓库连接
echo --------------------------------------
curl -s --head https://repo.maven.apache.org/maven2/ | findstr "200" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Maven中央仓库连接正常
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [FAIL] Maven中央仓库连接失败
    set /a FAIL_COUNT=%FAIL_COUNT%+1
)
echo.

echo 13. 检查npm镜像源连接
echo --------------------------------------
curl -s --head https://registry.npmjs.org/ | findstr "200" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] npm镜像源连接正常
    set /a PASS_COUNT=%PASS_COUNT%+1
) else (
    echo [FAIL] npm镜像源连接失败
    set /a FAIL_COUNT=%FAIL_COUNT%+1
)
echo.

echo ======================================
echo   检查结果汇总
echo ======================================
echo 通过: %PASS_COUNT%
echo 警告: %WARN_COUNT%
echo 失败: %FAIL_COUNT%
echo.

if %FAIL_COUNT% EQU 0 (
    if %WARN_COUNT% EQU 0 (
        echo [OK] 环境配置完美！可以开始开发了。
        exit /b 0
    ) else (
        echo [WARN] 环境配置基本正常，但有一些警告需要注意。
        exit /b 0
    )
) else (
    echo [FAIL] 环境配置存在问题，请根据上述提示进行修复。
    exit /b 1
)
