package com.ai.hotel.controller;

import com.ai.hotel.model.dto.ApiResponse;
import com.ai.hotel.model.dto.LoginRequest;
import com.ai.hotel.model.dto.RegisterRequest;
import com.ai.hotel.model.entity.User;
import com.ai.hotel.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "认证接口", description = "提供用户注册、登录等认证功能")
public class AuthController {

    private final UserService userService;

    @PostMapping(value = "/register", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "用户注册", description = "新用户注册")
    public ApiResponse<User> register(@Valid @RequestBody RegisterRequest request) {
        log.info("Received registration request for user: {}", request.getUsername());
        User user = userService.register(request);
        return ApiResponse.success("注册成功", user);
    }

    @PostMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "用户登录", description = "用户登录，支持用户名/邮箱/电话号码登录")
    public ApiResponse<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        log.info("Received login request for user: {}", request.getLoginName());
        User user = userService.login(request);
        
        Map<String, Object> result = new HashMap<>();
        result.put("user", user);
        result.put("token", "mock-jwt-token-" + user.getId());
        result.put("message", "登录成功");
        
        return ApiResponse.success("登录成功", result);
    }

}
