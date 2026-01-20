package com.ai.hotel.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "AI聊天请求")
public class ChatRequest {

    @NotBlank(message = "消息内容不能为空")
    @Size(max = 4000, message = "消息内容长度不能超过4000字符")
    @Schema(description = "用户输入的消息内容", example = "帮我分析一下今天的客房入住情况")
    private String content;

    @Schema(description = "对话历史记录", example = "[{\"role\":\"user\",\"content\":\"你好\"},{\"role\":\"assistant\",\"content\":\"你好！有什么我可以帮助你的吗？\"}]")
    private List<ChatMessage> messages;

    @Schema(description = "模型名称", example = "qwen-turbo")
    private String model;

    @Schema(description = "温度参数，控制输出的随机性，范围0-1", example = "0.7")
    private Double temperature;

    @Schema(description = "最大生成token数", example = "2000")
    private Integer maxTokens;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "聊天消息")
    public static class ChatMessage {

        @Schema(description = "角色", example = "user", allowableValues = {"user", "assistant", "system"})
        private String role;

        @Schema(description = "消息内容", example = "你好")
        private String content;

    }

}
