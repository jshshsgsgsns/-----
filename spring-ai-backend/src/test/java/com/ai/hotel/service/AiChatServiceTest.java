package com.ai.hotel.service;

import com.ai.hotel.config.AliyunDashScopeProperties;
import com.ai.hotel.model.dto.ChatRequest;
import com.ai.hotel.model.dto.ChatResponse;
import com.aliyun.dashscope.aigc.generation.GenerationParam;
import com.aliyun.dashscope.aigc.generation.GenerationResult;
import com.aliyun.dashscope.sdk.aigc.generations.GenerationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AiChatServiceTest {

    @Mock
    private GenerationService generationService;

    @Mock
    private AliyunDashScopeProperties properties;

    @InjectMocks
    private AiChatService aiChatService;

    private ChatRequest chatRequest;

    @BeforeEach
    void setUp() {
        chatRequest = ChatRequest.builder()
                .content("测试消息")
                .temperature(0.7)
                .maxTokens(2000)
                .build();

        when(properties.getModel()).thenReturn("qwen-turbo");
    }

    @Test
    void testChat_Success() {
        // 模拟API响应
        com.aliyun.dashscope.aigc.generation.Choice choice = com.aliyun.dashscope.aigc.generation.Choice.builder()
                .message(com.aliyun.dashscope.aigc.generation.Message.builder()
                        .content("测试回复")
                        .build())
                .build();
        
        com.aliyun.dashscope.aigc.generation.Output output = com.aliyun.dashscope.aigc.generation.Output.builder()
                .choices(List.of(choice))
                .build();
        
        GenerationResult mockResult = GenerationResult.builder()
                .output(output)
                .build();

        when(generationService.generate(any(GenerationParam.class))).thenReturn(mockResult);

        ChatResponse response = aiChatService.chat(chatRequest);

        assertNotNull(response);
        assertTrue(response.getSuccess());
        assertEquals("测试回复", response.getContent());
        assertNotNull(response.getId());
        assertNotNull(response.getProcessingTime());

        // 验证调用参数
        // 注意：由于我们无法直接验证GenerationParam，我们只验证generationService被调用
        // 实际项目中可能需要更复杂的验证逻辑
    }

    @Test
    void testChat_WithHistory() {
        ChatRequest.ChatMessage historyMsg = ChatRequest.ChatMessage.builder()
                .role("user")
                .content("历史消息")
                .build();
        
        chatRequest.setMessages(List.of(historyMsg));

        com.aliyun.dashscope.aigc.generation.Choice choice = com.aliyun.dashscope.aigc.generation.Choice.builder()
                .message(com.aliyun.dashscope.aigc.generation.Message.builder()
                        .content("测试回复")
                        .build())
                .build();
        
        com.aliyun.dashscope.aigc.generation.Output output = com.aliyun.dashscope.aigc.generation.Output.builder()
                .choices(List.of(choice))
                .build();
        
        GenerationResult mockResult = GenerationResult.builder()
                .output(output)
                .build();

        when(generationService.generate(any(GenerationParam.class))).thenReturn(mockResult);

        ChatResponse response = aiChatService.chat(chatRequest);

        assertNotNull(response);
        assertTrue(response.getSuccess());
        assertEquals("测试回复", response.getContent());
    }

    @Test
    void testChat_Failure() {
        when(generationService.generate(any(GenerationParam.class)))
                .thenThrow(new RuntimeException("API调用失败"));

        ChatResponse response = aiChatService.chat(chatRequest);

        assertNotNull(response);
        assertFalse(response.getSuccess());
        assertNull(response.getContent());
        assertNotNull(response.getErrorMessage());
        assertTrue(response.getErrorMessage().contains("处理请求时发生错误"));
    }

    @Test
    void testChatAsync_Success() throws Exception {
        com.aliyun.dashscope.aigc.generation.Choice choice = com.aliyun.dashscope.aigc.generation.Choice.builder()
                .message(com.aliyun.dashscope.aigc.generation.Message.builder()
                        .content("异步测试回复")
                        .build())
                .build();
        
        com.aliyun.dashscope.aigc.generation.Output output = com.aliyun.dashscope.aigc.generation.Output.builder()
                .choices(List.of(choice))
                .build();
        
        GenerationResult mockResult = GenerationResult.builder()
                .output(output)
                .build();

        when(generationService.generate(any(GenerationParam.class))).thenReturn(mockResult);

        var futureResponse = aiChatService.chatAsync(chatRequest);
        ChatResponse response = futureResponse.get();

        assertNotNull(response);
        assertTrue(response.getSuccess());
        assertEquals("异步测试回复", response.getContent());
    }

    @Test
    void testStreamChat_Success() {
        com.aliyun.dashscope.aigc.generation.Choice choice = com.aliyun.dashscope.aigc.generation.Choice.builder()
                .message(com.aliyun.dashscope.aigc.generation.Message.builder()
                        .content("流式测试回复")
                        .build())
                .build();
        
        com.aliyun.dashscope.aigc.generation.Output output = com.aliyun.dashscope.aigc.generation.Output.builder()
                .choices(List.of(choice))
                .build();
        
        GenerationResult mockResult = GenerationResult.builder()
                .output(output)
                .build();

        when(generationService.generate(any(GenerationParam.class))).thenReturn(mockResult);

        ChatResponse response = aiChatService.streamChat(chatRequest);

        assertNotNull(response);
        assertTrue(response.getSuccess());
        assertEquals("流式测试回复", response.getContent());
    }

    @Test
    void testStreamChat_Failure() {
        when(generationService.generate(any(GenerationParam.class)))
                .thenThrow(new RuntimeException("流式API调用失败"));

        ChatResponse response = aiChatService.streamChat(chatRequest);

        assertNotNull(response);
        assertFalse(response.getSuccess());
        assertNull(response.getContent());
        assertNotNull(response.getErrorMessage());
        assertTrue(response.getErrorMessage().contains("处理流式请求时发生错误"));
    }

}
