package com.ai.hotel.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "AI聊天响应")
public class ChatResponse {

    @Schema(description = "响应ID")
    private String id;

    @Schema(description = "AI生成的回复内容")
    private String content;

    @Schema(description = "使用的模型")
    private String model;

    @Schema(description = "提示词token数")
    private Integer promptTokens;

    @Schema(description = "完成token数")
    private Integer completionTokens;

    @Schema(description = "总token数")
    private Integer totalTokens;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "处理耗时（毫秒）")
    private Long processingTime;

    @Schema(description = "是否成功")
    private Boolean success;

    @Schema(description = "错误信息（如果失败）")
    private String errorMessage;

}
