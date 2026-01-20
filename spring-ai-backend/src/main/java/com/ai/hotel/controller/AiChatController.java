package com.ai.hotel.controller;

import com.ai.hotel.model.dto.ApiResponse;
import com.ai.hotel.model.dto.ChatRequest;
import com.ai.hotel.model.dto.ChatResponse;
import com.ai.hotel.service.AiChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
@Tag(name = "AI聊天接口", description = "提供与阿里云通义大模型的交互接口")
public class AiChatController {

    private final AiChatService aiChatService;

    @PostMapping(value = "/chat", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "发送聊天消息", description = "同步方式发送消息并获取AI回复")
    public ApiResponse<ChatResponse> chat(@Valid @RequestBody ChatRequest request) {
        log.info("Received chat request: {}", request.getContent());
        ChatResponse response = aiChatService.chat(request);
        return ApiResponse.success(response);
    }

    @PostMapping(value = "/chat/async", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "异步发送聊天消息", description = "异步方式发送消息并获取AI回复")
    public ApiResponse<String> chatAsync(@Valid @RequestBody ChatRequest request) {
        log.info("Received async chat request: {}", request.getContent());
        aiChatService.chatAsync(request).thenAccept(response -> {
            log.info("Async chat completed: {}", response.getContent());
        });
        return ApiResponse.success("消息已发送，正在处理中...");
    }

    @PostMapping(value = "/chat/stream", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "流式发送聊天消息", description = "流式方式发送消息并获取AI回复")
    public ApiResponse<ChatResponse> streamChat(@Valid @RequestBody ChatRequest request) {
        log.info("Received stream chat request: {}", request.getContent());
        ChatResponse response = aiChatService.streamChat(request);
        return ApiResponse.success(response);
    }

}
