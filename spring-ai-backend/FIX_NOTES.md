# Spring AI依赖包问题修复说明

## 📋 问题描述

### 错误信息
```
java: 程序包org.springframework.ai.dashscope不存在
```

### 问题原因
1. **Spring AI版本不匹配**：pom.xml中使用了不兼容的Spring AI依赖版本
2. **包名变更**：Spring AI的包结构在1.0.0-M4版本中发生了变化
3. **API变更**：阿里云DashScope SDK的包名和使用方式发生了变更

## 🔧 修复内容

### 1. pom.xml更新

#### 修改前
```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-openai-spring-boot-starter</artifactId>
    <version>1.0.0-M4</version>
</dependency>
<dependency>
    <groupId>com.alibaba.cloud.ai</groupId>
    <artifactId>spring-ai-alibaba-starter</artifactId>
    <version>1.0.0-M2</version>
</dependency>
```

#### 修改后
```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-openai-spring-boot-starter</artifactId>
    <version>1.0.0-M4</version>
</dependency>
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>aliyun-java-sdk-core</artifactId>
    <version>4.6.4</version>
</dependency>
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>aliyun-java-sdk-dashscope</artifactId>
    <version>2.15.2</version>
</dependency>
```

**变更说明**：
- 移除了 `com.alibaba.cloud.ai:spring-ai-alibaba-starter` 依赖（版本不兼容）
- 保留了 `org.springframework.ai:spring-ai-openai-spring-boot-starter` 依赖
- 添加了阿里云DashScope SDK的直接依赖

### 2. DashScopeConfig.java更新

#### 修改前
```java
import com.alibaba.cloud.ai.dashscope.DashScopeApi;
import com.alibaba.cloud.ai.dashscope.DashScopeChatModel;
import com.alibaba.cloud.ai.dashscope.DashScopeChatOptions;
```

#### 修改后
```java
import com.aliyun.dashscope.aigc.generation.Generation;
import com.aliyun.dashscope.aigc.generation.GenerationParam;
import com.aliyun.dashscope.aigc.generation.GenerationResult;
import com.aliyun.dashscope.sdk.aigc.generations.GenerationService;
```

**变更说明**：
- 使用阿里云DashScope SDK的官方包名
- 直接使用 `GenerationService` 进行API调用
- 移除了Spring AI的抽象层，直接使用SDK

### 3. AiChatService.java更新

#### 修改前
```java
import org.springframework.ai.dashscope.DashScopeChatModel;
import org.springframework.ai.dashscope.DashScopeChatOptions;
```

#### 修改后
```java
import com.aliyun.dashscope.aigc.generation.Generation;
import com.aliyun.dashscope.aigc.generation.GenerationParam;
import com.aliyun.dashscope.aigc.generation.GenerationResult;
import com.aliyun.dashscope.sdk.aigc.generations.GenerationService;
```

**变更说明**：
- 使用阿里云DashScope SDK的官方API
- 实现了完整的消息构建逻辑
- 添加了系统提示词（SYSTEM_PROMPT）
- 实现了重试机制（@Retryable）
- 支持同步、异步和流式调用

### 4. 测试文件更新

#### AiChatServiceTest.java
- 更新了导入语句以匹配新的API
- 使用Mock对象进行单元测试
- 添加了完整的测试用例

#### AiChatControllerTest.java
- 更新了导入语句
- 添加了完整的API端点测试

## 📦 依赖说明

### 阿里云DashScope SDK

| 依赖 | 版本 | 用途 |
|------|------|------|
| aliyun-java-sdk-core | 4.6.4 | 阿里云SDK核心库 |
| aliyun-java-sdk-dashscope | 2.15.2 | 通义大模型SDK |

### Spring AI

| 依赖 | 版本 | 用途 |
|------|------|------|
| spring-ai-openai-spring-boot-starter | 1.0.0-M4 | Spring AI核心功能（保留用于扩展性） |

## 🚀 使用说明

### 1. 配置API密钥

在 `application-dev.yml` 中配置：
```yaml
aliyun:
  dashscope:
    api-key: ${DASHSCOPE_API_KEY:your-dev-api-key}
    model: qwen-turbo
    timeout: 30000
```

或通过环境变量设置：
```bash
export DASHSCOPE_API_KEY=sk-xxxxxxxxxxxx
```

### 2. 启动应用

```bash
cd spring-ai-backend
mvn clean install
mvn spring-boot:run
```

### 3. 验证修复

访问健康检查端点：
```bash
curl http://localhost:8080/api/actuator/health
```

预期响应：
```json
{
  "status": "UP"
}
```

## 🔍 API使用示例

### 同步调用

```java
ChatRequest request = ChatRequest.builder()
    .content("帮我分析一下今天的客房入住情况")
    .temperature(0.7)
    .maxTokens(2000)
    .build();

ChatResponse response = aiChatService.chat(request);
```

### 异步调用

```java
CompletableFuture<ChatResponse> future = aiChatService.chatAsync(request);
ChatResponse response = future.get();
```

### 带历史记录的调用

```java
List<ChatRequest.ChatMessage> history = List.of(
    ChatRequest.ChatMessage.builder()
        .role("user")
        .content("你好")
        .build(),
    ChatRequest.ChatMessage.builder()
        .role("assistant")
        .content("你好！有什么我可以帮助你的吗？")
        .build()
);

ChatRequest request = ChatRequest.builder()
    .content("帮我分析一下今天的客房入住情况")
    .messages(history)
    .build();

ChatResponse response = aiChatService.chat(request);
```

## ⚠️ 注意事项

### 1. API密钥安全
- 不要将API密钥提交到版本控制系统
- 使用环境变量或密钥管理服务
- 定期轮换API密钥

### 2. 错误处理
- 所有API调用都包含在try-catch块中
- 实现了重试机制（最多3次）
- 返回详细的错误信息

### 3. 性能考虑
- 使用异步调用处理长时间运行的请求
- 设置合理的超时时间（默认30秒）
- 监控API调用次数和Token使用量

### 4. Token统计
- DashScope API目前不提供详细的Token统计
- response中的promptTokens、completionTokens、totalTokens暂时为null
- 后续可以通过API响应解析获取更详细的信息

## 📈 测试验证

### 运行单元测试

```bash
cd spring-ai-backend
mvn test
```

预期结果：
- 所有测试用例通过
- 覆盖率 > 80%

### 运行集成测试

```bash
cd spring-ai-backend
mvn verify
```

预期结果：
- 应用正常启动
- API端点可访问
- 数据库连接正常

## 🔗 相关资源

### 阿里云DashScope文档
- 官方文档：https://help.aliyun.com/zh/dashscope/
- SDK文档：https://github.com/aliyun/alibabacloud-dashscope-sdk

### Spring AI文档
- 官方文档：https://spring.io/projects/spring-ai

## 📞 技术支持

如有问题，请联系：
- 技术支持：support@aihotel.com
- API问题：api-support@aihotel.com
- DashScope问题：dashscope-support@aliyun.com

---

**修复版本**: 1.0.0  
**修复日期**: 2026-01-20  
**维护者**: AI Hotel Team
