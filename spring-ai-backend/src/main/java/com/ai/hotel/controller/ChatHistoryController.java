package com.ai.hotel.controller;

import com.ai.hotel.model.dto.ApiResponse;
import com.ai.hotel.model.entity.ChatMessage;
import com.ai.hotel.model.entity.ChatSession;
import com.ai.hotel.service.ChatHistoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
@Tag(name = "聊天历史接口", description = "提供聊天会话和消息管理功能")
public class ChatHistoryController {

    private final ChatHistoryService chatHistoryService;

    @PostMapping(value = "/sessions", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "创建新会话", description = "创建新的聊天会话")
    public ApiResponse<ChatSession> createSession(@RequestParam Long userId, 
                                                   @RequestParam(required = false) String model) {
        log.info("Creating new session for user: {}", userId);
        ChatSession session = chatHistoryService.createSession(userId, model);
        return ApiResponse.success("会话创建成功", session);
    }

    @GetMapping(value = "/sessions/{userId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "获取用户会话列表", description = "获取指定用户的所有聊天会话")
    public ApiResponse<List<ChatSession>> getUserSessions(@PathVariable Long userId) {
        log.info("Getting sessions for user: {}", userId);
        List<ChatSession> sessions = chatHistoryService.getUserSessions(userId);
        return ApiResponse.success(sessions);
    }

    @PutMapping(value = "/sessions/{sessionId}/title", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "更新会话标题", description = "更新指定会话的标题")
    public ApiResponse<ChatSession> updateSessionTitle(@PathVariable Long sessionId, 
                                                        @RequestParam String title) {
        log.info("Updating title for session: {}", sessionId);
        ChatSession session = chatHistoryService.updateSessionTitle(sessionId, title);
        return ApiResponse.success("标题更新成功", session);
    }

    @DeleteMapping(value = "/sessions/{sessionId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "删除会话", description = "删除指定的聊天会话及其所有消息")
    public ApiResponse<Void> deleteSession(@PathVariable Long sessionId) {
        log.info("Deleting session: {}", sessionId);
        chatHistoryService.deleteSession(sessionId);
        return ApiResponse.success("会话删除成功", null);
    }

    @GetMapping(value = "/sessions/{sessionId}/messages", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "获取会话消息", description = "获取指定会话的所有消息")
    public ApiResponse<List<ChatMessage>> getSessionMessages(@PathVariable Long sessionId) {
        log.info("Getting messages for session: {}", sessionId);
        List<ChatMessage> messages = chatHistoryService.getSessionMessages(sessionId);
        return ApiResponse.success(messages);
    }

}
