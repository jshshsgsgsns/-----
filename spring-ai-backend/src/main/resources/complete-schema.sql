-- ===================================================================
-- Spring Boot + Spring AI 酒店管理系统
-- 完整数据库结构定义
-- 版本: 1.0.0
-- 最后更新: 2026-01-20
-- ===================================================================

-- ===================================================================
-- 1. 数据库初始化
-- ===================================================================

-- 创建数据库（开发环境）
CREATE DATABASE IF NOT EXISTS ai_hotel_dev 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 创建数据库（测试环境）
CREATE DATABASE IF NOT EXISTS ai_hotel_test 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 创建数据库（生产环境）
CREATE DATABASE IF NOT EXISTS ai_hotel_prod 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 使用开发环境数据库（根据需要修改）
USE ai_hotel_dev;

-- ===================================================================
-- 2. 核心业务表
-- ===================================================================

-- -------------------------------------------------------------------
-- 2.1 用户表 (users)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    
    -- 基本信息
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码（BCrypt加密）',
    hotel_name VARCHAR(100) NOT NULL COMMENT '酒店名称',
    phone VARCHAR(20) COMMENT '电话号码',
    email VARCHAR(100) COMMENT '邮箱地址',
    avatar VARCHAR(100) COMMENT '头像URL',
    
    -- 状态字段
    enabled BOOLEAN NOT NULL DEFAULT TRUE COMMENT '账号是否启用',
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT '电话是否已验证',
    email_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT '邮箱是否已验证',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_enabled (enabled)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='用户信息表';

-- -------------------------------------------------------------------
-- 2.2 聊天会话表 (chat_sessions)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_sessions (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '会话ID',
    
    -- 关联信息
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_id VARCHAR(100) NOT NULL UNIQUE COMMENT '会话唯一标识',
    
    -- 会话信息
    title VARCHAR(500) COMMENT '会话标题',
    message_count INT NOT NULL DEFAULT 0 COMMENT '消息数量',
    model VARCHAR(20) COMMENT '使用的AI模型',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_created_at (created_at),
    
    -- 外键约束
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='聊天会话表';

-- -------------------------------------------------------------------
-- 2.3 聊天消息表 (chat_messages)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_messages (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '消息ID',
    
    -- 关联信息
    session_id BIGINT NOT NULL COMMENT '会话ID',
    
    -- 消息内容
    role VARCHAR(20) NOT NULL COMMENT '角色（user/assistant/system）',
    content TEXT NOT NULL COMMENT '消息内容',
    model VARCHAR(20) COMMENT '使用的AI模型',
    
    -- Token统计
    prompt_tokens INT COMMENT '提示词Token数',
    completion_tokens INT COMMENT '完成Token数',
    total_tokens INT COMMENT '总Token数',
    processing_time BIGINT COMMENT '处理时间（毫秒）',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 索引
    INDEX idx_session_id (session_id),
    INDEX idx_created_at (created_at),
    INDEX idx_role (role),
    
    -- 外键约束
    FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='聊天消息表';

-- ===================================================================
-- 3. 扩展功能表
-- ===================================================================

-- -------------------------------------------------------------------
-- 3.1 系统配置表 (system_config)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS system_config (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '配置ID',
    
    -- 配置信息
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_type VARCHAR(20) NOT NULL DEFAULT 'STRING' COMMENT '配置类型（STRING/NUMBER/BOOLEAN/JSON）',
    description VARCHAR(500) COMMENT '配置描述',
    
    -- 状态字段
    is_public BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否为公开配置',
    is_editable BOOLEAN NOT NULL DEFAULT TRUE COMMENT '是否可编辑',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引
    INDEX idx_config_key (config_key),
    INDEX idx_is_public (is_public)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='系统配置表';

-- -------------------------------------------------------------------
-- 3.2 审计日志表 (audit_logs)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_logs (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    
    -- 操作信息
    user_id BIGINT COMMENT '操作用户ID',
    action_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    resource_type VARCHAR(50) COMMENT '资源类型',
    resource_id VARCHAR(100) COMMENT '资源ID',
    action_detail TEXT COMMENT '操作详情',
    
    -- 请求信息
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    request_url VARCHAR(500) COMMENT '请求URL',
    
    -- 结果信息
    status_code INT COMMENT '状态码',
    error_message TEXT COMMENT '错误信息',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at),
    
    -- 外键约束
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='审计日志表';

-- -------------------------------------------------------------------
-- 3.3 API使用统计表 (api_usage_stats)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS api_usage_stats (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '统计ID',
    
    -- 统计维度
    user_id BIGINT COMMENT '用户ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    model VARCHAR(20) NOT NULL COMMENT 'AI模型',
    
    -- 使用统计
    request_count INT NOT NULL DEFAULT 0 COMMENT '请求次数',
    success_count INT NOT NULL DEFAULT 0 COMMENT '成功次数',
    error_count INT NOT NULL DEFAULT 0 COMMENT '错误次数',
    
    -- Token统计
    total_prompt_tokens BIGINT NOT NULL DEFAULT 0 COMMENT '总提示词Token数',
    total_completion_tokens BIGINT NOT NULL DEFAULT 0 COMMENT '总完成Token数',
    total_tokens BIGINT NOT NULL DEFAULT 0 COMMENT '总Token数',
    
    -- 性能统计
    avg_processing_time BIGINT COMMENT '平均处理时间（毫秒）',
    min_processing_time BIGINT COMMENT '最小处理时间（毫秒）',
    max_processing_time BIGINT COMMENT '最大处理时间（毫秒）',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束
    UNIQUE KEY uk_user_date_model (user_id, stat_date, model),
    
    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_stat_date (stat_date),
    INDEX idx_model (model),
    
    -- 外键约束
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='API使用统计表';

-- -------------------------------------------------------------------
-- 3.4 用户登录日志表 (user_login_logs)
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_login_logs (
    -- 主键
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    
    -- 登录信息
    user_id BIGINT NOT NULL COMMENT '用户ID',
    login_type VARCHAR(20) NOT NULL DEFAULT 'PASSWORD' COMMENT '登录类型（PASSWORD/OAUTH）',
    login_status VARCHAR(20) NOT NULL COMMENT '登录状态（SUCCESS/FAILURE）',
    
    -- 请求信息
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    
    -- 失败原因
    failure_reason VARCHAR(100) COMMENT '失败原因',
    
    -- 时间戳
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_login_status (login_status),
    INDEX idx_created_at (created_at),
    
    -- 外键约束
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='用户登录日志表';

-- ===================================================================
-- 4. 视图定义
-- ===================================================================

-- -------------------------------------------------------------------
-- 4.1 用户会话统计视图 (v_user_session_stats)
-- -------------------------------------------------------------------
CREATE OR REPLACE VIEW v_user_session_stats AS
SELECT 
    u.id AS user_id,
    u.username,
    u.hotel_name,
    COUNT(cs.id) AS session_count,
    COALESCE(SUM(cs.message_count), 0) AS total_message_count,
    MAX(cs.updated_at) AS last_active_time,
    CASE 
        WHEN MAX(cs.updated_at) > DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 'ACTIVE'
        WHEN MAX(cs.updated_at) > DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 'INACTIVE'
        ELSE 'DORMANT'
    END AS activity_status
FROM users u
LEFT JOIN chat_sessions cs ON u.id = cs.user_id
GROUP BY u.id, u.username, u.hotel_name;

-- -------------------------------------------------------------------
-- 4.2 每日使用统计视图 (v_daily_usage_stats)
-- -------------------------------------------------------------------
CREATE OR REPLACE VIEW v_daily_usage_stats AS
SELECT 
    stat_date,
    model,
    COUNT(DISTINCT user_id) AS active_users,
    SUM(request_count) AS total_requests,
    SUM(success_count) AS total_successes,
    SUM(error_count) AS total_errors,
    SUM(total_prompt_tokens) AS total_prompt_tokens,
    SUM(total_completion_tokens) AS total_completion_tokens,
    SUM(total_tokens) AS total_tokens,
    AVG(avg_processing_time) AS avg_processing_time
FROM api_usage_stats
GROUP BY stat_date, model
ORDER BY stat_date DESC, model;

-- -------------------------------------------------------------------
-- 4.3 活跃用户视图 (v_active_users)
-- -------------------------------------------------------------------
CREATE OR REPLACE VIEW v_active_users AS
SELECT 
    u.id AS user_id,
    u.username,
    u.hotel_name,
    u.email,
    u.created_at AS user_created_at,
    MAX(ull.created_at) AS last_login_at,
    COUNT(cs.id) AS recent_sessions
FROM users u
LEFT JOIN user_login_logs ull ON u.id = ull.user_id AND ull.login_status = 'SUCCESS' AND ull.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
LEFT JOIN chat_sessions cs ON u.id = cs.user_id AND cs.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
WHERE u.enabled = TRUE
GROUP BY u.id, u.username, u.hotel_name, u.email, u.created_at
HAVING MAX(ull.created_at) IS NOT NULL OR COUNT(cs.id) > 0;

-- ===================================================================
-- 5. 存储过程
-- ===================================================================

-- -------------------------------------------------------------------
-- 5.1 清理过期会话存储过程 (sp_clean_expired_sessions)
-- -------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE sp_clean_expired_sessions(IN days_ago INT)
BEGIN
    DECLARE deleted_count INT DEFAULT 0;
    
    -- 删除超过指定天数未更新的会话
    DELETE FROM chat_sessions 
    WHERE updated_at < DATE_SUB(NOW(), INTERVAL days_ago DAY);
    
    SET deleted_count = ROW_COUNT();
    
    -- 记录清理日志
    INSERT INTO audit_logs (action_type, resource_type, action_detail, created_at)
    VALUES ('CLEANUP', 'SESSIONS', CONCAT('Cleaned ', deleted_count, ' expired sessions older than ', days_ago, ' days'), NOW());
    
    SELECT deleted_count AS deleted_sessions;
END //
DELIMITER ;

-- -------------------------------------------------------------------
-- 5.2 更新用户统计存储过程 (sp_update_user_stats)
-- -------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE sp_update_user_stats(IN user_id_param BIGINT, IN stat_date_param DATE)
BEGIN
    DECLARE total_sessions INT DEFAULT 0;
    DECLARE total_messages INT DEFAULT 0;
    
    -- 获取用户在指定日期的会话和消息统计
    SELECT COUNT(DISTINCT cs.id), COUNT(cm.id)
    INTO total_sessions, total_messages
    FROM chat_sessions cs
    LEFT JOIN chat_messages cm ON cs.id = cm.session_id
    WHERE cs.user_id = user_id_param 
    AND DATE(cs.created_at) = stat_date_param;
    
    -- 更新或插入API使用统计
    INSERT INTO api_usage_stats (
        user_id, stat_date, model, request_count, success_count, 
        total_prompt_tokens, total_completion_tokens, total_tokens
    )
    SELECT 
        user_id_param, 
        stat_date_param, 
        model, 
        COUNT(*), 
        COUNT(CASE WHEN role = 'assistant' THEN 1 END),
        COALESCE(SUM(prompt_tokens), 0),
        COALESCE(SUM(completion_tokens), 0),
        COALESCE(SUM(total_tokens), 0)
    FROM chat_messages cm
    JOIN chat_sessions cs ON cm.session_id = cs.id
    WHERE cs.user_id = user_id_param 
    AND DATE(cm.created_at) = stat_date_param
    GROUP BY model
    ON DUPLICATE KEY UPDATE
        request_count = VALUES(request_count),
        success_count = VALUES(success_count),
        total_prompt_tokens = VALUES(total_prompt_tokens),
        total_completion_tokens = VALUES(total_completion_tokens),
        total_tokens = VALUES(total_tokens);
    
    SELECT total_sessions, total_messages;
END //
DELIMITER ;

-- -------------------------------------------------------------------
-- 5.3 获取会话摘要存储过程 (sp_get_session_summary)
-- -------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE sp_get_session_summary(IN session_id_param BIGINT)
BEGIN
    SELECT 
        cs.id,
        cs.session_id,
        cs.title,
        cs.message_count,
        cs.model,
        cs.created_at,
        cs.updated_at,
        u.username,
        u.hotel_name,
        TIMESTAMPDIFF(SECOND, cs.created_at, cs.updated_at) AS duration_seconds,
        CASE 
            WHEN cs.updated_at > DATE_SUB(NOW(), INTERVAL 1 DAY) THEN 'TODAY'
            WHEN cs.updated_at > DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 'THIS_WEEK'
            WHEN cs.updated_at > DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 'THIS_MONTH'
            ELSE 'OLDER'
        END AS age_category
    FROM chat_sessions cs
    JOIN users u ON cs.user_id = u.id
    WHERE cs.id = session_id_param;
END //
DELIMITER ;

-- -------------------------------------------------------------------
-- 5.4 计算每日统计存储过程 (sp_calculate_daily_stats)
-- -------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE sp_calculate_daily_stats(IN target_date DATE)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id_var BIGINT;
    DECLARE model_var VARCHAR(20);
    
    -- 游标：获取所有在指定日期有活动的用户和模型
    DECLARE user_cursor CURSOR FOR 
        SELECT DISTINCT cm.user_id, cm.model
        FROM (
            SELECT cs.user_id, cm.model
            FROM chat_messages cm
            JOIN chat_sessions cs ON cm.session_id = cs.id
            WHERE DATE(cm.created_at) = target_date
        ) cm;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN user_cursor;
    
    read_loop: LOOP
        FETCH user_cursor INTO user_id_var, model_var;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 更新每个用户的统计数据
        CALL sp_update_user_stats(user_id_var, target_date);
        
    END LOOP;
    
    CLOSE user_cursor;
    
    -- 返回统计摘要
    SELECT 
        COUNT(DISTINCT user_id) AS active_users,
        SUM(request_count) AS total_requests,
        SUM(success_count) AS total_successes,
        SUM(error_count) AS total_errors,
        SUM(total_tokens) AS total_tokens
    FROM api_usage_stats
    WHERE stat_date = target_date;
END //
DELIMITER ;

-- ===================================================================
-- 6. 触发器
-- ===================================================================

-- -------------------------------------------------------------------
-- 6.1 自动更新会话消息计数触发器 (trg_update_message_count)
-- -------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER trg_update_message_count
AFTER INSERT ON chat_messages
FOR EACH ROW
BEGIN
    UPDATE chat_sessions 
    SET message_count = message_count + 1, updated_at = NOW()
    WHERE id = NEW.session_id;
END //
DELIMITER ;

-- -------------------------------------------------------------------
-- 6.2 记录用户登录日志触发器 (trg_log_user_login)
-- -------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER trg_log_user_login
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    -- 如果用户状态从禁用变为启用，记录登录日志
    IF OLD.enabled = FALSE AND NEW.enabled = TRUE THEN
        INSERT INTO user_login_logs (user_id, login_type, login_status, created_at)
        VALUES (NEW.id, 'STATUS_CHANGE', 'SUCCESS', NOW());
    END IF;
END //
DELIMITER ;

-- -------------------------------------------------------------------
-- 6.3 记录API调用日志触发器 (trg_log_api_call)
-- -------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER trg_log_api_call
AFTER INSERT ON chat_messages
FOR EACH ROW
BEGIN
    -- 记录API调用审计日志
    INSERT INTO audit_logs (action_type, resource_type, resource_id, action_detail, created_at)
    VALUES ('API_CALL', 'MESSAGE', NEW.id, 
            CONCAT('Model: ', COALESCE(NEW.model, 'unknown'), ', Tokens: ', COALESCE(NEW.total_tokens, 0)), 
            NOW());
END //
DELIMITER ;

-- ===================================================================
-- 7. 初始数据
-- ===================================================================

-- -------------------------------------------------------------------
-- 7.1 系统配置初始数据
-- -------------------------------------------------------------------
INSERT INTO system_config (config_key, config_value, config_type, description, is_public) VALUES
-- AI模型配置
('ai.default_model', 'qwen-turbo', 'STRING', '默认AI模型', TRUE),
('ai.max_tokens', '2000', 'NUMBER', '最大Token数', TRUE),
('ai.temperature', '0.7', 'NUMBER', '默认温度参数', TRUE),
('ai.timeout', '30000', 'NUMBER', 'API超时时间（毫秒）', TRUE),

-- 系统配置
('system.max_sessions_per_user', '10', 'NUMBER', '每用户最大会话数', TRUE),
('system.session_retention_days', '30', 'NUMBER', '会话保留天数', TRUE),
('system.max_message_length', '4000', 'NUMBER', '最大消息长度', TRUE),

-- 安全配置
('security.password_min_length', '6', 'NUMBER', '密码最小长度', FALSE),
('security.session_timeout_hours', '24', 'NUMBER', '会话超时时间（小时）', FALSE),
('security.max_login_attempts', '5', 'NUMBER', '最大登录尝试次数', FALSE),
('security.lockout_duration_minutes', '15', 'NUMBER', '账户锁定时长（分钟）', FALSE)

ON DUPLICATE KEY UPDATE 
    config_value = VALUES(config_value), 
    updated_at = NOW();

-- -------------------------------------------------------------------
-- 7.2 测试用户数据
-- -------------------------------------------------------------------
-- 插入管理员用户（密码为123456，使用BCrypt加密）
INSERT INTO users (username, password, hotel_name, phone, email, enabled, phone_verified, email_verified) 
VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '示例酒店', '13800138000', 'admin@example.com', TRUE, TRUE, TRUE)
ON DUPLICATE KEY UPDATE username = username;

-- 插入测试用户
INSERT INTO users (username, password, hotel_name, phone, email, enabled, phone_verified, email_verified) 
VALUES 
('testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '测试酒店', '13900139000', 'test@example.com', TRUE, FALSE, FALSE)
ON DUPLICATE KEY UPDATE username = username;

-- -------------------------------------------------------------------
-- 7.3 示例会话和消息数据
-- -------------------------------------------------------------------
-- 获取管理员用户ID
SET @admin_user_id = (SELECT id FROM users WHERE username = 'admin' LIMIT 1);

-- 插入示例会话
INSERT INTO chat_sessions (user_id, session_id, title, model, message_count) 
VALUES 
(@admin_user_id, UUID(), '酒店管理咨询', 'qwen-turbo', 2)
ON DUPLICATE KEY UPDATE session_id = session_id;

-- 获取会话ID
SET @session_id = LAST_INSERT_ID();

-- 插入示例消息
INSERT INTO chat_messages (session_id, role, content, model, total_tokens, processing_time) 
VALUES 
(@session_id, 'user', '帮我分析一下今天的客房入住情况', 'qwen-turbo', 15, 1200),
(@session_id, 'assistant', '根据系统数据，今天的客房入住率为85%，比昨天提高了5个百分点。其中豪华套房入住率最高，达到95%。建议明天可以适当提高豪华套房的价格，同时为标准间提供一些优惠活动来进一步提高入住率。', 'qwen-turbo', 120, 3500);

-- ===================================================================
-- 8. 性能优化
-- ===================================================================

-- 创建复合索引优化查询性能
CREATE INDEX idx_chat_sessions_user_updated ON chat_sessions(user_id, updated_at);
CREATE INDEX idx_chat_messages_session_created ON chat_messages(session_id, created_at);
CREATE INDEX idx_audit_logs_user_date ON audit_logs(user_id, created_at);
CREATE INDEX idx_usage_stats_user_date ON api_usage_stats(user_id, stat_date);

-- ===================================================================
-- 9. 数据库维护
-- ===================================================================

-- 设置事件调度器（如果启用）
SET GLOBAL event_scheduler = ON;

-- 创建定期清理事件（每天凌晨2点执行）
CREATE EVENT IF NOT EXISTS ev_clean_expired_sessions
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '02:00:00')
DO
  CALL sp_clean_expired_sessions(30);

-- 创建统计计算事件（每天凌晨3点执行）
CREATE EVENT IF NOT EXISTS ev_calculate_daily_stats
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '03:00:00')
DO
  CALL sp_calculate_daily_stats(DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY));

-- ===================================================================
-- 10. 备份和维护说明
-- ===================================================================

/*
备份策略：
1. 全量备份：每周日凌晨1点执行
   mysqldump -u root -p --single-transaction --routines --triggers ai_hotel_prod > backup_$(date +\%Y%m%d).sql

2. 增量备份：每天凌晨2点执行
   mysqldump -u root -p --single-transaction --where="updated_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)" ai_hotel_prod > incremental_$(date +\%Y%m%d).sql

3. 二进制日志备份：实时
   在my.cnf中配置：
   log_bin = /var/log/mysql/mysql-bin.log
   expire_logs_days = 7
   max_binlog_size = 100M

性能优化建议：
1. 定期执行 ANALYZE TABLE 更新统计信息
2. 监控慢查询日志
3. 根据业务增长情况调整innodb_buffer_pool_size
4. 考虑使用Redis缓存热点数据

安全建议：
1. 定期更新MySQL版本
2. 限制root用户远程访问
3. 使用SSL连接
4. 定期备份数据到异地
*/

-- 完成数据库初始化
SELECT 'Database initialization completed successfully!' AS status;