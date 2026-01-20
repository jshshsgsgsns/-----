# Spring Boot + Spring AI 酒店管理系统

这是一个基于Spring Boot框架集成Spring AI组件，实现与阿里云通义大模型服务对接的完整应用程序。

## 项目特性

- ✅ 配置管理模块：支持通过环境变量、配置文件进行API凭证管理
- ✅ AI能力接口模块：基于Spring AI封装文本生成、对话交互等基础AI能力
- ✅ 数据模型层：完整的请求/响应数据模型，包含输入参数验证、输出结果格式化
- ✅ 异常处理机制：全局统一的异常处理策略，提供明确的错误码与友好的错误提示
- ✅ 分层架构：清晰的Controller、Service、Repository分层架构
- ✅ 前端实现：完整的Vue.js前端界面，实现文本输入、结果展示、对话历史记录等功能
- ✅ 多环境配置：支持dev/test/prod多环境配置文件分离
- ✅ Swagger文档：集成Swagger/OpenAPI文档自动生成
- ✅ 测试策略：全面的单元测试与集成测试

## 技术栈

### 后端
- Spring Boot 3.2.0
- Spring AI 1.0.0-M4
- Spring Cloud Alibaba AI 1.0.0-M2
- Spring Data JPA
- Spring Security
- MySQL
- Maven

### 前端
- Vue.js 2.x
- Element UI
- Axios

## 项目结构

```
spring-ai-backend/
├── src/
│   ├── main/
│   │   ├── java/com/ai/hotel/
│   │   │   ├── config/           # 配置类
│   │   │   ├── controller/        # 控制器层
│   │   │   ├── service/          # 服务层
│   │   │   ├── repository/        # 数据访问层
│   │   │   ├── model/            # 数据模型
│   │   │   │   ├── dto/          # 数据传输对象
│   │   │   │   └── entity/      # 实体类
│   │   │   ├── exception/        # 异常处理
│   │   │   └── AiHotelApplication.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-test.yml
│   │       └── application-prod.yml
│   └── test/                    # 测试代码
└── pom.xml
```

## 快速开始

### 前置要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Node.js 14+ (用于前端)

### 后端配置

1. 克隆项目
```bash
git clone <repository-url>
cd spring-ai-backend
```

2. 配置数据库
```sql
CREATE DATABASE ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. 配置阿里云通义大模型API密钥
在 `application-dev.yml` 中配置：
```yaml
aliyun:
  dashscope:
    api-key: ${DASHSCOPE_API_KEY:your-api-key}
```

或者通过环境变量设置：
```bash
export DASHSCOPE_API_KEY=your-api-key
```

4. 运行项目
```bash
mvn spring-boot:run
```

项目将在 `http://localhost:8080/api` 启动

### 前端配置

1. 进入前端目录
```bash
cd ..
npm install
```

2. 启动开发服务器
```bash
npm run dev
```

前端将在 `http://localhost:8081` 启动

## API文档

启动后端服务后，访问Swagger文档：
```
http://localhost:8080/api/swagger-ui.html
```

## 主要API端点

### AI聊天接口
- `POST /api/ai/chat` - 同步聊天
- `POST /api/ai/chat/async` - 异步聊天
- `POST /api/ai/chat/stream` - 流式聊天

### 认证接口
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录

### 用户管理接口
- `GET /api/users/{id}` - 获取用户信息
- `PUT /api/users/{id}` - 更新用户信息
- `POST /api/users/{id}/verify-phone` - 验证电话号码
- `POST /api/users/{id}/verify-email` - 验证邮箱

### 聊天历史接口
- `POST /api/chat/sessions` - 创建新会话
- `GET /api/chat/sessions/{userId}` - 获取用户会话列表
- `PUT /api/chat/sessions/{sessionId}/title` - 更新会话标题
- `DELETE /api/chat/sessions/{sessionId}` - 删除会话
- `GET /api/chat/sessions/{sessionId}/messages` - 获取会话消息

## 测试

运行单元测试：
```bash
mvn test
```

运行集成测试：
```bash
mvn verify
```

## 环境变量

| 变量名 | 说明 | 示例 |
|--------|------|------|
| DASHSCOPE_API_KEY | 阿里云通义大模型API密钥 | sk-xxxxx |
| DB_URL | 数据库连接URL | jdbc:mysql://localhost:3306/ai_hotel |
| DB_USERNAME | 数据库用户名 | root |
| DB_PASSWORD | 数据库密码 | password |

## 安全说明

- 所有API密钥和敏感信息应通过环境变量配置
- 生产环境应使用HTTPS
- 建议使用JWT进行身份验证
- 定期更新依赖包以修复安全漏洞

## 许可证

Apache License 2.0

## 联系方式

如有问题，请联系：support@aihotel.com
