package com.ai.hotel.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "用户注册请求")
public class RegisterRequest {

    @NotBlank(message = "用户名不能为空")
    @Size(min = 3, max = 20, message = "用户名长度在3到20个字符")
    @Schema(description = "用户名", example = "testuser")
    private String username;

    @NotBlank(message = "酒店名称不能为空")
    @Size(min = 2, max = 50, message = "酒店名称长度在2到50个字符")
    @Schema(description = "酒店名称", example = "三亚孟天涯酒店")
    private String hotelName;

    @NotBlank(message = "电话号码不能为空")
    @Pattern(regexp = "^[+]?[0-9]{1,4}[\\s-]?[0-9]{1,14}$", message = "请输入有效的电话号码")
    @Schema(description = "电话号码（支持国际格式）", example = "+86 13800138000")
    private String phone;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度在6到20个字符")
    @Schema(description = "密码", example = "123456")
    private String password;

    @NotBlank(message = "确认密码不能为空")
    @Schema(description = "确认密码", example = "123456")
    private String confirmPassword;

    @NotBlank(message = "邮箱不能为空")
    @Email(message = "请输入有效的邮箱地址")
    @Schema(description = "邮箱", example = "test@example.com")
    private String email;

}
