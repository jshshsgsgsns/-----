# 环境配置指南

本文档详细说明了Spring Boot + Spring AI酒店管理系统在开发、测试和生产环境下的完整配置要求。

## 目录

- [1. 开发环境配置](#1-开发环境配置)
- [2. 测试环境配置](#2-测试环境配置)
- [3. 生产环境配置](#3-生产环境配置)
- [4. 操作系统要求](#4-操作系统要求)
- [5. 编程语言及版本](#5-编程语言及版本)
- [6. 依赖库及版本](#6-依赖库及版本)
- [7. 数据库配置](#7-数据库配置)
- [8. 服务器配置](#8-服务器配置)
- [9. 网络环境要求](#9-网络环境要求)
- [10. 环境变量设置](#10-环境变量设置)
- [11. 开发工具及插件](#11-开发工具及插件)
- [12. 快速搭建指南](#12-快速搭建指南)

---

## 1. 开发环境配置

### 1.1 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| CPU | 4核 | 8核及以上 |
| 内存 | 8GB | 16GB及以上 |
| 硬盘 | 50GB SSD | 100GB SSD及以上 |
| 网络 | 10Mbps | 100Mbps及以上 |

### 1.2 软件环境

#### 后端开发环境
- **操作系统**: Windows 10/11, macOS 12+, Ubuntu 20.04+
- **JDK**: OpenJDK 17 或 Oracle JDK 17
- **Maven**: 3.6.0+
- **IDE**: IntelliJ IDEA 2022.3+ 或 Eclipse 2022-09+
- **Git**: 2.30.0+

#### 前端开发环境
- **操作系统**: Windows 10/11, macOS 12+, Ubuntu 20.04+
- **Node.js**: 14.x, 16.x, 18.x（推荐18.x）
- **npm**: 6.x, 7.x, 8.x, 9.x（与Node.js版本匹配）
- **IDE**: VSCode 1.70+ 或 WebStorm 2022.3+

### 1.3 开发环境配置文件

```yaml
# application-dev.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ai_hotel_dev?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
    username: root
    password: dev_password
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
        format_sql: true

aliyun:
  dashscope:
    api-key: ${DASHSCOPE_API_KEY:your-dev-api-key}
    model: qwen-turbo
    timeout: 30000

logging:
  level:
    root: INFO
    com.ai.hotel: DEBUG
    org.springframework.ai: DEBUG
```

### 1.4 开发环境端口配置

| 服务 | 端口 | 说明 |
|------|------|------|
| 后端服务 | 8080 | Spring Boot应用 |
| 前端服务 | 8081 | Vue.js开发服务器 |
| MySQL | 3306 | 数据库服务 |
| Swagger UI | 8080/api/swagger-ui.html | API文档 |

---

## 2. 测试环境配置

### 2.1 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| CPU | 4核 | 8核 |
| 内存 | 8GB | 16GB |
| 硬盘 | 50GB SSD | 100GB SSD |
| 网络 | 10Mbps | 100Mbps |

### 2.2 软件环境

- **操作系统**: Ubuntu 20.04 LTS 或 CentOS 8+
- **JDK**: OpenJDK 17
- **Maven**: 3.6.0+
- **MySQL**: 8.0+
- **Docker**: 20.10+（可选，用于容器化部署）

### 2.3 测试环境配置文件

```yaml
# application-test.yml
spring:
  datasource:
    url: jdbc:mysql://test-db-host:3306/ai_hotel_test?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
    username: test_user
    password: test_password
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

aliyun:
  dashscope:
    api-key: ${DASHSCOPE_API_KEY}
    model: qwen-turbo
    timeout: 30000

logging:
  level:
    root: WARN
    com.ai.hotel: INFO
```

### 2.4 测试环境端口配置

| 服务 | 端口 | 说明 |
|------|------|------|
| 后端服务 | 8080 | Spring Boot应用 |
| MySQL | 3306 | 数据库服务 |
| 测试报告 | 8081 | 测试报告服务（可选） |

---

## 3. 生产环境配置

### 3.1 硬件要求

| 组件 | 最低配置 | 推荐配置 | 高负载配置 |
|------|---------|---------|-----------|
| CPU | 8核 | 16核 | 32核+ |
| 内存 | 16GB | 32GB | 64GB+ |
| 硬盘 | 200GB SSD | 500GB SSD | 1TB SSD+ |
| 网络 | 100Mbps | 1Gbps | 10Gbps |

### 3.2 软件环境

- **操作系统**: Ubuntu 22.04 LTS 或 CentOS 9 Stream
- **JDK**: OpenJDK 17 LTS
- **Maven**: 3.8.0+
- **MySQL**: 8.0.33+
- **Nginx**: 1.24+（反向代理）
- **Docker**: 24.0+（容器化部署）
- **Kubernetes**: 1.27+（可选，用于容器编排）

### 3.3 生产环境配置文件

```yaml
# application-prod.yml
spring:
  datasource:
    url: ${DB_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
  jpa:
    hibernate:
      ddl-auto: none
    show-sql: false

aliyun:
  dashscope:
    api-key: ${DASHSCOPE_API_KEY}
    model: qwen-plus
    timeout: 60000

logging:
  file:
    name: /var/log/ai-hotel/application.log
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
  level:
    root: ERROR
    com.ai.hotel: WARN

server:
  compression:
    enabled: true
    mime-types: application/json,application/xml,text/html,text/xml,text/plain
```

### 3.4 生产环境端口配置

| 服务 | 端口 | 说明 |
|------|------|------|
| Nginx | 80, 443 | HTTP/HTTPS入口 |
| 后端服务 | 8080 | Spring Boot应用 |
| MySQL | 3306 | 数据库服务 |
| Redis（可选） | 6379 | 缓存服务 |

---

## 4. 操作系统要求

### 4.1 Windows环境

| 项目 | 版本要求 | 备注 |
|------|---------|------|
| Windows | Windows 10 (1909+) 或 Windows 11 | 推荐使用专业版或企业版 |
| PowerShell | 5.1+ | 用于命令行操作 |
| WSL2 | Ubuntu 20.04+ | 可选，用于Linux环境开发 |

### 4.2 macOS环境

| 项目 | 版本要求 | 备注 |
|------|---------|------|
| macOS | 12.0 (Monterey) 或更高版本 | 推荐使用最新稳定版 |
| Xcode Command Line Tools | 最新版本 | 用于编译某些依赖 |
| Homebrew | 最新版本 | 包管理器 |

### 4.3 Linux环境

| 项目 | 版本要求 | 备注 |
|------|---------|------|
| Ubuntu | 20.04 LTS, 22.04 LTS | 推荐使用LTS版本 |
| CentOS | 8 Stream, 9 Stream | 企业级部署推荐 |
| Debian | 11 (Bullseye) 或更高 | 稳定版本 |

---

## 5. 编程语言及版本

### 5.1 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 17 (LTS) | 必须使用Java 17或更高版本 |
| Kotlin | 1.9+ | 可选，用于部分模块 |
| Groovy | 3.0+ | 可选，用于脚本 |

### 5.2 前端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| JavaScript | ES6+ | 现代JavaScript语法 |
| Vue.js | 2.6.x 或 3.x | 当前项目使用2.x |
| TypeScript | 4.x+ | 可选，用于新项目 |

### 5.3 构建工具

| 工具 | 版本 | 用途 |
|------|------|------|
| Maven | 3.6.0+ | Java项目构建 |
| npm | 6.x-9.x | Node.js包管理 |
| webpack | 4.x-5.x | 前端打包 |

---

## 6. 依赖库及版本

### 6.1 后端依赖（pom.xml）

```xml
<!-- Spring Boot -->
<spring-boot.version>3.2.0</spring-boot.version>

<!-- Spring AI -->
<spring-ai.version>1.0.0-M4</spring-ai.version>

<!-- 阿里云SDK -->
<aliyun-java-sdk-core.version>4.6.4</aliyun-java-sdk-core.version>
<aliyun-java-sdk-dashscope.version>2.15.2</aliyun-java-sdk-dashscope.version>

<!-- Spring Cloud Alibaba AI -->
<spring-cloud-ai-alibaba.version>1.0.0-M2</spring-cloud-ai-alibaba.version>

<!-- Swagger/OpenAPI -->
<swagger.version>2.2.0</swagger.version>

<!-- Lombok -->
<lombok.version>1.18.30</lombok.version>

<!-- 数据库驱动 -->
<mysql-connector.version>8.0.33</mysql-connector.version>
```

### 6.2 前端依赖（package.json）

```json
{
  "dependencies": {
    "vue": "^2.6.14",
    "vue-router": "^3.5.3",
    "vuex": "^3.6.2",
    "axios": "^1.4.0",
    "element-ui": "^2.15.14",
    "js-md5": "^0.7.3"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.8",
    "babel-loader": "^8.3.0",
    "webpack": "^5.88.0"
  }
}
```

### 6.3 核心依赖说明

| 依赖 | 版本 | 用途 |
|------|------|------|
| spring-boot-starter-web | 3.2.0 | Web应用基础 |
| spring-boot-starter-data-jpa | 3.2.0 | 数据持久化 |
| spring-boot-starter-security | 3.2.0 | 安全认证 |
| spring-boot-starter-validation | 3.2.0 | 参数验证 |
| spring-ai-openai-spring-boot-starter | 1.0.0-M4 | Spring AI集成 |
| spring-ai-alibaba-starter | 1.0.0-M2 | 阿里云AI集成 |
| springdoc-openapi-starter-webmvc-ui | 2.2.0 | API文档 |
| lombok | 1.18.30 | 简化代码 |
| mysql-connector-j | 8.0.33 | MySQL驱动 |

---

## 7. 数据库配置

### 7.1 MySQL数据库

| 项目 | 开发环境 | 测试环境 | 生产环境 |
|------|---------|---------|---------|
| 版本 | 8.0.33+ | 8.0.33+ | 8.0.33+ |
| 字符集 | utf8mb4 | utf8mb4 | utf8mb4 |
| 排序规则 | utf8mb4_unicode_ci | utf8mb4_unicode_ci | utf8mb4_unicode_ci |
| 存储引擎 | InnoDB | InnoDB | InnoDB |
| 最大连接数 | 151 | 200 | 500+ |

### 7.2 数据库初始化

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS ai_hotel_dev 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE ai_hotel_dev;

-- 执行schema.sql中的表创建脚本
```

### 7.3 数据库连接池配置（生产环境）

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20        # 最大连接数
      minimum-idle: 5              # 最小空闲连接
      connection-timeout: 30000    # 连接超时（毫秒）
      idle-timeout: 600000        # 空闲超时（毫秒）
      max-lifetime: 1800000       # 连接最大生命周期（毫秒）
      leak-detection-threshold: 60000  # 连接泄漏检测阈值（毫秒）
```

### 7.4 数据库备份策略

| 环境 | 备份频率 | 保留时间 | 备份方式 |
|------|---------|---------|---------|
| 开发环境 | 每日 | 7天 | 手动或脚本 |
| 测试环境 | 每日 | 30天 | 自动备份 |
| 生产环境 | 每小时 | 90天 | 自动备份 + 异地备份 |

---

## 8. 服务器配置

### 8.1 应用服务器配置

#### 开发环境
```bash
# JVM参数
-Xms512m -Xmx1024m -XX:+UseG1GC -XX:MaxGCPauseMillis=200

# 启动命令
java -jar -Xms512m -Xmx1024m spring-ai-backend-1.0.0.jar
```

#### 测试环境
```bash
# JVM参数
-Xms1024m -Xmx2048m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+HeapDumpOnOutOfMemoryError

# 启动命令
java -jar -Xms1024m -Xmx2048m spring-ai-backend-1.0.0.jar
```

#### 生产环境
```bash
# JVM参数
-Xms2048m -Xmx4096m \
-XX:+UseG1GC \
-XX:MaxGCPauseMillis=200 \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=/var/log/ai-hotel/ \
-XX:+UseStringDeduplication \
-XX:+OptimizeStringConcat \
-Djava.security.egd=file:/dev/./urandom

# 启动命令
nohup java -jar \
  -Xms2048m -Xmx4096m \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  spring-ai-backend-1.0.0.jar \
  > /var/log/ai-hotel/application.log 2>&1 &
```

### 8.2 Nginx配置（生产环境）

```nginx
upstream ai_hotel_backend {
    server 127.0.0.1:8080;
    keepalive 32;
}

server {
    listen 80;
    server_name api.aihotel.com;
    
    # 重定向到HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.aihotel.com;
    
    ssl_certificate /etc/nginx/ssl/api.aihotel.com.crt;
    ssl_certificate_key /etc/nginx/ssl/api.aihotel.com.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    # 日志配置
    access_log /var/log/nginx/ai_hotel_access.log;
    error_log /var/log/nginx/ai_hotel_error.log;
    
    # API代理
    location /api/ {
        proxy_pass http://ai_hotel_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        chunked_transfer_encoding off;
        
        # 超时配置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # 静态文件缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

### 8.3 Docker配置（可选）

```dockerfile
# Dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

# 复制JAR文件
COPY target/spring-ai-backend-1.0.0.jar app.jar

# 创建日志目录
RUN mkdir -p /var/log/ai-hotel

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/api/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["java", "-jar", "-Xms512m", "-Xmx1024m", "app.jar"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: ai-hotel-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: ai_hotel_prod
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - ai-hotel-network

  app:
    build: .
    container_name: ai-hotel-app
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_URL: jdbc:mysql://mysql:3306/ai_hotel_prod
      DB_USERNAME: root
      DB_PASSWORD: root_password
      DASHSCOPE_API_KEY: ${DASHSCOPE_API_KEY}
    depends_on:
      - mysql
    networks:
      - ai-hotel-network
    restart: unless-stopped

volumes:
  mysql-data:

networks:
  ai-hotel-network:
    driver: bridge
```

---

## 9. 网络环境要求

### 9.1 端口要求

| 端口 | 协议 | 用途 | 是否必需 |
|------|------|------|---------|
| 80 | TCP | HTTP访问 | 生产环境必需 |
| 443 | TCP | HTTPS访问 | 生产环境必需 |
| 8080 | TCP | 应用服务 | 必需 |
| 8081 | TCP | 前端开发服务器 | 开发环境必需 |
| 3306 | TCP | MySQL数据库 | 必需 |
| 22 | TCP | SSH远程访问 | 生产环境必需 |

### 9.2 网络带宽要求

| 环境 | 带宽要求 | 说明 |
|------|----------|------|
| 开发环境 | 10Mbps | 支持日常开发 |
| 测试环境 | 100Mbps | 支持测试团队并发 |
| 生产环境 | 1Gbps+ | 支持高并发访问 |

### 9.3 外部服务访问

| 服务 | 域名/地址 | 端口 | 用途 |
|------|-----------|------|------|
| 阿里云通义大模型API | dashscope.aliyuncs.com | 443 | AI服务调用 |
| Maven中央仓库 | repo.maven.apache.org | 443 | 依赖下载 |
| npm镜像 | registry.npmjs.org | 443 | npm包下载 |

### 9.4 防火墙配置

```bash
# 开发环境（开放所有端口）
sudo ufw allow 8080/tcp
sudo ufw allow 3306/tcp
sudo ufw enable

# 生产环境（仅开放必要端口）
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp     # HTTP
sudo ufw allow 443/tcp    # HTTPS
sudo ufw deny 3306/tcp    # 禁止外部直接访问数据库
sudo ufw enable
```

---

## 10. 环境变量设置

### 10.1 必需环境变量

| 变量名 | 说明 | 示例 | 必需性 |
|--------|------|------|--------|
| DASHSCOPE_API_KEY | 阿里云通义大模型API密钥 | sk-xxxxxxxxxxxx | 必需 |
| DB_URL | 数据库连接URL | jdbc:mysql://localhost:3306/ai_hotel | 必需 |
| DB_USERNAME | 数据库用户名 | root | 必需 |
| DB_PASSWORD | 数据库密码 | password | 必需 |
| SPRING_PROFILES_ACTIVE | Spring激活环境 | dev/test/prod | 必需 |

### 10.2 可选环境变量

| 变量名 | 说明 | 示例 | 默认值 |
|--------|------|------|--------|
| SERVER_PORT | 应用服务端口 | 8080 | 8080 |
| JVM_XMS | JVM初始堆内存 | 512m | 512m |
| JVM_XMX | JVM最大堆内存 | 1024m | 1024m |
| LOG_LEVEL | 日志级别 | DEBUG | INFO |
| CORS_ALLOWED_ORIGINS | 允许的跨域来源 | http://localhost:8081 | * |

### 10.3 环境变量配置方式

#### Linux/Mac（.bashrc或.zshrc）
```bash
# 阿里云API密钥
export DASHSCOPE_API_KEY=sk-xxxxxxxxxxxx

# 数据库配置
export DB_URL=jdbc:mysql://localhost:3306/ai_hotel_dev
export DB_USERNAME=root
export DB_PASSWORD=your_password

# Spring环境
export SPRING_PROFILES_ACTIVE=dev

# JVM参数
export JVM_XMS=512m
export JVM_XMX=1024m
```

#### Windows（系统环境变量）
```powershell
# 设置环境变量
setx DASHSCOPE_API_KEY "sk-xxxxxxxxxxxx"
setx DB_URL "jdbc:mysql://localhost:3306/ai_hotel_dev"
setx DB_USERNAME "root"
setx DB_PASSWORD "your_password"
setx SPRING_PROFILES_ACTIVE "dev"
```

#### Docker（docker-compose.yml）
```yaml
environment:
  DASHSCOPE_API_KEY: ${DASHSCOPE_API_KEY}
  DB_URL: jdbc:mysql://mysql:3306/ai_hotel_prod
  DB_USERNAME: root
  DB_PASSWORD: ${DB_PASSWORD}
  SPRING_PROFILES_ACTIVE: prod
```

### 10.4 敏感信息管理

**开发环境**：
- 使用 `.env` 文件（添加到.gitignore）
- 使用IDE的环境变量配置功能

**测试/生产环境**：
- 使用密钥管理服务（AWS Secrets Manager、Azure Key Vault等）
- 使用Kubernetes Secrets
- 使用环境变量注入工具

---

## 11. 开发工具及插件

### 11.1 后端开发工具

#### IntelliJ IDEA（推荐）

**必需插件**：
- Lombok Plugin - Lombok支持
- Maven Helper - Maven依赖管理
- SonarLint - 代码质量检查
- CheckStyle-IDEA - 代码风格检查
- Rainbow Brackets - 括号高亮

**配置**：
```properties
# Editor -> Code Style -> Java
# 使用Google Java Style Guide

# Build, Execution, Deployment -> Compiler
# 勾选 "Enable annotation processing"

# Plugins -> Lombok
# 勾选 "Enable annotation processing"
```

#### Eclipse

**必需插件**：
- m2e - Maven集成
- Lombok - Lombok支持
- Spring Tools Suite - Spring开发支持

### 11.2 前端开发工具

#### VSCode（推荐）

**必需插件**：
- Vetur - Vue.js语法高亮
- ESLint - 代码质量检查
- Prettier - 代码格式化
- Auto Close Tag - 自动闭合标签
- Auto Rename Tag - 同步重命名标签
- Path Intellisense - 路径智能提示

**配置**：
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "vetur.format.defaultFormatter.html": "prettier",
  "vetur.format.defaultFormatter.js": "prettier",
  "vetur.format.defaultFormatter.css": "prettier",
  "eslint.validate": [
    "javascript",
    "vue"
  ]
}
```

#### WebStorm

**必需插件**：
- Vue.js - Vue.js支持
- ESLint - 代码质量检查
- Prettier - 代码格式化

### 11.3 数据库工具

| 工具 | 用途 | 推荐版本 |
|------|------|---------|
| MySQL Workbench | 数据库管理 | 8.0+ |
| DBeaver | 通用数据库工具 | 23.0+ |
| Navicat | 数据库管理 | 16.0+ |
| DataGrip | JetBrains数据库工具 | 2023.1+ |

### 11.4 API测试工具

| 工具 | 用途 | 推荐版本 |
|------|------|---------|
| Postman | API测试 | 10.0+ |
| Insomnia | API测试 | 2023.0+ |
| curl | 命令行测试 | 7.88+ |

### 11.5 版本控制工具

| 工具 | 用途 | 推荐版本 |
|------|------|---------|
| Git | 版本控制 | 2.40+ |
| GitHub Desktop | Git图形界面 | 3.0+ |
| SourceTree | Git图形界面 | 4.0+ |

### 11.6 容器化工具

| 工具 | 用途 | 推荐版本 |
|------|------|---------|
| Docker | 容器化 | 24.0+ |
| Docker Compose | 多容器编排 | 2.20+ |
| Kubernetes | 容器编排 | 1.27+ |

---

## 12. 快速搭建指南

### 12.1 开发环境搭建（Windows）

#### 步骤1：安装JDK
```powershell
# 下载并安装OpenJDK 17
# 访问：https://adoptium.net/
# 下载Windows x64版本并安装

# 验证安装
java -version
```

#### 步骤2：安装Maven
```powershell
# 下载Maven
# 访问：https://maven.apache.org/download.cgi
# 解压到 C:\Program Files\Apache\maven

# 配置环境变量
setx MAVEN_HOME "C:\Program Files\Apache\maven"
setx PATH "%PATH%;%MAVEN_HOME%\bin"

# 验证安装
mvn -version
```

#### 步骤3：安装MySQL
```powershell
# 下载MySQL Installer
# 访问：https://dev.mysql.com/downloads/installer/
# 安装MySQL Server 8.0

# 配置root密码
# 创建数据库
mysql -u root -p
CREATE DATABASE ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 步骤4：安装Node.js
```powershell
# 下载Node.js
# 访问：https://nodejs.org/
# 下载LTS版本并安装

# 验证安装
node -version
npm -version
```

#### 步骤5：安装IntelliJ IDEA
```powershell
# 下载IntelliJ IDEA
# 访问：https://www.jetbrains.com/idea/download/
# 下载Community Edition（免费）或Ultimate Edition（付费）

# 安装必需插件
# File -> Settings -> Plugins
# 搜索并安装：Lombok, Maven Helper, SonarLint
```

#### 步骤6：克隆项目并启动
```powershell
# 克隆项目
git clone <repository-url>
cd spring-ai-backend

# 配置环境变量
setx DASHSCOPE_API_KEY "your-api-key"

# 启动后端
mvn spring-boot:run

# 新开终端，启动前端
cd ..
npm install
npm run dev
```

### 12.2 开发环境搭建（macOS）

#### 步骤1：安装Homebrew
```bash
# 安装Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 验证安装
brew --version
```

#### 步骤2：安装JDK
```bash
# 安装OpenJDK 17
brew install openjdk@17

# 配置环境变量
echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 验证安装
java -version
```

#### 步骤3：安装Maven
```bash
# 安装Maven
brew install maven

# 验证安装
mvn -version
```

#### 步骤4：安装MySQL
```bash
# 安装MySQL
brew install mysql

# 启动MySQL
brew services start mysql

# 配置root密码
mysql_secure_installation

# 创建数据库
mysql -u root -p
CREATE DATABASE ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 步骤5：安装Node.js
```bash
# 安装Node.js
brew install node

# 验证安装
node -version
npm -version
```

#### 步骤6：安装IntelliJ IDEA
```bash
# 下载IntelliJ IDEA
# 访问：https://www.jetbrains.com/idea/download/
# 下载macOS版本并安装

# 安装必需插件
# IntelliJ IDEA -> Preferences -> Plugins
# 搜索并安装：Lombok, Maven Helper, SonarLint
```

#### 步骤7：克隆项目并启动
```bash
# 克隆项目
git clone <repository-url>
cd spring-ai-backend

# 配置环境变量
echo 'export DASHSCOPE_API_KEY="your-api-key"' >> ~/.zshrc
source ~/.zshrc

# 启动后端
mvn spring-boot:run

# 新开终端，启动前端
cd ..
npm install
npm run dev
```

### 12.3 开发环境搭建（Ubuntu）

#### 步骤1：更新系统
```bash
sudo apt update
sudo apt upgrade -y
```

#### 步骤2：安装JDK
```bash
# 安装OpenJDK 17
sudo apt install openjdk-17-jdk -y

# 验证安装
java -version
```

#### 步骤3：安装Maven
```bash
# 安装Maven
sudo apt install maven -y

# 验证安装
mvn -version
```

#### 步骤4：安装MySQL
```bash
# 安装MySQL
sudo apt install mysql-server -y

# 启动MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# 配置root密码
sudo mysql_secure_installation

# 创建数据库
sudo mysql -u root -p
CREATE DATABASE ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

#### 步骤5：安装Node.js
```bash
# 安装Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

# 验证安装
node -version
npm -version
```

#### 步骤6：安装Git
```bash
# 安装Git
sudo apt install git -y

# 验证安装
git --version
```

#### 步骤7：克隆项目并启动
```bash
# 克隆项目
git clone <repository-url>
cd spring-ai-backend

# 配置环境变量
echo 'export DASHSCOPE_API_KEY="your-api-key"' >> ~/.bashrc
source ~/.bashrc

# 启动后端
mvn spring-boot:run

# 新开终端，启动前端
cd ..
npm install
npm run dev
```

### 12.4 验证环境搭建

#### 后端验证
```bash
# 检查后端服务
curl http://localhost:8080/api/actuator/health

# 访问Swagger文档
# 浏览器打开：http://localhost:8080/api/swagger-ui.html
```

#### 前端验证
```bash
# 检查前端服务
curl http://localhost:8081

# 浏览器打开
# http://localhost:8081
```

#### 数据库验证
```bash
# 连接数据库
mysql -u root -p ai_hotel_dev

# 检查表
SHOW TABLES;

# 检查用户表
SELECT * FROM users;

EXIT;
```

---

## 附录

### A. 常见问题

**Q1: Maven依赖下载失败怎么办？**
A: 配置国内镜像源，编辑 `~/.m2/settings.xml`：
```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <name>Aliyun Maven</name>
    <url>https://maven.aliyun.com/repository/public</url>
  </mirror>
</mirrors>
```

**Q2: npm包下载失败怎么办？**
A: 配置国内镜像源：
```bash
npm config set registry https://registry.npmmirror.com
```

**Q3: 数据库连接失败怎么办？**
A: 检查以下几点：
1. MySQL服务是否启动
2. 用户名和密码是否正确
3. 数据库是否存在
4. 防火墙是否开放3306端口

**Q4: 阿里云API调用失败怎么办？**
A: 检查以下几点：
1. API密钥是否正确
2. 网络连接是否正常
3. 账户余额是否充足
4. API配额是否用尽

### B. 参考资源

- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Spring AI官方文档](https://spring.io/projects/spring-ai)
- [阿里云通义大模型API文档](https://help.aliyun.com/zh/dashscope/)
- [Vue.js官方文档](https://vuejs.org/)
- [MySQL官方文档](https://dev.mysql.com/doc/)

### C. 联系方式

如有问题，请联系：
- 技术支持：support@aihotel.com
- 项目负责人：tech-lead@aihotel.com

---

**文档版本**: 1.0.0  
**最后更新**: 2026-01-20  
**维护者**: AI Hotel Team
