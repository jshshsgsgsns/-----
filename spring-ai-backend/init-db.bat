@echo off
REM ===================================================================
REM 数据库快速初始化脚本 (Windows版本)
REM Spring Boot + Spring AI 酒店管理系统
REM ===================================================================

setlocal enabledelayedexpansion

echo ======================================
echo   数据库快速初始化脚本
echo   Spring Boot + Spring AI 酒店管理系统
echo ======================================
echo.

REM 默认配置
set DB_HOST=localhost
set DB_PORT=3306
set DB_ROOT_USER=root
set DB_ROOT_PASSWORD=
set DB_NAME=ai_hotel_dev
set SQL_FILE=src\main\resources\complete-schema.sql

REM 解析命令行参数
:parse_args
if "%~1"=="" goto end_parse_args
if "%~1"=="--host" (
    set DB_HOST=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--port" (
    set DB_PORT=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--user" (
    set DB_ROOT_USER=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--password" (
    set DB_ROOT_PASSWORD=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--database" (
    set DB_NAME=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--file" (
    set SQL_FILE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--help" (
    echo 用法: %0 [选项]
    echo.
    echo 选项:
    echo   --host HOST         数据库主机（默认：localhost）
    echo   --port PORT         数据库端口（默认：3306）
    echo   --user USER         数据库用户（默认：root）
    echo   --password PASSWORD   数据库密码
    echo   --database NAME     数据库名称（默认：ai_hotel_dev）
    echo   --file FILE         SQL文件路径（默认：src\main\resources\complete-schema.sql）
    echo   --help              显示此帮助信息
    echo.
    echo 示例:
    echo   %0 --user root --password yourpassword --database ai_hotel_dev
    exit /b 0
)
shift
goto parse_args

:end_parse_args

REM 检查SQL文件是否存在
if not exist "%SQL_FILE%" (
    echo [错误] SQL文件不存在: %SQL_FILE%
    exit /b 1
)

REM 提示输入密码（如果未提供）
if "%DB_ROOT_PASSWORD%"=="" (
    set /p DB_ROOT_PASSWORD=请输入MySQL root密码: 
)

echo ======================================
echo   配置信息
echo ======================================
echo 主机: %DB_HOST%
echo 端口: %DB_PORT%
echo 用户: %DB_ROOT_USER%
echo 数据库: %DB_NAME%
echo SQL文件: %SQL_FILE%
echo.

REM 确认执行
set /p CONFIRM=确认执行数据库初始化？(y/n): 
if /i not "%CONFIRM%"=="y" (
    echo 已取消操作
    exit /b 0
)

echo ======================================
echo   开始执行数据库初始化
echo ======================================
echo.

REM 步骤1：测试数据库连接
echo [1/6] 测试数据库连接...
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% -e "SELECT 1;" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] 数据库连接成功
) else (
    echo [FAIL] 数据库连接失败，请检查用户名和密码
    exit /b 1
)
echo.

REM 步骤2：创建数据库
echo [2/6] 创建数据库...
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] 数据库创建成功
) else (
    echo [FAIL] 数据库创建失败
    exit /b 1
)
echo.

REM 步骤3：执行SQL文件
echo [3/6] 执行SQL文件...
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% %DB_NAME% < %SQL_FILE% 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] SQL文件执行成功
) else (
    echo [FAIL] SQL文件执行失败
    exit /b 1
)
echo.

REM 步骤4：验证表创建
echo [4/6] 验证表创建...
for /f "tokens=*" %%i in ('mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% %DB_NAME% -N -s -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '%DB_NAME%';"') do set TABLE_COUNT=%%i
if %TABLE_COUNT% GEQ 7 (
    echo [OK] 表创建成功（共 %TABLE_COUNT% 个表）
) else (
    echo [FAIL] 表创建失败（仅 %TABLE_COUNT% 个表）
    exit /b 1
)
echo.

REM 步骤5：验证初始数据
echo [5/6] 验证初始数据...
for /f "tokens=*" %%i in ('mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% %DB_NAME% -N -s -e "SELECT COUNT(*) FROM users;"') do set USER_COUNT=%%i
for /f "tokens=*" %%i in ('mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% %DB_NAME% -N -s -e "SELECT COUNT(*) FROM system_config;"') do set CONFIG_COUNT=%%i
if %USER_COUNT% GEQ 2 (
    if %CONFIG_COUNT% GEQ 10 (
        echo [OK] 初始数据验证成功
        echo   - 用户数: %USER_COUNT%
        echo   - 配置数: %CONFIG_COUNT%
    ) else (
        echo [WARN] 初始数据可能不完整
        echo   - 用户数: %USER_COUNT%
        echo   - 配置数: %CONFIG_COUNT%
    )
) else (
    echo [WARN] 初始数据可能不完整
    echo   - 用户数: %USER_COUNT%
    echo   - 配置数: %CONFIG_COUNT%
)
echo.

REM 步骤6：显示数据库信息
echo [6/6] 显示数据库信息...
echo.
echo 数据库信息:
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_ROOT_USER% -p%DB_ROOT_PASSWORD% %DB_NAME% -e "
SELECT 
    '表名' AS 信息类型,
    table_name AS 名称,
    table_rows AS 记录数,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS 大小_MB
FROM information_schema.tables 
WHERE table_schema = '%DB_NAME%'
ORDER BY (data_length + index_length) DESC;
" 2>nul
echo.

echo ======================================
echo   数据库初始化完成！
echo ======================================
echo.
echo 后续步骤:
echo 1. 配置应用程序的数据库连接信息
echo 2. 启动Spring Boot应用
echo 3. 访问 http://localhost:8080/api/swagger-ui.html 查看API文档
echo.
echo 数据库连接信息:
echo   JDBC URL: jdbc:mysql://%DB_HOST%:%DB_PORT%/%DB_NAME%?useSSL=false^&serverTimezone=UTC^&characterEncoding=utf8
echo   用户名: %DB_ROOT_USER%
echo   密码: [您的密码]
echo.

endlocal
