#!/bin/bash

# ===================================================================
# 数据库快速初始化脚本
# Spring Boot + Spring AI 酒店管理系统
# ===================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  数据库快速初始化脚本${NC}"
echo -e "${BLUE}  Spring Boot + Spring AI 酒店管理系统${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 默认配置
DB_HOST="localhost"
DB_PORT="3306"
DB_ROOT_USER="root"
DB_ROOT_PASSWORD=""
DB_NAME="ai_hotel_dev"
SQL_FILE="src/main/resources/complete-schema.sql"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        --host)
            DB_HOST="$2"
            shift 2
            ;;
        --port)
            DB_PORT="$2"
            shift 2
            ;;
        --user)
            DB_ROOT_USER="$2"
            shift 2
            ;;
        --password)
            DB_ROOT_PASSWORD="$2"
            shift 2
            ;;
        --database)
            DB_NAME="$2"
            shift 2
            ;;
        --file)
            SQL_FILE="$2"
            shift 2
            ;;
        --help)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --host HOST         数据库主机（默认：localhost）"
            echo "  --port PORT         数据库端口（默认：3306）"
            echo "  --user USER         数据库用户（默认：root）"
            echo "  --password PASSWORD   数据库密码"
            echo "  --database NAME     数据库名称（默认：ai_hotel_dev）"
            echo "  --file FILE         SQL文件路径（默认：src/main/resources/complete-schema.sql）"
            echo "  --help              显示此帮助信息"
            echo ""
            echo "示例:"
            echo "  $0 --user root --password yourpassword --database ai_hotel_dev"
            exit 0
            ;;
        *)
            echo -e "${RED}未知选项: $1${NC}"
            echo "使用 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

# 检查SQL文件是否存在
if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}错误: SQL文件不存在: $SQL_FILE${NC}"
    exit 1
fi

# 提示输入密码（如果未提供）
if [ -z "$DB_ROOT_PASSWORD" ]; then
    echo -e "${YELLOW}请输入MySQL root密码:${NC}"
    read -s DB_ROOT_PASSWORD
    echo ""
fi

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  配置信息${NC}"
echo -e "${BLUE}======================================${NC}"
echo -e "主机: ${GREEN}$DB_HOST${NC}"
echo -e "端口: ${GREEN}$DB_PORT${NC}"
echo -e "用户: ${GREEN}$DB_ROOT_USER${NC}"
echo -e "数据库: ${GREEN}$DB_NAME${NC}"
echo -e "SQL文件: ${GREEN}$SQL_FILE${NC}"
echo ""

# 确认执行
read -p "确认执行数据库初始化？(y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}已取消操作${NC}"
    exit 0
fi

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  开始执行数据库初始化${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 步骤1：测试数据库连接
echo -e "${BLUE}[1/6]${NC} 测试数据库连接..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" -e "SELECT 1;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} 数据库连接成功"
else
    echo -e "${RED}✗${NC} 数据库连接失败，请检查用户名和密码"
    exit 1
fi
echo ""

# 步骤2：创建数据库
echo -e "${BLUE}[2/6]${NC} 创建数据库..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} 数据库创建成功"
else
    echo -e "${RED}✗${NC} 数据库创建失败"
    exit 1
fi
echo ""

# 步骤3：执行SQL文件
echo -e "${BLUE}[3/6]${NC} 执行SQL文件..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" "$DB_NAME" < "$SQL_FILE" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} SQL文件执行成功"
else
    echo -e "${RED}✗${NC} SQL文件执行失败"
    exit 1
fi
echo ""

# 步骤4：验证表创建
echo -e "${BLUE}[4/6]${NC} 验证表创建..."
TABLE_COUNT=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" "$DB_NAME" -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME';")
if [ "$TABLE_COUNT" -ge 7 ]; then
    echo -e "${GREEN}✓${NC} 表创建成功（共 $TABLE_COUNT 个表）"
else
    echo -e "${RED}✗${NC} 表创建失败（仅 $TABLE_COUNT 个表）"
    exit 1
fi
echo ""

# 步骤5：验证初始数据
echo -e "${BLUE}[5/6]${NC} 验证初始数据..."
USER_COUNT=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" "$DB_NAME" -N -e "SELECT COUNT(*) FROM users;")
CONFIG_COUNT=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" "$DB_NAME" -N -e "SELECT COUNT(*) FROM system_config;")
if [ "$USER_COUNT" -ge 2 ] && [ "$CONFIG_COUNT" -ge 10 ]; then
    echo -e "${GREEN}✓${NC} 初始数据验证成功"
    echo -e "  - 用户数: $USER_COUNT"
    echo -e "  - 配置数: $CONFIG_COUNT"
else
    echo -e "${YELLOW}⚠${NC} 初始数据可能不完整"
    echo -e "  - 用户数: $USER_COUNT"
    echo -e "  - 配置数: $CONFIG_COUNT"
fi
echo ""

# 步骤6：显示数据库信息
echo -e "${BLUE}[6/6]${NC} 显示数据库信息..."
echo ""
echo -e "${GREEN}数据库信息:${NC}"
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" "$DB_NAME" -e "
SELECT 
    '表名' AS 信息类型,
    table_name AS 名称,
    table_rows AS 记录数,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS 大小_MB
FROM information_schema.tables 
WHERE table_schema = '$DB_NAME'
ORDER BY (data_length + index_length) DESC;
" 2>/dev/null
echo ""

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  数据库初始化完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${BLUE}后续步骤:${NC}"
echo "1. 配置应用程序的数据库连接信息"
echo "2. 启动Spring Boot应用"
echo "3. 访问 http://localhost:8080/api/swagger-ui.html 查看API文档"
echo ""
echo -e "${BLUE}数据库连接信息:${NC}"
echo "  JDBC URL: jdbc:mysql://$DB_HOST:$DB_PORT/$DB_NAME?useSSL=false&serverTimezone=UTC&characterEncoding=utf8"
echo "  用户名: $DB_ROOT_USER"
echo "  密码: [您的密码]"
echo ""
