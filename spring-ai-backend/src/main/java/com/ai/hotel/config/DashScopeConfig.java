package com.ai.hotel.config;

import com.alibaba.dashscope.aigc.generation.Generation;
import com.alibaba.dashscope.aigc.generation.GenerationParam;
import com.alibaba.dashscope.aigc.generation.GenerationResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class DashScopeConfig {

    private final AliyunDashScopeProperties properties;

    @Bean
    public GenerationParam defaultGenerationParam() {
        return GenerationParam.builder()
                .model(properties.getModel())
                .resultFormat(GenerationParam.ResultFormat.MESSAGE)
                .build();
    }

}
