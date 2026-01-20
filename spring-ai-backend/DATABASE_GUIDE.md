# 数据库SQL文件使用说明

## 📋 文件说明

`complete-schema.sql` 是Spring Boot + Spring AI酒店管理系统的完整数据库结构定义文件。

## 📊 数据库结构概览

### 核心业务表（3个）

| 表名 | 说明 | 记录数预估 |
|------|------|------------|
| users | 用户信息表 | 10,000+ |
| chat_sessions | 聊天会话表 | 100,000+ |
| chat_messages | 聊天消息表 | 1,000,000+ |

### 扩展功能表（4个）

| 表名 | 说明 | 记录数预估 |
|------|------|------------|
| system_config | 系统配置表 | 50 |
| audit_logs | 审计日志表 | 1,000,000+ |
| api_usage_stats | API使用统计表 | 365,000+ |
| user_login_logs | 用户登录日志表 | 100,000+ |

### 视图（3个）

| 视图名 | 说明 | 用途 |
|--------|------|------|
| v_user_session_stats | 用户会话统计 | 用户活跃度分析 |
| v_daily_usage_stats | 每日使用统计 | API使用趋势分析 |
| v_active_users | 活跃用户 | 最近7天活跃用户 |

### 存储过程（4个）

| 存储过程名 | 说明 | 调用频率 |
|-----------|------|----------|
| sp_clean_expired_sessions | 清理过期会话 | 每日 |
| sp_update_user_stats | 更新用户统计 | 每日 |
| sp_get_session_summary | 获取会话摘要 | 按需 |
| sp_calculate_daily_stats | 计算每日统计 | 每日 |

### 触发器（3个）

| 触发器名 | 说明 | 触发时机 |
|---------|------|----------|
| trg_update_message_count | 自动更新会话消息计数 | 消息插入时 |
| trg_log_user_login | 记录用户登录日志 | 用户状态更新时 |
| trg_log_api_call | 记录API调用日志 | 消息插入时 |

## 🚀 快速开始

### 1. 执行SQL文件

#### 方式一：命令行执行
```bash
# Linux/macOS
mysql -u root -p < complete-schema.sql

# Windows
mysql -u root -p < complete-schema.sql
```

#### 方式二：MySQL客户端执行
```sql
-- 登录MySQL
mysql -u root -p

-- 执行SQL文件
source /path/to/complete-schema.sql;

-- 或者
\. /path/to/complete-schema.sql
```

#### 方式三：指定数据库执行
```bash
# 创建数据库并执行
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p ai_hotel_dev < complete-schema.sql
```

### 2. 验证数据库创建

```sql
-- 查看所有表
SHOW TABLES;

-- 预期输出：
-- users
-- chat_sessions
-- chat_messages
-- system_config
-- audit_logs
-- api_usage_stats
-- user_login_logs

-- 查看所有视图
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';

-- 预期输出：
-- v_user_session_stats
-- v_daily_usage_stats
-- v_active_users

-- 查看所有存储过程
SHOW PROCEDURE STATUS WHERE Db = 'ai_hotel_dev';

-- 查看所有触发器
SHOW TRIGGERS;
```

### 3. 验证初始数据

```sql
-- 查看系统配置
SELECT * FROM system_config;

-- 查看测试用户
SELECT id, username, hotel_name, email, enabled FROM users;

-- 预期输出：
-- id: 1, username: admin, hotel_name: 示例酒店
-- id: 2, username: testuser, hotel_name: 测试酒店

-- 查看示例会话
SELECT * FROM chat_sessions;

-- 查看示例消息
SELECT id, session_id, role, LEFT(content, 50) AS content_preview 
FROM chat_messages;
```

## 🔧 数据库配置说明

### 1. 字符集和排序规则

```sql
-- 数据库级别
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci

-- 表级别
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4 
COLLATE=utf8mb4_unicode_ci
```

**说明**：
- `utf8mb4` 支持完整的Unicode字符集，包括emoji
- `utf8mb4_unicode_ci` 不区分大小写的排序规则

### 2. 存储引擎

所有表使用 `InnoDB` 存储引擎：
- 支持事务
- 支持外键约束
- 支持行级锁定
- 支持崩溃恢复

### 3. 主键策略

所有主键使用 `BIGINT AUTO_INCREMENT`：
- 自增ID
- 支持大量数据（最大9,223,372,036,854,775,807）

### 4. 外键约束

```sql
-- chat_sessions表
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE

-- chat_messages表
FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE

-- api_usage_stats表
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

**级联删除规则**：
- `ON DELETE CASCADE`：删除主表记录时，自动删除从表相关记录
- `ON DELETE SET NULL`：删除主表记录时，从表外键设为NULL

## 📊 表结构详解

### users（用户表）

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|--------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) | NOT NULL, UNIQUE | 用户名 |
| password | VARCHAR(100) | NOT NULL | 密码（BCrypt加密） |
| hotel_name | VARCHAR(100) | NOT NULL | 酒店名称 |
| phone | VARCHAR(20) | - | 电话号码 |
| email | VARCHAR(100) | - | 邮箱地址 |
| avatar | VARCHAR(100) | - | 头像URL |
| enabled | BOOLEAN | NOT NULL, DEFAULT TRUE | 账号是否启用 |
| phone_verified | BOOLEAN | NOT NULL, DEFAULT FALSE | 电话是否已验证 |
| email_verified | BOOLEAN | NOT NULL, DEFAULT FALSE | 邮箱是否已验证 |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL, ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**索引**：
- `idx_username`：用户名唯一索引
- `idx_email`：邮箱索引
- `idx_phone`：电话号码索引
- `idx_enabled`：启用状态索引

### chat_sessions（聊天会话表）

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|--------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 会话ID |
| user_id | BIGINT | NOT NULL, FOREIGN KEY | 用户ID |
| session_id | VARCHAR(100) | NOT NULL, UNIQUE | 会话唯一标识 |
| title | VARCHAR(500) | - | 会话标题 |
| message_count | INT | NOT NULL, DEFAULT 0 | 消息数量 |
| model | VARCHAR(20) | - | 使用的AI模型 |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL, ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**索引**：
- `idx_user_id`：用户ID索引
- `idx_session_id`：会话ID唯一索引
- `idx_created_at`：创建时间索引
- `idx_chat_sessions_user_updated`：用户+更新时间复合索引

### chat_messages（聊天消息表）

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|--------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 消息ID |
| session_id | BIGINT | NOT NULL, FOREIGN KEY | 会话ID |
| role | VARCHAR(20) | NOT NULL | 角色（user/assistant/system） |
| content | TEXT | NOT NULL | 消息内容 |
| model | VARCHAR(20) | - | 使用的AI模型 |
| prompt_tokens | INT | - | 提示词Token数 |
| completion_tokens | INT | - | 完成Token数 |
| total_tokens | INT | - | 总Token数 |
| processing_time | BIGINT | - | 处理时间（毫秒） |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP | 创建时间 |

**索引**：
- `idx_session_id`：会话ID索引
- `idx_created_at`：创建时间索引
- `idx_role`：角色索引
- `idx_chat_messages_session_created`：会话+创建时间复合索引

## 🔍 视图使用示例

### v_user_session_stats（用户会话统计）

```sql
-- 查询所有用户的会话统计
SELECT * FROM v_user_session_stats;

-- 查询活跃用户
SELECT * FROM v_user_session_stats 
WHERE activity_status = 'ACTIVE';

-- 查询休眠用户
SELECT * FROM v_user_session_stats 
WHERE activity_status = 'DORMANT';
```

### v_daily_usage_stats（每日使用统计）

```sql
-- 查询最近7天的使用统计
SELECT * FROM v_daily_usage_stats 
WHERE stat_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY stat_date DESC;

-- 查询特定模型的使用统计
SELECT * FROM v_daily_usage_stats 
WHERE model = 'qwen-turbo'
ORDER BY stat_date DESC;
```

### v_active_users（活跃用户）

```sql
-- 查询所有活跃用户
SELECT * FROM v_active_users;

-- 查询最近有会话的活跃用户
SELECT * FROM v_active_users 
WHERE recent_sessions > 0;
```

## ⚙️ 存储过程使用示例

### sp_clean_expired_sessions（清理过期会话）

```sql
-- 清理30天前的会话
CALL sp_clean_expired_sessions(30);

-- 清理90天前的会话
CALL sp_clean_expired_sessions(90);
```

### sp_update_user_stats（更新用户统计）

```sql
-- 更新指定用户今天的统计
CALL sp_update_user_stats(1, CURDATE());

-- 更新指定用户昨天的统计
CALL sp_update_user_stats(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY));
```

### sp_get_session_summary（获取会话摘要）

```sql
-- 获取会话摘要
CALL sp_get_session_summary(1);
```

### sp_calculate_daily_stats（计算每日统计）

```sql
-- 计算今天的统计
CALL sp_calculate_daily_stats(CURDATE());

-- 计算昨天的统计
CALL sp_calculate_daily_stats(DATE_SUB(CURDATE(), INTERVAL 1 DAY));
```

## 🔒 安全建议

### 1. 用户权限管理

```sql
-- 创建只读用户
CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'readonly_password';
GRANT SELECT ON ai_hotel_dev.* TO 'readonly_user'@'%';

-- 创建应用用户（仅必要权限）
CREATE USER 'app_user'@'%' IDENTIFIED BY 'app_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_hotel_dev.* TO 'app_user'@'%';

-- 删除不必要的权限
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_hotel_dev.* TO 'app_user'@'%';
FLUSH PRIVILEGES;
```

### 2. 数据加密

- 密码使用BCrypt加密（成本因子10）
- 敏感信息不存储明文
- 使用SSL连接数据库

### 3. 审计日志

所有重要操作都会记录到 `audit_logs` 表：
- 用户登录
- API调用
- 数据修改
- 配置变更

## 📈 性能优化建议

### 1. 索引优化

```sql
-- 分析表统计信息
ANALYZE TABLE users;
ANALYZE TABLE chat_sessions;
ANALYZE TABLE chat_messages;
ANALYZE TABLE audit_logs;
ANALYZE TABLE api_usage_stats;

-- 检查索引使用情况
SHOW INDEX FROM users;
SHOW INDEX FROM chat_sessions;
SHOW INDEX FROM chat_messages;
```

### 2. 查询优化

```sql
-- 使用EXPLAIN分析查询
EXPLAIN SELECT * FROM chat_messages 
WHERE session_id = 1 
ORDER BY created_at DESC;

-- 查看慢查询日志
SHOW VARIABLES LIKE 'slow_query_log';
```

### 3. 配置优化

```ini
[mysqld]
# InnoDB缓冲池大小（建议为物理内存的70-80%）
innodb_buffer_pool_size = 2G

# 日志文件大小
innodb_log_file_size = 256M

# 最大连接数
max_connections = 500

# 查询缓存
query_cache_size = 64M
query_cache_type = 1

# 慢查询日志
slow_query_log = /var/log/mysql/slow-query.log
long_query_time = 2
```

## 🔄 数据迁移

### 从旧版本升级

```sql
-- 备份现有数据
CREATE TABLE users_backup AS SELECT * FROM users;
CREATE TABLE chat_sessions_backup AS SELECT * FROM chat_sessions;
CREATE TABLE chat_messages_backup AS SELECT * FROM chat_messages;

-- 执行新的schema
source complete-schema.sql;

-- 迁移数据
INSERT INTO users (username, password, hotel_name, phone, email, enabled, phone_verified, email_verified, created_at, updated_at)
SELECT username, password, hotel_name, phone, email, enabled, phone_verified, email_verified, created_at, updated_at
FROM users_backup
ON DUPLICATE KEY UPDATE username = VALUES(username);

-- 删除备份表
DROP TABLE users_backup;
DROP TABLE chat_sessions_backup;
DROP TABLE chat_messages_backup;
```

## 📝 维护脚本

### 每日维护

```bash
#!/bin/bash
# daily-maintenance.sh

DATE=$(date +%Y%m%d)

# 备份数据库
mysqldump -u root -p ai_hotel_prod > /backup/daily/ai_hotel_$DATE.sql

# 清理过期日志
mysql -u root -p ai_hotel_prod -e "DELETE FROM audit_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);"

# 优化表
mysql -u root -p ai_hotel_prod -e "OPTIMIZE TABLE users, chat_sessions, chat_messages, audit_logs, api_usage_stats;"

# 分析表
mysql -u root -p ai_hotel_prod -e "ANALYZE TABLE users, chat_sessions, chat_messages, audit_logs, api_usage_stats;"
```

### 每周维护

```bash
#!/bin/bash
# weekly-maintenance.sh

DATE=$(date +%Y%m%d)

# 全量备份
mysqldump -u root -p --single-transaction --routines --triggers ai_hotel_prod > /backup/weekly/ai_hotel_$DATE.sql

# 检查表完整性
mysql -u root -p ai_hotel_prod -e "CHECK TABLE users, chat_sessions, chat_messages, audit_logs, api_usage_stats;"

# 重建索引（如果需要）
mysql -u root -p ai_hotel_prod -e "ALTER TABLE chat_messages ENGINE=InnoDB;"
```

## 🚨 故障排查

### 常见问题

**Q1: 执行SQL文件时报错 "Unknown database"**
```sql
-- 解决方案：先创建数据库
CREATE DATABASE IF NOT EXISTS ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ai_hotel_dev;
```

**Q2: 外键约束错误**
```sql
-- 解决方案：检查父表数据是否存在
SELECT * FROM users WHERE id = 1;
SELECT * FROM chat_sessions WHERE id = 1;
```

**Q3: 字符集错误**
```sql
-- 解决方案：确保数据库和表使用相同的字符集
ALTER DATABASE ai_hotel_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

**Q4: 触发器创建失败**
```sql
-- 解决方案：检查是否已存在同名触发器
SHOW TRIGGERS LIKE 'trg_%';
DROP TRIGGER IF EXISTS trg_update_message_count;
```

## 📞 技术支持

如有问题，请联系：
- 数据库问题：db-admin@aihotel.com
- 性能问题：perf-team@aihotel.com
- 安全问题：security@aihotel.com

---

**文档版本**: 1.0.0  
**最后更新**: 2026-01-20  
**维护者**: AI Hotel Database Team
