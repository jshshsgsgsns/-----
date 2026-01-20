package com.ai.hotel.service;

import com.ai.hotel.model.dto.LoginRequest;
import com.ai.hotel.model.dto.RegisterRequest;
import com.ai.hotel.model.entity.User;
import com.ai.hotel.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    private RegisterRequest registerRequest;
    private LoginRequest loginRequest;
    private User mockUser;

    @BeforeEach
    void setUp() {
        registerRequest = RegisterRequest.builder()
                .username("testuser")
                .hotelName("测试酒店")
                .phone("13800138000")
                .password("123456")
                .confirmPassword("123456")
                .email("test@example.com")
                .build();

        loginRequest = LoginRequest.builder()
                .loginName("testuser")
                .password("123456")
                .build();

        mockUser = User.builder()
                .id(1L)
                .username("testuser")
                .password("$2a$10$encodedPassword")
                .hotelName("测试酒店")
                .phone("13800138000")
                .email("test@example.com")
                .enabled(true)
                .build();
    }

    @Test
    void testRegister_Success() {
        when(userRepository.existsByUsername(anyString())).thenReturn(false);
        when(userRepository.existsByEmail(anyString())).thenReturn(false);
        when(userRepository.existsByPhone(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("$2a$10$encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(mockUser);

        User result = userService.register(registerRequest);

        assertNotNull(result);
        assertEquals("testuser", result.getUsername());
        assertEquals("测试酒店", result.getHotelName());
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void testRegister_PasswordMismatch() {
        registerRequest.setConfirmPassword("654321");

        assertThrows(IllegalArgumentException.class, () -> userService.register(registerRequest));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testRegister_UsernameExists() {
        when(userRepository.existsByUsername(anyString())).thenReturn(true);

        assertThrows(IllegalArgumentException.class, () -> userService.register(registerRequest));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testRegister_EmailExists() {
        when(userRepository.existsByUsername(anyString())).thenReturn(false);
        when(userRepository.existsByEmail(anyString())).thenReturn(true);

        assertThrows(IllegalArgumentException.class, () -> userService.register(registerRequest));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testLogin_Success() {
        when(userRepository.findByUsernameOrEmailOrPhone(anyString(), anyString(), anyString()))
                .thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);

        User result = userService.login(loginRequest);

        assertNotNull(result);
        assertEquals("testuser", result.getUsername());
    }

    @Test
    void testLogin_UserNotFound() {
        when(userRepository.findByUsernameOrEmailOrPhone(anyString(), anyString(), anyString()))
                .thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userService.login(loginRequest));
    }

    @Test
    void testLogin_UserDisabled() {
        mockUser.setEnabled(false);
        when(userRepository.findByUsernameOrEmailOrPhone(anyString(), anyString(), anyString()))
                .thenReturn(Optional.of(mockUser));

        assertThrows(IllegalArgumentException.class, () -> userService.login(loginRequest));
    }

    @Test
    void testLogin_WrongPassword() {
        when(userRepository.findByUsernameOrEmailOrPhone(anyString(), anyString(), anyString()))
                .thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(false);

        assertThrows(IllegalArgumentException.class, () -> userService.login(loginRequest));
    }

    @Test
    void testGetUserById_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

        User result = userService.getUserById(1L);

        assertNotNull(result);
        assertEquals("testuser", result.getUsername());
    }

    @Test
    void testGetUserById_NotFound() {
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userService.getUserById(1L));
    }

    @Test
    void testUpdateUser_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
        when(userRepository.save(any(User.class))).thenReturn(mockUser);

        User result = userService.updateUser(1L, "新酒店名称", "13900139000", "new@example.com");

        assertNotNull(result);
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void testVerifyPhone_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
        when(userRepository.save(any(User.class))).thenReturn(mockUser);

        userService.verifyPhone(1L);

        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void testVerifyEmail_Success() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
        when(userRepository.save(any(User.class))).thenReturn(mockUser);

        userService.verifyEmail(1L);

        verify(userRepository, times(1)).save(any(User.class));
    }

}
