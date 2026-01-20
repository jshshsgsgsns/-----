package com.ai.hotel.controller;

import com.ai.hotel.model.dto.ApiResponse;
import com.ai.hotel.model.dto.ChatRequest;
import com.ai.hotel.model.dto.ChatResponse;
import com.ai.hotel.service.AiChatService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@AutoConfigureWebMvc
@AutoConfigureMockMvc
class AiChatControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @org.mockito.Mock
    private AiChatService aiChatService;

    @Test
    void testChat_Success() throws Exception {
        ChatRequest request = ChatRequest.builder()
                .content("测试消息")
                .temperature(0.7)
                .build();

        ChatResponse mockResponse = ChatResponse.builder()
                .id("test-id")
                .content("测试回复")
                .model("qwen-turbo")
                .success(true)
                .build();

        when(aiChatService.chat(any(ChatRequest.class))).thenReturn(mockResponse);

        mockMvc.perform(post("/api/ai/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.message").value("操作成功"))
                .andExpect(jsonPath("$.data.content").value("测试回复"));
    }

    @Test
    void testChat_InvalidRequest() throws Exception {
        ChatRequest request = ChatRequest.builder()
                .content("")
                .build();

        mockMvc.perform(post("/api/ai/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void testChatAsync_Success() throws Exception {
        ChatRequest request = ChatRequest.builder()
                .content("异步测试消息")
                .build();

        mockMvc.perform(post("/api/ai/chat/async")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.message").value("消息已发送，正在处理中..."));
    }

    @Test
    void testChatStream_Success() throws Exception {
        ChatRequest request = ChatRequest.builder()
                .content("流式测试消息")
                .build();

        ChatResponse mockResponse = ChatResponse.builder()
                .id("test-id")
                .content("流式测试回复")
                .model("qwen-turbo")
                .success(true)
                .build();

        when(aiChatService.streamChat(any(ChatRequest.class))).thenReturn(mockResponse);

        mockMvc.perform(post("/api/ai/chat/stream")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.content").value("流式测试回复"));
    }

    @Test
    void testChat_WithModelParameter() throws Exception {
        ChatRequest request = ChatRequest.builder()
                .content("测试消息")
                .model("qwen-plus")
                .temperature(0.5)
                .maxTokens(1000)
                .build();

        ChatResponse mockResponse = ChatResponse.builder()
                .id("test-id")
                .content("测试回复")
                .model("qwen-plus")
                .success(true)
                .build();

        when(aiChatService.chat(any(ChatRequest.class))).thenReturn(mockResponse);

        mockMvc.perform(post("/api/ai/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.model").value("qwen-plus"));
    }

    @Test
    void testChat_WithHistory() throws Exception {
        ChatRequest.ChatMessage historyMsg = ChatRequest.ChatMessage.builder()
                .role("user")
                .content("历史消息")
                .build();

        ChatRequest request = ChatRequest.builder()
                .content("当前消息")
                .messages(java.util.List.of(historyMsg))
                .build();

        ChatResponse mockResponse = ChatResponse.builder()
                .id("test-id")
                .content("测试回复")
                .model("qwen-turbo")
                .success(true)
                .build();

        when(aiChatService.chat(any(ChatRequest.class))).thenReturn(mockResponse);

        mockMvc.perform(post("/api/ai/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }

}
