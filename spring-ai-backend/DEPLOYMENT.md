# Spring Boot + Spring AI 酒店管理系统 - 部署指南

## 开发环境部署

### 1. 数据库配置

```bash
# 登录MySQL
mysql -u root -p

# 执行初始化脚本
source spring-ai-backend/src/main/resources/schema.sql
```

### 2. 后端启动

```bash
cd spring-ai-backend

# 配置环境变量
export DASHSCOPE_API_KEY=your-api-key

# 启动应用
mvn spring-boot:run
```

### 3. 前端启动

```bash
# 在项目根目录
npm install
npm run dev
```

## 生产环境部署

### 1. 打包应用

```bash
cd spring-ai-backend
mvn clean package -DskipTests
```

### 2. 配置生产环境变量

创建 `.env` 文件：
```env
DASHSCOPE_API_KEY=your-production-api-key
DB_URL=jdbc:mysql://your-db-host:3306/ai_hotel_prod
DB_USERNAME=your-db-user
DB_PASSWORD=your-db-password
```

### 3. 使用Docker部署

创建 `Dockerfile`：
```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/spring-ai-backend-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

构建并运行：
```bash
docker build -t ai-hotel-backend .
docker run -d -p 8080:8080 --env-file .env ai-hotel-backend
```

### 4. 使用Nginx反向代理

配置Nginx：
```nginx
server {
    listen 80;
    server_name api.aihotel.com;

    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 监控与日志

### 日志配置

在 `application-prod.yml` 中配置：
```yaml
logging:
  file:
    name: logs/ai-hotel.log
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
  level:
    root: ERROR
    com.ai.hotel: WARN
```

### 健康检查

Spring Boot Actuator健康检查端点：
```
http://localhost:8080/api/actuator/health
```

## 性能优化

### JVM参数优化

```bash
java -Xms512m -Xmx1024m -XX:+UseG1GC -jar app.jar
```

### 数据库连接池配置

在 `application-prod.yml` 中：
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

## 安全加固

1. 启用HTTPS
2. 配置防火墙规则
3. 定期更新依赖
4. 使用强密码策略
5. 启用审计日志

## 备份策略

### 数据库备份

```bash
# 每日备份
mysqldump -u root -p ai_hotel_prod > backup_$(date +%Y%m%d).sql
```

### 应用备份

```bash
# 备份应用配置和日志
tar -czf backup_$(date +%Y%m%d).tar.gz logs/ config/
```

## 故障排查

### 常见问题

1. **API调用失败**
   - 检查DASHSCOPE_API_KEY是否正确
   - 检查网络连接
   - 查看日志中的错误信息

2. **数据库连接失败**
   - 检查数据库服务是否运行
   - 验证连接参数
   - 检查防火墙设置

3. **内存不足**
   - 增加JVM堆内存
   - 优化数据库查询
   - 检查内存泄漏
