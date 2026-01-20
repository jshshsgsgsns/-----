# 环境配置快速参考

## 📋 环境对比总览

| 配置项 | 开发环境 | 测试环境 | 生产环境 |
|--------|---------|---------|---------|
| **操作系统** | Windows/macOS/Ubuntu | Ubuntu/CentOS | Ubuntu/CentOS |
| **JDK版本** | 17 | 17 | 17 |
| **Maven版本** | 3.6.0+ | 3.6.0+ | 3.8.0+ |
| **MySQL版本** | 8.0.33+ | 8.0.33+ | 8.0.33+ |
| **Node.js版本** | 14.x/16.x/18.x | 不需要 | 不需要 |
| **CPU** | 4核 | 8核 | 16核+ |
| **内存** | 8GB | 16GB | 32GB+ |
| **硬盘** | 50GB SSD | 100GB SSD | 500GB SSD+ |
| **应用端口** | 8080 | 8080 | 8080 |
| **数据库端口** | 3306 | 3306 | 3306 |
| **JVM堆内存** | 512m-1024m | 1024m-2048m | 2048m-4096m |
| **连接池大小** | 10 | 15 | 20 |
| **日志级别** | DEBUG | INFO | WARN/ERROR |
| **DDL策略** | update | validate | none |

---

## 🔑 必需环境变量

```bash
# 所有环境必需
DASHSCOPE_API_KEY=sk-xxxxxxxxxxxx
DB_URL=jdbc:mysql://localhost:3306/ai_hotel
DB_USERNAME=root
DB_PASSWORD=your_password
SPRING_PROFILES_ACTIVE=dev|test|prod
```

---

## 📦 核心依赖版本

### 后端
```xml
<spring-boot.version>3.2.0</spring-boot.version>
<spring-ai.version>1.0.0-M4</spring-ai.version>
<aliyun-java-sdk-core.version>4.6.4</aliyun-java-sdk-core.version>
<aliyun-java-sdk-dashscope.version>2.15.2</aliyun-java-sdk-dashscope.version>
<swagger.version>2.2.0</swagger.version>
<lombok.version>1.18.30</lombok.version>
<mysql-connector.version>8.0.33</mysql-connector.version>
```

### 前端
```json
{
  "vue": "^2.6.14",
  "vue-router": "^3.5.3",
  "vuex": "^3.6.2",
  "axios": "^1.4.0",
  "element-ui": "^2.15.14",
  "js-md5": "^0.7.3"
}
```

---

## 🌐 端口配置

| 服务 | 开发环境 | 测试环境 | 生产环境 |
|------|---------|---------|---------|
| HTTP | 8081 | - | 80 |
| HTTPS | - | - | 443 |
| 应用服务 | 8080 | 8080 | 8080 |
| MySQL | 3306 | 3306 | 3306 |
| SSH | - | - | 22 |
| Redis（可选） | - | - | 6379 |

---

## 🚀 快速启动命令

### 开发环境
```bash
# 后端
cd spring-ai-backend
export DASHSCOPE_API_KEY=your-api-key
mvn spring-boot:run

# 前端（新终端）
cd ..
npm install
npm run dev
```

### 测试环境
```bash
# 后端
cd spring-ai-backend
export SPRING_PROFILES_ACTIVE=test
mvn clean package
java -jar target/spring-ai-backend-1.0.0.jar
```

### 生产环境
```bash
# 后端
cd spring-ai-backend
export SPRING_PROFILES_ACTIVE=prod
mvn clean package -DskipTests
nohup java -jar \
  -Xms2048m -Xmx4096m \
  -XX:+UseG1GC \
  target/spring-ai-backend-1.0.0.jar \
  > /var/log/ai-hotel/application.log 2>&1 &
```

---

## 🛠️ 开发工具推荐

### 后端开发
- **IDE**: IntelliJ IDEA 2022.3+
- **插件**: Lombok, Maven Helper, SonarLint
- **数据库工具**: MySQL Workbench / DBeaver
- **API测试**: Postman / Insomnia

### 前端开发
- **IDE**: VSCode 1.70+ / WebStorm 2022.3+
- **插件**: Vetur, ESLint, Prettier
- **浏览器**: Chrome / Firefox（开发者工具）

### 版本控制
- **工具**: Git 2.40+
- **平台**: GitHub / GitLab
- **客户端**: GitHub Desktop / SourceTree

---

## 🔍 健康检查端点

```bash
# 应用健康检查
curl http://localhost:8080/api/actuator/health

# 预期响应
{
  "status": "UP"
}
```

---

## 📊 性能监控指标

| 指标 | 开发环境 | 测试环境 | 生产环境 |
|------|---------|---------|---------|
| 响应时间 | < 2s | < 1s | < 500ms |
| 并发用户 | 10 | 100 | 1000+ |
| QPS | 10 | 100 | 1000+ |
| 可用性 | 95% | 99% | 99.9% |

---

## 📝 配置文件路径

| 环境 | 配置文件 | 路径 |
|------|---------|------|
| 开发 | application-dev.yml | src/main/resources/ |
| 测试 | application-test.yml | src/main/resources/ |
| 生产 | application-prod.yml | src/main/resources/ |

---

## 🔒 安全配置清单

- [ ] 所有敏感信息通过环境变量配置
- [ ] 生产环境使用HTTPS
- [ ] 数据库密码使用强密码
- [ ] API密钥定期轮换
- [ ] 启用防火墙规则
- [ ] 配置CORS白名单
- [ ] 启用审计日志
- [ ] 定期更新依赖包

---

## 📞 快速联系

| 问题类型 | 联系方式 |
|---------|---------|
| 技术问题 | support@aihotel.com |
| 环境配置 | devops@aihotel.com |
| API问题 | api-support@aihotel.com |
| 紧急问题 | emergency@aihotel.com |

---

**版本**: 1.0.0  
**更新日期**: 2026-01-20
