package com.ai.hotel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
//import org.springframework.ai.autoconfigure.openai.OpenAiAutoConfiguration;

@SpringBootApplication()
public class AiHotelApplication {

    public static void main(String[] args) {
        SpringApplication.run(AiHotelApplication.class, args);
    }

}
