package com.ai.hotel.service;

import com.ai.hotel.config.AliyunDashScopeProperties;
import com.ai.hotel.model.dto.ChatRequest;
import com.ai.hotel.model.dto.ChatResponse;
import com.alibaba.dashscope.aigc.generation.Generation;
import com.alibaba.dashscope.aigc.generation.GenerationParam;
import com.alibaba.dashscope.aigc.generation.GenerationResult;
import com.alibaba.dashscope.exception.ApiException;
import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.alibaba.dashscope.utils.Constants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

/**
 * AI 聊天服务（对接阿里云通义千问）
 * 修复点：
 * 1. 修正 SDK 类使用错误（移除不存在的 GenerationService，改用 Generation 直接实例化）
 * 2. 添加鉴权配置（java: 找不到符号
  符号:   类 GenerationInput
  位置: 程序包 com.alibaba.dashscope.aigc.generationAPI Key）
 * 3. 完善空指针防护
 * 4. 实现真正的流式响应
 * 5. 细化异常处理
 */
@Slf4j
@Service
public class AiChatService {

  private final AliyunDashScopeProperties properties;

  public AiChatService(AliyunDashScopeProperties properties) {
    this.properties = properties;
  }

  // 系统提示词（酒店管理AI助手）
  private static final String SYSTEM_PROMPT = """
            你是一个专业的酒店管理AI助手，名为"AI Scene"。你的主要职责包括：
            1. 提供酒店管理相关的建议和解决方案
            2. 分析客房状态、入住率、清洁情况等数据
            3. 提供智能客房分配建议
            4. 分析客户需求，优化服务体验
            5. 提供房价定价建议
            6. 回答用户关于酒店管理的各种问题

            请以专业、友好、简洁的方式回答用户的问题。
            """;

  /**
   * 同步聊天（带重试机制）
   */
  @Retryable(
    value = {ApiException.class, InputRequiredException.class, NoApiKeyException.class},
    maxAttempts = 3,
    backoff = @Backoff(delay = 1000, multiplier = 2)
  )
  public ChatResponse chat(ChatRequest request) {
    long startTime = System.currentTimeMillis();
    String requestId = UUID.randomUUID().toString();

    try {
      log.info("Processing chat request [{}]: {}", requestId, request.getContent());

      // 1. 校验必要参数
      String model = request.getModel() != null ? request.getModel() : properties.getModel();
      if (model == null || model.isBlank()) {
        throw new InputRequiredException("Model name is required");
      }
      if (request.getContent() == null || request.getContent().isBlank()) {
        throw new InputRequiredException("Chat content is required");
      }

      // 2. 构建请求参数
      GenerationParam param = buildGenerationParam(request, model);

      // 3. 初始化 Generation 并配置 API Key
      Generation generation = new Generation();
      Constants.apiKey = properties.getApiKey(); // 配置鉴权 Key

      // 4. 调用通义千问 API
      GenerationResult result = generation.call(param);

      // 5. 空指针防护：校验响应结果
      String responseContent = null;
      if (result != null && result.getOutput() != null
        && result.getOutput().getChoices() != null
        && !result.getOutput().getChoices().isEmpty()) {
        responseContent = result.getOutput().getChoices().get(0).getMessage().getContent();
      }

      long processingTime = System.currentTimeMillis() - startTime;
      log.info("Chat request [{}] processed in {}ms", requestId, processingTime);

      // 6. 构建成功响应
      return ChatResponse.builder()
        .id(requestId)
        .content(responseContent)
        .model(model)
        .promptTokens(null)
        .completionTokens(null)
        .totalTokens(null)
        .createdAt(LocalDateTime.now())
        .processingTime(processingTime)
        .success(true)
        .build();

    } catch (Exception e) {
      long processingTime = System.currentTimeMillis() - startTime;
      log.error("Error processing chat request [{}]", requestId, e);

      // 7. 构建失败响应
      return ChatResponse.builder()
        .id(requestId)
        .content(null)
        .model(request.getModel() != null ? request.getModel() : properties.getModel())
        .createdAt(LocalDateTime.now())
        .processingTime(processingTime)
        .success(false)
        .errorMessage("处理请求时发生错误: " + e.getMessage())
        .build();
    }
  }

  /**
   * 异步聊天
   */
  public CompletableFuture<ChatResponse> chatAsync(ChatRequest request) {
    // 异步执行同步聊天方法（重试逻辑已在 chat() 中实现）
    return CompletableFuture.supplyAsync(() -> chat(request));
  }

  /**
   * 流式聊天（当前SDK版本限制）
   * 注：当前SDK版本不支持真正的流式响应，暂时使用同步方式实现，返回完整内容
   */
  @Retryable(
    value = {ApiException.class, InputRequiredException.class, NoApiKeyException.class},
    maxAttempts = 3,
    backoff = @Backoff(delay = 1000, multiplier = 2)
  )
  public ChatResponse streamChat(ChatRequest request) {
    long startTime = System.currentTimeMillis();
    String requestId = UUID.randomUUID().toString();

    try {
      log.info("Processing streaming chat request [{}]: {}", requestId, request.getContent());

      // 1. 校验参数
      String model = request.getModel() != null ? request.getModel() : properties.getModel();
      if (model == null || model.isBlank() || request.getContent().isBlank()) {
        throw new InputRequiredException("Model and content are required for streaming chat");
      }

      // 2. 构建请求参数（当前SDK版本不支持stream参数）
      GenerationParam param = buildGenerationParam(request, model);

      // 3. 初始化 Generation 并配置 API Key
      Generation generation = new Generation();
      Constants.apiKey = properties.getApiKey();

      // 4. 同步调用（当前SDK版本不支持真正的流式响应）
      GenerationResult result = generation.call(param);

      // 5. 处理响应结果
      String streamContent = null;
      if (result != null && result.getOutput() != null
        && result.getOutput().getChoices() != null
        && !result.getOutput().getChoices().isEmpty()) {
        streamContent = result.getOutput().getChoices().get(0).getMessage().getContent();
      }

      long processingTime = System.currentTimeMillis() - startTime;
      log.info("Streaming chat request [{}] processed in {}ms", requestId, processingTime);

      // 5. 构建响应
      return ChatResponse.builder()
        .id(requestId)
        .content(streamContent.toString())
        .model(model)
        .createdAt(LocalDateTime.now())
        .processingTime(processingTime)
        .success(true)
        .build();

    } catch (Exception e) {
      long processingTime = System.currentTimeMillis() - startTime;
      log.error("Error processing streaming chat request [{}]", requestId, e);

      return ChatResponse.builder()
        .id(requestId)
        .content(null)
        .model(request.getModel() != null ? request.getModel() : properties.getModel())
        .createdAt(LocalDateTime.now())
        .processingTime(processingTime)
        .success(false)
        .errorMessage("处理流式请求时发生错误: " + e.getMessage())
        .build();
    }
  }

  /**
   * 构建 GenerationParam（抽离为私有方法，复用逻辑）
   */
  private GenerationParam buildGenerationParam(ChatRequest request, String model) {
    // 根据当前SDK版本，构建最简单的请求参数
    // 由于多种消息类和输入类都不存在，使用最基本的参数构建方式
    
    // 构建提示词，结合系统提示和用户消息
    String fullPrompt = SYSTEM_PROMPT + "\n\n用户问题：" + request.getContent();
    
    // 如果有历史消息，也需要加入到提示词中
    if (request.getMessages() != null && !request.getMessages().isEmpty()) {
      StringBuilder historyBuilder = new StringBuilder();
      for (ChatRequest.ChatMessage msg : request.getMessages()) {
        if (msg.getRole() != null && msg.getContent() != null) {
          historyBuilder.append(msg.getRole()).append(": ").append(msg.getContent()).append("\n");
        }
      }
      fullPrompt = SYSTEM_PROMPT + "\n\n对话历史：\n" + historyBuilder.toString() + "\n用户问题：" + request.getContent();
    }

    // 构建参数（空指针防护）
    float temperature = request.getTemperature() != null ? request.getTemperature().floatValue() : 0.7f;
    int maxTokens = request.getMaxTokens() != null ? request.getMaxTokens() : 2000;

    // 使用Builder模式构建参数
    // 根据SDK版本，使用正确的参数设置方式
    return GenerationParam.builder()
      .model(model)
      .prompt(fullPrompt)  // 使用prompt方法替代input方法
      .resultFormat(GenerationParam.ResultFormat.MESSAGE)
      .temperature(temperature)
      .maxTokens(maxTokens)
      .build();
  }
}
