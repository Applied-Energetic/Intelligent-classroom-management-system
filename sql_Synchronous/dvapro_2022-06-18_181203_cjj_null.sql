/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ dvapro /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE dvapro;

DROP TABLE IF EXISTS auth_group;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS auth_group_permissions;
CREATE TABLE `auth_group_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS auth_permission;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS captcha_captchastore;
CREATE TABLE `captcha_captchastore` (
  `id` int NOT NULL AUTO_INCREMENT,
  `challenge` varchar(32) NOT NULL,
  `response` varchar(32) NOT NULL,
  `hashkey` varchar(40) NOT NULL,
  `expiration` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hashkey` (`hashkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS django_content_type;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS django_migrations;
CREATE TABLE `django_migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS django_session;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_api_white_list;
CREATE TABLE `dvadmin_api_white_list` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `url` varchar(200) NOT NULL COMMENT 'url地址',
  `method` int DEFAULT NULL COMMENT '接口请求方法',
  `enable_datasource` tinyint(1) NOT NULL COMMENT '激活数据权限',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_api_white_list_creator_id_fd335789` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_area;
CREATE TABLE `dvadmin_area` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `code` varchar(20) NOT NULL COMMENT '地区编码',
  `level` bigint NOT NULL COMMENT '地区层级(1省份 2城市 3区县 4乡级)',
  `pinyin` varchar(255) NOT NULL COMMENT '拼音',
  `initials` varchar(20) NOT NULL COMMENT '首字母',
  `enable` tinyint(1) NOT NULL COMMENT '是否启用',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `pcode_id` varchar(20) DEFAULT NULL COMMENT '父地区编码',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `dvadmin_area_creator_id_c385aa52` (`creator_id`),
  KEY `dvadmin_area_pcode_id_7984eedf` (`pcode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_dictionary;
CREATE TABLE `dvadmin_dictionary` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `code` varchar(100) DEFAULT NULL COMMENT '编码',
  `label` varchar(100) DEFAULT NULL COMMENT '显示名称',
  `value` varchar(100) DEFAULT NULL COMMENT '实际值',
  `status` tinyint(1) NOT NULL COMMENT '状态',
  `sort` int DEFAULT NULL COMMENT '显示排序',
  `remark` varchar(2000) DEFAULT NULL COMMENT '备注',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '父级',
  PRIMARY KEY (`id`),
  KEY `dvadmin_dictionary_creator_id_a76540f5` (`creator_id`),
  KEY `dvadmin_dictionary_parent_id_13040134` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_file_list;
CREATE TABLE `dvadmin_file_list` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `url` varchar(100) NOT NULL,
  `md5sum` varchar(36) NOT NULL COMMENT '文件md5',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_file_list_creator_id_4aaf48a9` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_book;
CREATE TABLE `dvadmin_system_book` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `booker` varchar(40) NOT NULL COMMENT '姓名',
  `name` varchar(64) DEFAULT NULL COMMENT '教室名称',
  `phone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `need` tinyint(1) DEFAULT NULL COMMENT '教室状态',
  `opinion` int NOT NULL COMMENT '管理员审批',
  `begin_date` datetime(6) DEFAULT NULL COMMENT '预订日期',
  `end_time` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `reason` varchar(256) NOT NULL COMMENT '申请理由',
  `sort` int NOT NULL COMMENT '显示排序',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '上级教室',
  `role_id` bigint DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_book_creator_id_82076ba5` (`creator_id`),
  KEY `dvadmin_system_book_parent_id_e301de02` (`parent_id`),
  KEY `dvadmin_system_book_role_id_f3b93c32` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_book_dept;
CREATE TABLE `dvadmin_system_book_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_book_dept_book_id_dept_id_d0df72d1_uniq` (`book_id`,`dept_id`),
  KEY `dvadmin_system_book_dept_book_id_6a6d06be` (`book_id`),
  KEY `dvadmin_system_book_dept_dept_id_772943fd` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_button;
CREATE TABLE `dvadmin_system_button` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '权限名称',
  `value` varchar(64) NOT NULL COMMENT '权限值',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `value` (`value`),
  KEY `dvadmin_system_button_creator_id_c620108d` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_config;
CREATE TABLE `dvadmin_system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `title` varchar(50) NOT NULL COMMENT '标题',
  `key` varchar(20) NOT NULL COMMENT '键',
  `value` json DEFAULT NULL COMMENT '值',
  `sort` int NOT NULL COMMENT '排序',
  `status` tinyint(1) NOT NULL COMMENT '启用状态',
  `data_options` json DEFAULT NULL COMMENT '数据options',
  `form_item_type` int NOT NULL COMMENT '表单类型',
  `rule` json DEFAULT NULL COMMENT '校验规则',
  `placeholder` varchar(50) DEFAULT NULL COMMENT '提示信息',
  `setting` json DEFAULT NULL COMMENT '配置',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '父级',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_config_creator_id_ba7fd60a` (`creator_id`),
  KEY `dvadmin_system_config_parent_id_1ff841b5` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_course;
CREATE TABLE `dvadmin_system_course` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '姓名',
  `avatar` varchar(255) DEFAULT NULL COMMENT '学生照片',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `cname` varchar(64) NOT NULL COMMENT '课程名称',
  `sort` int NOT NULL COMMENT '显示排序',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_course_creator_id_bbb131aa` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_course_dept;
CREATE TABLE `dvadmin_system_course_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_course_dept_course_id_dept_id_d3d97a00_uniq` (`course_id`,`dept_id`),
  KEY `dvadmin_system_course_dept_course_id_07f9cbe9` (`course_id`),
  KEY `dvadmin_system_course_dept_dept_id_d154f8a7` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_dept;
CREATE TABLE `dvadmin_system_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '子权限',
  `sort` int NOT NULL COMMENT '排序',
  `owner` varchar(32) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '总权限',
  `tools` varchar(32) DEFAULT NULL COMMENT '设备',
  `uses` varchar(16) NOT NULL COMMENT '使用情况',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_dept_creator_id_e69fd1ae` (`creator_id`),
  KEY `dvadmin_system_dept_parent_id_0f9eb419` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_kecheng;
CREATE TABLE `dvadmin_system_kecheng` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '班级名称',
  `image` varchar(255) DEFAULT NULL COMMENT '出勤照片',
  `sort` int NOT NULL COMMENT '显示排序',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_Kecheng_creator_id_207ab253` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_kecheng_dept;
CREATE TABLE `dvadmin_system_kecheng_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kecheng_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_Kecheng_dept_kecheng_id_dept_id_ea45ac5d_uniq` (`kecheng_id`,`dept_id`),
  KEY `dvadmin_system_Kecheng_dept_kecheng_id_56b1b3fb` (`kecheng_id`),
  KEY `dvadmin_system_Kecheng_dept_dept_id_ab62d3a3` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_login_log;
CREATE TABLE `dvadmin_system_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `username` varchar(32) DEFAULT NULL COMMENT '登录用户名',
  `ip` varchar(32) DEFAULT NULL COMMENT '登录ip',
  `agent` longtext COMMENT 'agent信息',
  `browser` varchar(200) DEFAULT NULL COMMENT '浏览器名',
  `os` varchar(200) DEFAULT NULL COMMENT '操作系统',
  `continent` varchar(50) DEFAULT NULL COMMENT '州',
  `country` varchar(50) DEFAULT NULL COMMENT '国家',
  `province` varchar(50) DEFAULT NULL COMMENT '省份',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `district` varchar(50) DEFAULT NULL COMMENT '县区',
  `isp` varchar(50) DEFAULT NULL COMMENT '运营商',
  `area_code` varchar(50) DEFAULT NULL COMMENT '区域代码',
  `country_english` varchar(50) DEFAULT NULL COMMENT '英文全称',
  `country_code` varchar(50) DEFAULT NULL COMMENT '简称',
  `longitude` varchar(50) DEFAULT NULL COMMENT '经度',
  `latitude` varchar(50) DEFAULT NULL COMMENT '纬度',
  `login_type` int NOT NULL COMMENT '登录类型',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_login_log_creator_id_5f6dc165` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_menu;
CREATE TABLE `dvadmin_system_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `icon` varchar(64) DEFAULT NULL COMMENT '菜单图标',
  `name` varchar(64) NOT NULL COMMENT '菜单名称',
  `sort` int DEFAULT NULL COMMENT '显示排序',
  `is_link` tinyint(1) NOT NULL COMMENT '是否外链',
  `is_catalog` tinyint(1) NOT NULL COMMENT '是否目录',
  `web_path` varchar(128) DEFAULT NULL COMMENT '路由地址',
  `component` varchar(128) DEFAULT NULL COMMENT '组件地址',
  `component_name` varchar(50) DEFAULT NULL COMMENT '组件名称',
  `status` tinyint(1) NOT NULL COMMENT '菜单状态',
  `cache` tinyint(1) NOT NULL COMMENT '是否页面缓存',
  `visible` tinyint(1) NOT NULL COMMENT '侧边栏中是否显示',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '上级菜单',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_menu_creator_id_430cdc1c` (`creator_id`),
  KEY `dvadmin_system_menu_parent_id_bc6f21bc` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_menu_button;
CREATE TABLE `dvadmin_system_menu_button` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `value` varchar(64) NOT NULL COMMENT '权限值',
  `api` varchar(200) NOT NULL COMMENT '接口地址',
  `method` int DEFAULT NULL COMMENT '接口请求方法',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `menu_id` bigint NOT NULL COMMENT '关联菜单',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_menu_button_creator_id_3df058f7` (`creator_id`),
  KEY `dvadmin_system_menu_button_menu_id_f6aafcd8` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_message;
CREATE TABLE `dvadmin_system_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '课程名',
  `cclass` varchar(255) DEFAULT NULL COMMENT '上课班级',
  `teacher` varchar(64) NOT NULL COMMENT '任课教师',
  `num` int NOT NULL COMMENT '上课次数',
  `roomID` int DEFAULT NULL COMMENT '教室ID',
  `weekDay` int DEFAULT NULL COMMENT '星期',
  `slot` int DEFAULT NULL COMMENT '时间',
  `sort` int NOT NULL COMMENT '显示排序',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_Message_creator_id_1a102e94` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_message_dept;
CREATE TABLE `dvadmin_system_message_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_Message_dept_message_id_dept_id_67105751_uniq` (`message_id`,`dept_id`),
  KEY `dvadmin_system_Message_dept_message_id_57a612ba` (`message_id`),
  KEY `dvadmin_system_Message_dept_dept_id_eaeb1d46` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_operation_log;
CREATE TABLE `dvadmin_system_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `request_modular` varchar(64) DEFAULT NULL COMMENT '请求模块',
  `request_path` varchar(400) DEFAULT NULL COMMENT '请求地址',
  `request_body` longtext COMMENT '请求参数',
  `request_method` varchar(8) DEFAULT NULL COMMENT '请求方式',
  `request_msg` longtext COMMENT '操作说明',
  `request_ip` varchar(32) DEFAULT NULL COMMENT '请求ip地址',
  `request_browser` varchar(64) DEFAULT NULL COMMENT '请求浏览器',
  `response_code` varchar(32) DEFAULT NULL COMMENT '响应状态码',
  `request_os` varchar(64) DEFAULT NULL COMMENT '操作系统',
  `json_result` longtext COMMENT '返回信息',
  `status` tinyint(1) NOT NULL COMMENT '响应状态',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_operation_log_creator_id_0914479c` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_post;
CREATE TABLE `dvadmin_system_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '岗位名称',
  `code` varchar(32) NOT NULL COMMENT '岗位编码',
  `sort` int NOT NULL COMMENT '岗位顺序',
  `status` int NOT NULL COMMENT '岗位状态',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_post_creator_id_b5ef9351` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_role;
CREATE TABLE `dvadmin_system_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '角色名称',
  `key` varchar(64) NOT NULL COMMENT '权限字符',
  `sort` int NOT NULL COMMENT '角色顺序',
  `status` tinyint(1) NOT NULL COMMENT '角色状态',
  `admin` tinyint(1) NOT NULL COMMENT '是否为admin',
  `data_range` int NOT NULL COMMENT '数据权限范围',
  `remark` longtext COMMENT '备注',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `dvadmin_system_role_creator_id_a89a9bc7` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_role_dept;
CREATE TABLE `dvadmin_system_role_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_role_dept_role_id_dept_id_524d7fba_uniq` (`role_id`,`dept_id`),
  KEY `dvadmin_system_role_dept_role_id_4f737c95` (`role_id`),
  KEY `dvadmin_system_role_dept_dept_id_d719761c` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_role_menu;
CREATE TABLE `dvadmin_system_role_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_role_menu_role_id_menu_id_06192289_uniq` (`role_id`,`menu_id`),
  KEY `dvadmin_system_role_menu_role_id_dcc80258` (`role_id`),
  KEY `dvadmin_system_role_menu_menu_id_7bbf1cb9` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_role_permission;
CREATE TABLE `dvadmin_system_role_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `menubutton_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_role_perm_role_id_menubutton_id_46c1e3ca_uniq` (`role_id`,`menubutton_id`),
  KEY `dvadmin_system_role_permission_role_id_bf988ad5` (`role_id`),
  KEY `dvadmin_system_role_permission_menubutton_id_7ba32ee0` (`menubutton_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_room;
CREATE TABLE `dvadmin_system_room` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '教室名称',
  `sort` int NOT NULL COMMENT '排序',
  `owner` varchar(32) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `tools` varchar(32) DEFAULT NULL COMMENT '设备',
  `message` varchar(32) DEFAULT NULL COMMENT '使用须知',
  `status` tinyint(1) DEFAULT NULL COMMENT '教室状态',
  `large` int DEFAULT NULL COMMENT '教室容量',
  `uses` varchar(16) NOT NULL COMMENT '使用情况',
  `avatar` varchar(255) DEFAULT NULL COMMENT '出勤照片',
  `number` int NOT NULL COMMENT '出勤人数',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `parent_id` bigint DEFAULT NULL COMMENT '上级教室',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_room_creator_id_91a475bc` (`creator_id`),
  KEY `dvadmin_system_room_parent_id_be0fcfe4` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_room_dept;
CREATE TABLE `dvadmin_system_room_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_room_dept_room_id_dept_id_4646592f_uniq` (`room_id`,`dept_id`),
  KEY `dvadmin_system_room_dept_room_id_9c538be6` (`room_id`),
  KEY `dvadmin_system_room_dept_dept_id_22f34302` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_student;
CREATE TABLE `dvadmin_system_student` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '课程名称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '出勤照片',
  `number` int NOT NULL COMMENT '出勤人数',
  `sort` int NOT NULL COMMENT '显示排序',
  `absence` varchar(255) DEFAULT NULL COMMENT '缺勤名单',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_student_creator_id_b6493985` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_student_dept;
CREATE TABLE `dvadmin_system_student_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_student_dept_student_id_dept_id_fafd9e28_uniq` (`student_id`,`dept_id`),
  KEY `dvadmin_system_student_dept_student_id_4a7fb86c` (`student_id`),
  KEY `dvadmin_system_student_dept_dept_id_310a36a1` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users;
CREATE TABLE `dvadmin_system_users` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL COMMENT 'Designates that this user has all permissions without explicitly assigning them.',
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL COMMENT 'Designates whether the user can log into this admin site.',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '用户状态',
  `date_joined` datetime(6) NOT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(255) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `username` varchar(150) NOT NULL COMMENT '用户账号',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(255) DEFAULT NULL COMMENT '电话',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `name` varchar(40) NOT NULL COMMENT '姓名',
  `gender` int DEFAULT NULL COMMENT '性别',
  `user_type` int DEFAULT NULL COMMENT '用户类型',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `dept_id` bigint DEFAULT NULL COMMENT '关联权限',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `dvadmin_system_users_creator_id_28556713` (`creator_id`),
  KEY `dvadmin_system_users_dept_id_b56f71f6` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users_groups;
CREATE TABLE `dvadmin_system_users_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_users_groups_users_id_group_id_7460f482_uniq` (`users_id`,`group_id`),
  KEY `dvadmin_system_users_groups_group_id_42e8a6dc_fk_auth_group_id` (`group_id`),
  CONSTRAINT `dvadmin_system_users_groups_group_id_42e8a6dc_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `dvadmin_system_users_users_id_f20fa5bc_fk_dvadmin_s` FOREIGN KEY (`users_id`) REFERENCES `dvadmin_system_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users_post;
CREATE TABLE `dvadmin_system_users_post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` bigint NOT NULL,
  `post_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_users_post_users_id_post_id_41f83b22_uniq` (`users_id`,`post_id`),
  KEY `dvadmin_system_users_post_users_id_8ab2e760` (`users_id`),
  KEY `dvadmin_system_users_post_post_id_50054985` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users_role;
CREATE TABLE `dvadmin_system_users_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_users_role_users_id_role_id_02908e92_uniq` (`users_id`,`role_id`),
  KEY `dvadmin_system_users_role_users_id_a25207bc` (`users_id`),
  KEY `dvadmin_system_users_role_role_id_e37d9591` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users_user_permissions;
CREATE TABLE `dvadmin_system_users_user_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dvadmin_system_users_use_users_id_permission_id_24cd72ef_uniq` (`users_id`,`permission_id`),
  KEY `dvadmin_system_users_permission_id_c8ec58dc_fk_auth_perm` (`permission_id`),
  CONSTRAINT `dvadmin_system_users_permission_id_c8ec58dc_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `dvadmin_system_users_users_id_fd3b0217_fk_dvadmin_s` FOREIGN KEY (`users_id`) REFERENCES `dvadmin_system_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



INSERT INTO auth_permission(id,name,content_type_id,codename) VALUES(1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can view permission',1,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add 用户表',5,'add_users'),(18,'Can change 用户表',5,'change_users'),(19,'Can delete 用户表',5,'delete_users'),(20,'Can view 用户表',5,'view_users'),(21,'Can add 权限表',6,'add_dept'),(22,'Can change 权限表',6,'change_dept'),(23,'Can delete 权限表',6,'delete_dept'),(24,'Can view 权限表',6,'view_dept'),(25,'Can add 菜单表',7,'add_menu'),(26,'Can change 菜单表',7,'change_menu'),(27,'Can delete 菜单表',7,'delete_menu'),(28,'Can view 菜单表',7,'view_menu'),(29,'Can add 菜单权限表',8,'add_menubutton'),(30,'Can change 菜单权限表',8,'change_menubutton'),(31,'Can delete 菜单权限表',8,'delete_menubutton'),(32,'Can view 菜单权限表',8,'view_menubutton'),(33,'Can add 系统配置表',9,'add_systemconfig'),(34,'Can change 系统配置表',9,'change_systemconfig'),(35,'Can delete 系统配置表',9,'delete_systemconfig'),(36,'Can view 系统配置表',9,'view_systemconfig'),(37,'Can add 角色表',10,'add_role'),(38,'Can change 角色表',10,'change_role'),(39,'Can delete 角色表',10,'delete_role'),(40,'Can view 角色表',10,'view_role'),(41,'Can add 岗位表',11,'add_post'),(42,'Can change 岗位表',11,'change_post'),(43,'Can delete 岗位表',11,'delete_post'),(44,'Can view 岗位表',11,'view_post'),(45,'Can add 操作日志',12,'add_operationlog'),(46,'Can change 操作日志',12,'change_operationlog'),(47,'Can delete 操作日志',12,'delete_operationlog'),(48,'Can view 操作日志',12,'view_operationlog'),(49,'Can add 登录日志',13,'add_loginlog'),(50,'Can change 登录日志',13,'change_loginlog'),(51,'Can delete 登录日志',13,'delete_loginlog'),(52,'Can view 登录日志',13,'view_loginlog'),(53,'Can add 文件管理',14,'add_filelist'),(54,'Can change 文件管理',14,'change_filelist'),(55,'Can delete 文件管理',14,'delete_filelist'),(56,'Can view 文件管理',14,'view_filelist'),(57,'Can add 字典表',15,'add_dictionary'),(58,'Can change 字典表',15,'change_dictionary'),(59,'Can delete 字典表',15,'delete_dictionary'),(60,'Can view 字典表',15,'view_dictionary'),(61,'Can add 权限标识表',16,'add_button'),(62,'Can change 权限标识表',16,'change_button'),(63,'Can delete 权限标识表',16,'delete_button'),(64,'Can view 权限标识表',16,'view_button'),(65,'Can add 地区表',17,'add_area'),(66,'Can change 地区表',17,'change_area'),(67,'Can delete 地区表',17,'delete_area'),(68,'Can view 地区表',17,'view_area'),(69,'Can add 接口白名单',18,'add_apiwhitelist'),(70,'Can change 接口白名单',18,'change_apiwhitelist'),(71,'Can delete 接口白名单',18,'delete_apiwhitelist'),(72,'Can view 接口白名单',18,'view_apiwhitelist'),(73,'Can add 出勤表',19,'add_student'),(74,'Can change 出勤表',19,'change_student'),(75,'Can delete 出勤表',19,'delete_student'),(76,'Can view 出勤表',19,'view_student'),(77,'Can add 教室表',20,'add_room'),(78,'Can change 教室表',20,'change_room'),(79,'Can delete 教室表',20,'delete_room'),(80,'Can view 教室表',20,'view_room'),(81,'Can add 信息表',21,'add_message'),(82,'Can change 信息表',21,'change_message'),(83,'Can delete 信息表',21,'delete_message'),(84,'Can view 信息表',21,'view_message'),(85,'Can add 课表表',22,'add_kecheng'),(86,'Can change 课表表',22,'change_kecheng'),(87,'Can delete 课表表',22,'delete_kecheng'),(88,'Can view 课表表',22,'view_kecheng'),(89,'Can add 选课表',23,'add_course'),(90,'Can change 选课表',23,'change_course'),(91,'Can delete 选课表',23,'delete_course'),(92,'Can view 选课表',23,'view_course'),(93,'Can add 预定表',24,'add_book'),(94,'Can change 预定表',24,'change_book'),(95,'Can delete 预定表',24,'delete_book'),(96,'Can view 预定表',24,'view_book'),(97,'Can add captcha store',25,'add_captchastore'),(98,'Can change captcha store',25,'change_captchastore'),(99,'Can delete captcha store',25,'delete_captchastore'),(100,'Can view captcha store',25,'view_captchastore');


INSERT INTO django_content_type(id,app_label,model) VALUES(2,'auth','group'),(1,'auth','permission'),(25,'captcha','captchastore'),(3,'contenttypes','contenttype'),(4,'sessions','session'),(18,'system','apiwhitelist'),(17,'system','area'),(24,'system','book'),(16,'system','button'),(23,'system','course'),(6,'system','dept'),(15,'system','dictionary'),(14,'system','filelist'),(22,'system','kecheng'),(13,'system','loginlog'),(7,'system','menu'),(8,'system','menubutton'),(21,'system','message'),(12,'system','operationlog'),(11,'system','post'),(10,'system','role'),(20,'system','room'),(19,'system','student'),(9,'system','systemconfig'),(5,'system','users');

INSERT INTO django_migrations(id,app,name,applied) VALUES(1,'contenttypes','0001_initial','2022-06-18 18:11:30.761739'),(2,'contenttypes','0002_remove_content_type_name','2022-06-18 18:11:30.864565'),(3,'auth','0001_initial','2022-06-18 18:11:31.109643'),(4,'auth','0002_alter_permission_name_max_length','2022-06-18 18:11:31.168485'),(5,'auth','0003_alter_user_email_max_length','2022-06-18 18:11:31.177459'),(6,'auth','0004_alter_user_username_opts','2022-06-18 18:11:31.188433'),(7,'auth','0005_alter_user_last_login_null','2022-06-18 18:11:31.200398'),(8,'auth','0006_require_contenttypes_0002','2022-06-18 18:11:31.206387'),(9,'auth','0007_alter_validators_add_error_messages','2022-06-18 18:11:31.226362'),(10,'auth','0008_alter_user_username_max_length','2022-06-18 18:11:31.241323'),(11,'auth','0009_alter_user_last_name_max_length','2022-06-18 18:11:31.258245'),(12,'auth','0010_alter_group_name_max_length','2022-06-18 18:11:31.286185'),(13,'auth','0011_update_proxy_permissions','2022-06-18 18:11:31.298155'),(14,'auth','0012_alter_user_first_name_max_length','2022-06-18 18:11:31.308157'),(15,'captcha','0001_initial','2022-06-18 18:11:31.351672'),(16,'captcha','0002_alter_captchastore_id','2022-06-18 18:11:31.357683'),(17,'sessions','0001_initial','2022-06-18 18:11:31.405990'),(18,'system','0001_initial','2022-06-18 18:11:33.356464'),(19,'system','0002_auto_20220618_1811','2022-06-18 18:11:34.721203');
































