package com.ai.hotel.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "aliyun.dashscope")
public class AliyunDashScopeProperties {

    private String apiKey;

    private String model = "qwen-turbo";

    private Integer timeout = 30000;

    private Integer maxRetries = 3;

    private Long retryDelay = 1000L;

}
