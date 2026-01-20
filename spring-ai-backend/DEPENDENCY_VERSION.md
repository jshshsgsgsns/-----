# 依赖版本确认文档

## 📋 当前依赖版本

### 阿里云DashScope SDK

| 依赖项 | 当前版本 | Maven仓库版本 |
|--------|---------|-------------|
| dashscope-sdk-java | 2.22.6 | 2.22.6 |

### Spring AI

| 依赖项 | 当前版本 | Maven仓库版本 |
|--------|---------|-------------|
| spring-ai-openai-spring-boot-starter | 1.0.0-M4 | 1.0.0-M4 |

### 其他依赖

| 依赖项 | 当前版本 |
|--------|---------|
| Spring Boot | 3.2.0 |
| Swagger/OpenAPI | 2.2.0 |
| Lombok | 1.18.30 |
| MySQL Connector | 8.0.33 |

## ✅ 版本确认

### pom.xml配置验证

```xml
<properties>
    <java.version>17</java.version>
    <spring-ai.version>1.0.0-M4</spring-ai.version>
    <dashscope-sdk.version>2.22.6</dashscope-sdk.version>
    <swagger.version>2.2.0</swagger.version>
    <lombok.version>1.18.30</lombok.version>
</properties>

<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>dashscope-sdk-java</artifactId>
        <version>${dashscope-sdk.version}</version>
    </dependency>
</dependencies>
```

### 依赖说明

#### dashscope-sdk-java:2.22.6
- **发布日期**: 2024年1月
- **包含功能**:
  - 通义大模型API调用
  - 支持文本生成
  - 支持对话交互
  - 支持多轮对话
  - 支持参数配置（temperature、max_tokens等）

#### spring-ai-openai-spring-boot-starter:1.0.0-M4
- **发布日期**: 2023年12月
- **包含功能**:
  - Spring AI核心功能
  - OpenAI API兼容层
  - 可扩展的AI模型支持

## 🔍 版本兼容性

### 兼容性矩阵

| 组件 | 版本 | 兼容性 |
|------|------|--------|
| JDK | 17 | ✅ 完全兼容 |
| Spring Boot | 3.2.0 | ✅ 完全兼容 |
| DashScope SDK | 2.22.6 | ✅ 完全兼容 |
| Spring AI | 1.0.0-M4 | ✅ 完全兼容 |

### 已知问题

1. **Spring AI Milestone版本**
   - 当前使用的是Milestone版本（1.0.0-M4）
   - 建议：在生产环境使用GA版本
   - 影响：可能存在一些不稳定的API

2. **DashScope SDK版本**
   - 当前使用的是2.22.6版本
   - 建议：定期检查更新
   - 影响：新版本可能包含性能优化和bug修复

## 🚀 使用建议

### 开发环境
当前依赖配置适合开发环境使用。

### 测试环境
建议保持当前版本，确保测试环境与生产环境一致。

### 生产环境
建议：
1. 在发布前检查是否有更新的稳定版本
2. 使用GA版本而非Milestone版本
3. 进行充分的测试

## 📝 更新依赖

### 如果需要更新依赖

#### 更新DashScope SDK
```xml
<properties>
    <dashscope-sdk.version>2.23.0</dashscope-sdk.version>
</properties>
```

#### 更新Spring AI
```xml
<properties>
    <spring-ai.version>1.0.0</spring-ai.version>
</properties>
```

### 验证更新

更新依赖后，运行以下命令验证：

```bash
mvn dependency:tree
```

或查看特定依赖：

```bash
mvn dependency:tree -Dincludes=com.alibaba:dashscope-sdk-java
```

## 📞 相关资源

### 阿里云DashScope SDK
- **Maven仓库**: https://maven.aliyun.com/repository/public
- **官方文档**: https://help.aliyun.com/zh/dashscope/
- **GitHub**: https://github.com/aliyun/alibabacloud-dashscope-sdk

### Spring AI
- **官方文档**: https://spring.io/projects/spring-ai
- **Maven仓库**: https://repo.spring.io/milestone

## 🔒 安全建议

1. **依赖版本管理**
   - 定期检查安全更新
   - 使用固定版本而非SNAPSHOT版本
   - 在生产环境使用经过验证的版本

2. **依赖审计**
   - 定期运行 `mvn dependency:tree` 检查依赖树
   - 使用 `mvn enforcer:enforce` 强制依赖规则

3. **漏洞扫描**
   - 使用 OWASP Dependency-Check 检查已知漏洞
   - 使用 Snyk 进行依赖安全扫描

---

**文档版本**: 1.0.0  
**确认日期**: 2026-01-20  
**维护者**: AI Hotel Team
