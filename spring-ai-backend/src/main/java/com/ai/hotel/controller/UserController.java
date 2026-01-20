package com.ai.hotel.controller;

import com.ai.hotel.model.dto.ApiResponse;
import com.ai.hotel.model.entity.User;
import com.ai.hotel.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "用户管理接口", description = "提供用户信息管理功能")
public class UserController {

    private final UserService userService;

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "获取用户信息", description = "根据用户ID获取用户详细信息")
    public ApiResponse<User> getUserById(@PathVariable Long id) {
        log.info("Getting user by id: {}", id);
        User user = userService.getUserById(id);
        return ApiResponse.success(user);
    }

    @PutMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "更新用户信息", description = "更新用户信息")
    public ApiResponse<User> updateUser(@PathVariable Long id,
                                        @RequestParam(required = false) String hotelName,
                                        @RequestParam(required = false) String phone,
                                        @RequestParam(required = false) String email) {
        log.info("Updating user: {}", id);
        User user = userService.updateUser(id, hotelName, phone, email);
        return ApiResponse.success("用户信息更新成功", user);
    }

    @PostMapping(value = "/{id}/verify-phone", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "验证电话号码", description = "验证用户的电话号码")
    public ApiResponse<Void> verifyPhone(@PathVariable Long id) {
        log.info("Verifying phone for user: {}", id);
        userService.verifyPhone(id);
        return ApiResponse.success("电话号码验证成功", null);
    }

    @PostMapping(value = "/{id}/verify-email", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "验证邮箱", description = "验证用户的邮箱")
    public ApiResponse<Void> verifyEmail(@PathVariable Long id) {
        log.info("Verifying email for user: {}", id);
        userService.verifyEmail(id);
        return ApiResponse.success("邮箱验证成功", null);
    }

}
