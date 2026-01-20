package com.ai.hotel.service;

import com.ai.hotel.model.dto.LoginRequest;
import com.ai.hotel.model.dto.RegisterRequest;
import com.ai.hotel.model.entity.User;
import com.ai.hotel.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public User register(RegisterRequest request) {
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new IllegalArgumentException("两次输入的密码不一致");
        }

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("用户名已存在");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("邮箱已被注册");
        }

        if (userRepository.existsByPhone(request.getPhone())) {
            throw new IllegalArgumentException("电话号码已被注册");
        }

        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .hotelName(request.getHotelName())
                .phone(request.getPhone())
                .email(request.getEmail())
                .enabled(true)
                .phoneVerified(false)
                .emailVerified(false)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return userRepository.save(user);
    }

    public User login(LoginRequest request) {
        Optional<User> userOptional = userRepository.findByUsernameOrEmailOrPhone(
                request.getLoginName(), request.getLoginName(), request.getLoginName());

        if (userOptional.isEmpty()) {
            throw new IllegalArgumentException("用户不存在");
        }

        User user = userOptional.get();

        if (!user.getEnabled()) {
            throw new IllegalArgumentException("账号已被禁用");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("密码错误");
        }

        return user;
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("用户不存在"));
    }

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("用户不存在"));
    }

    @Transactional
    public User updateUser(Long id, String hotelName, String phone, String email) {
        User user = getUserById(id);

        if (hotelName != null && !hotelName.isBlank()) {
            user.setHotelName(hotelName);
        }

        if (phone != null && !phone.isBlank() && !phone.equals(user.getPhone())) {
            if (userRepository.existsByPhone(phone)) {
                throw new IllegalArgumentException("电话号码已被使用");
            }
            user.setPhone(phone);
            user.setPhoneVerified(false);
        }

        if (email != null && !email.isBlank() && !email.equals(user.getEmail())) {
            if (userRepository.existsByEmail(email)) {
                throw new IllegalArgumentException("邮箱已被使用");
            }
            user.setEmail(email);
            user.setEmailVerified(false);
        }

        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    @Transactional
    public void verifyPhone(Long id) {
        User user = getUserById(id);
        user.setPhoneVerified(true);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    @Transactional
    public void verifyEmail(Long id) {
        User user = getUserById(id);
        user.setEmailVerified(true);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

}
