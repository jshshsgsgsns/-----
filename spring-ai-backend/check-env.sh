#!/bin/bash

# 环境配置检查脚本
# 用于验证开发环境是否正确配置

echo "======================================"
echo "  环境配置检查工具"
echo "  Spring Boot + Spring AI 酒店管理系统"
echo "======================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查计数器
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# 检查函数
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 已安装"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $1 未安装"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

check_version() {
    if command -v $1 &> /dev/null; then
        VERSION=$($1 $2 2>&1 | head -n 1)
        echo -e "${GREEN}✓${NC} $1 版本: $VERSION"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $1 未安装"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

check_env_var() {
    if [ -n "${!1}" ]; then
        echo -e "${GREEN}✓${NC} 环境变量 $1 已设置"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} 环境变量 $1 未设置"
        WARN_COUNT=$((WARN_COUNT + 1))
        return 1
    fi
}

check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} 端口 $1 已在使用"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} 端口 $1 未使用"
        WARN_COUNT=$((WARN_COUNT + 1))
        return 1
    fi
}

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} 文件 $1 存在"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${RED}✗${NC} 文件 $1 不存在"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} 目录 $1 存在"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${RED}✗${NC} 目录 $1 不存在"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

echo "1. 检查操作系统"
echo "--------------------------------------"
OS=$(uname -s)
echo "操作系统: $OS"
if [[ "$OS" == "Linux" ]]; then
    DISTRO=$(lsb_release -d 2>/dev/null | cut -f2)
    echo "发行版本: $DISTRO"
fi
echo ""

echo "2. 检查Java环境"
echo "--------------------------------------"
check_version "java" "-version"
check_version "javac" "-version"
echo ""

echo "3. 检查Maven环境"
echo "--------------------------------------"
check_version "mvn" "-version"
echo ""

echo "4. 检查Node.js环境（前端开发）"
echo "--------------------------------------"
check_version "node" "-v"
check_version "npm" "-v"
echo ""

echo "5. 检查Git环境"
echo "--------------------------------------"
check_version "git" "--version"
echo ""

echo "6. 检查MySQL环境"
echo "--------------------------------------"
check_command "mysql"
check_command "mysqldump"
echo ""

echo "7. 检查Docker环境（可选）"
echo "--------------------------------------"
check_command "docker"
check_command "docker-compose"
echo ""

echo "8. 检查环境变量"
echo "--------------------------------------"
check_env_var "DASHSCOPE_API_KEY"
check_env_var "DB_URL"
check_env_var "DB_USERNAME"
check_env_var "DB_PASSWORD"
check_env_var "SPRING_PROFILES_ACTIVE"
echo ""

echo "9. 检查端口占用"
echo "--------------------------------------"
check_port 8080
check_port 8081
check_port 3306
echo ""

echo "10. 检查项目文件"
echo "--------------------------------------"
check_file "pom.xml"
check_file "src/main/resources/application.yml"
check_file "src/main/resources/application-dev.yml"
check_file "src/main/resources/schema.sql"
check_directory "src/main/java/com/ai/hotel"
echo ""

echo "11. 检查网络连接"
echo "--------------------------------------"
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}✓${NC} 网络连接正常"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "${RED}✗${NC} 网络连接失败"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

echo "12. 检查Maven中央仓库连接"
echo "--------------------------------------"
if curl -s --head https://repo.maven.apache.org/maven2/ | head -n 1 | grep "200" > /dev/null; then
    echo -e "${GREEN}✓${NC} Maven中央仓库连接正常"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "${RED}✗${NC} Maven中央仓库连接失败"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

echo "13. 检查npm镜像源连接"
echo "--------------------------------------"
if curl -s --head https://registry.npmjs.org/ | head -n 1 | grep "200" > /dev/null; then
    echo -e "${GREEN}✓${NC} npm镜像源连接正常"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "${RED}✗${NC} npm镜像源连接失败"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

echo "======================================"
echo "  检查结果汇总"
echo "======================================"
echo -e "${GREEN}通过: $PASS_COUNT${NC}"
echo -e "${YELLOW}警告: $WARN_COUNT${NC}"
echo -e "${RED}失败: $FAIL_COUNT${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ] && [ $WARN_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ 环境配置完美！可以开始开发了。${NC}"
    exit 0
elif [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${YELLOW}⚠ 环境配置基本正常，但有一些警告需要注意。${NC}"
    exit 0
else
    echo -e "${RED}✗ 环境配置存在问题，请根据上述提示进行修复。${NC}"
    exit 1
fi
