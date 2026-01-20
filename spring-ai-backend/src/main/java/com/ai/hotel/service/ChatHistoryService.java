package com.ai.hotel.service;

import com.ai.hotel.model.dto.ChatRequest;
import com.ai.hotel.model.dto.ChatResponse;
import com.ai.hotel.model.entity.ChatMessage;
import com.ai.hotel.model.entity.ChatSession;
import com.ai.hotel.repository.ChatMessageRepository;
import com.ai.hotel.repository.ChatSessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatHistoryService {

    private final ChatSessionRepository chatSessionRepository;
    private final ChatMessageRepository chatMessageRepository;

    @Transactional
    public ChatSession createSession(Long userId, String model) {
        ChatSession session = ChatSession.builder()
                .userId(userId)
                .sessionId(UUID.randomUUID().toString())
                .title("新对话")
                .model(model)
                .messageCount(0)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        
        return chatSessionRepository.save(session);
    }

    @Transactional
    public ChatSession updateSessionTitle(Long sessionId, String title) {
        ChatSession session = chatSessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));
        
        session.setTitle(title);
        session.setUpdatedAt(LocalDateTime.now());
        
        return chatSessionRepository.save(session);
    }

    @Transactional
    public void deleteSession(Long sessionId) {
        chatMessageRepository.deleteBySessionId(sessionId);
        chatSessionRepository.deleteById(sessionId);
    }

    public List<ChatSession> getUserSessions(Long userId) {
        return chatSessionRepository.findByUserIdOrderByUpdatedAtDesc(userId);
    }

    public List<ChatMessage> getSessionMessages(Long sessionId) {
        return chatMessageRepository.findBySessionIdOrderByCreatedAtAsc(sessionId);
    }

    @Transactional
    @Async
    public CompletableFuture<Void> saveMessageAsync(Long sessionId, String role, String content, 
                                                   String model, ChatResponse response) {
        return CompletableFuture.runAsync(() -> {
            try {
                ChatMessage message = ChatMessage.builder()
                        .sessionId(sessionId)
                        .role(role)
                        .content(content)
                        .model(model)
                        .promptTokens(response.getPromptTokens())
                        .completionTokens(response.getCompletionTokens())
                        .totalTokens(response.getTotalTokens())
                        .processingTime(response.getProcessingTime())
                        .createdAt(LocalDateTime.now())
                        .build();
                
                chatMessageRepository.save(message);
                
                ChatSession session = chatSessionRepository.findById(sessionId).orElse(null);
                if (session != null) {
                    session.setMessageCount(session.getMessageCount() + 1);
                    session.setUpdatedAt(LocalDateTime.now());
                    chatSessionRepository.save(session);
                }
                
                log.info("Message saved successfully for session: {}", sessionId);
            } catch (Exception e) {
                log.error("Error saving message for session: {}", sessionId, e);
            }
        });
    }

    @Transactional
    public void saveMessage(Long sessionId, String role, String content, 
                           String model, ChatResponse response) {
        ChatMessage message = ChatMessage.builder()
                .sessionId(sessionId)
                .role(role)
                .content(content)
                .model(model)
                .promptTokens(response.getPromptTokens())
                .completionTokens(response.getCompletionTokens())
                .totalTokens(response.getTotalTokens())
                .processingTime(response.getProcessingTime())
                .createdAt(LocalDateTime.now())
                .build();
        
        chatMessageRepository.save(message);
        
        ChatSession session = chatSessionRepository.findById(sessionId).orElse(null);
        if (session != null) {
            session.setMessageCount(session.getMessageCount() + 1);
            session.setUpdatedAt(LocalDateTime.now());
            chatSessionRepository.save(session);
        }
    }

}
