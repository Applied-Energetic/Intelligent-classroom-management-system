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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `url` varchar(200) NOT NULL COMMENT 'url??????',
  `method` int DEFAULT NULL COMMENT '??????????????????',
  `enable_datasource` tinyint(1) NOT NULL COMMENT '??????????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_api_white_list_creator_id_fd335789` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_area;
CREATE TABLE `dvadmin_area` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(100) NOT NULL COMMENT '??????',
  `code` varchar(20) NOT NULL COMMENT '????????????',
  `level` bigint NOT NULL COMMENT '????????????(1?????? 2?????? 3?????? 4??????)',
  `pinyin` varchar(255) NOT NULL COMMENT '??????',
  `initials` varchar(20) NOT NULL COMMENT '?????????',
  `enable` tinyint(1) NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `pcode_id` varchar(20) DEFAULT NULL COMMENT '???????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `dvadmin_area_creator_id_c385aa52` (`creator_id`),
  KEY `dvadmin_area_pcode_id_7984eedf` (`pcode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_dictionary;
CREATE TABLE `dvadmin_dictionary` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `code` varchar(100) DEFAULT NULL COMMENT '??????',
  `label` varchar(100) DEFAULT NULL COMMENT '????????????',
  `value` varchar(100) DEFAULT NULL COMMENT '?????????',
  `status` tinyint(1) NOT NULL COMMENT '??????',
  `sort` int DEFAULT NULL COMMENT '????????????',
  `remark` varchar(2000) DEFAULT NULL COMMENT '??????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `parent_id` bigint DEFAULT NULL COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_dictionary_creator_id_a76540f5` (`creator_id`),
  KEY `dvadmin_dictionary_parent_id_13040134` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_file_list;
CREATE TABLE `dvadmin_file_list` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(50) DEFAULT NULL COMMENT '??????',
  `url` varchar(100) NOT NULL,
  `md5sum` varchar(36) NOT NULL COMMENT '??????md5',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_file_list_creator_id_4aaf48a9` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_book;
CREATE TABLE `dvadmin_system_book` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `booker` varchar(40) NOT NULL COMMENT '??????',
  `name` varchar(64) DEFAULT NULL COMMENT '????????????',
  `phone` varchar(32) DEFAULT NULL COMMENT '????????????',
  `email` varchar(32) DEFAULT NULL COMMENT '??????',
  `need` tinyint(1) DEFAULT NULL COMMENT '????????????',
  `opinion` int NOT NULL COMMENT '???????????????',
  `begin_date` datetime(6) DEFAULT NULL COMMENT '????????????',
  `end_time` datetime(6) DEFAULT NULL COMMENT '????????????',
  `reason` varchar(256) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `dept_id` bigint DEFAULT NULL COMMENT '????????????',
  `role_id` bigint DEFAULT NULL COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_book_creator_id_82076ba5` (`creator_id`),
  KEY `dvadmin_system_book_dept_id_5062a2e4` (`dept_id`),
  KEY `dvadmin_system_book_role_id_f3b93c32` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_button;
CREATE TABLE `dvadmin_system_button` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `value` varchar(64) NOT NULL COMMENT '?????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `value` (`value`),
  KEY `dvadmin_system_button_creator_id_c620108d` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_cbook;
CREATE TABLE `dvadmin_system_cbook` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `booker` varchar(40) NOT NULL COMMENT '??????',
  `name` varchar(64) DEFAULT NULL COMMENT '????????????',
  `phone` varchar(32) DEFAULT NULL COMMENT '????????????',
  `email` varchar(32) DEFAULT NULL COMMENT '??????',
  `need` tinyint(1) DEFAULT NULL COMMENT '????????????',
  `opinion` int NOT NULL COMMENT '???????????????',
  `begin_date` datetime(6) DEFAULT NULL COMMENT '????????????',
  `end_time` datetime(6) DEFAULT NULL COMMENT '????????????',
  `reason` varchar(256) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `parent_id` bigint DEFAULT NULL COMMENT '????????????',
  `role_id` bigint DEFAULT NULL COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_cbook_creator_id_2c67019b` (`creator_id`),
  KEY `dvadmin_system_cbook_parent_id_aab9cddc` (`parent_id`),
  KEY `dvadmin_system_cbook_role_id_08b648dc` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_config;
CREATE TABLE `dvadmin_system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `title` varchar(50) NOT NULL COMMENT '??????',
  `key` varchar(20) NOT NULL COMMENT '???',
  `value` json DEFAULT NULL COMMENT '???',
  `sort` int NOT NULL COMMENT '??????',
  `status` tinyint(1) NOT NULL COMMENT '????????????',
  `data_options` json DEFAULT NULL COMMENT '??????options',
  `form_item_type` int NOT NULL COMMENT '????????????',
  `rule` json DEFAULT NULL COMMENT '????????????',
  `placeholder` varchar(50) DEFAULT NULL COMMENT '????????????',
  `setting` json DEFAULT NULL COMMENT '??????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `parent_id` bigint DEFAULT NULL COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_config_creator_id_ba7fd60a` (`creator_id`),
  KEY `dvadmin_system_config_parent_id_1ff841b5` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_course;
CREATE TABLE `dvadmin_system_course` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '??????',
  `avatar` varchar(255) DEFAULT NULL COMMENT '????????????',
  `email` varchar(255) DEFAULT NULL COMMENT '??????',
  `cname` varchar(64) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_course_creator_id_bbb131aa` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_dept;
CREATE TABLE `dvadmin_system_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '??????',
  `owner` varchar(32) DEFAULT NULL COMMENT '?????????',
  `phone` varchar(32) DEFAULT NULL COMMENT '????????????',
  `email` varchar(32) DEFAULT NULL COMMENT '??????',
  `status` tinyint(1) DEFAULT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `parent_id` bigint DEFAULT NULL COMMENT '????????????',
  `avatar` varchar(255) DEFAULT NULL COMMENT '????????????',
  `large` int DEFAULT NULL COMMENT '????????????',
  `message` varchar(32) DEFAULT NULL COMMENT '????????????',
  `number` int NOT NULL COMMENT '????????????',
  `tools` varchar(32) DEFAULT NULL COMMENT '??????',
  `uses` varchar(16) NOT NULL COMMENT '????????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_dept_creator_id_e69fd1ae` (`creator_id`),
  KEY `dvadmin_system_dept_parent_id_0f9eb419` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_login_log;
CREATE TABLE `dvadmin_system_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `username` varchar(32) DEFAULT NULL COMMENT '???????????????',
  `ip` varchar(32) DEFAULT NULL COMMENT '??????ip',
  `agent` longtext COMMENT 'agent??????',
  `browser` varchar(200) DEFAULT NULL COMMENT '????????????',
  `os` varchar(200) DEFAULT NULL COMMENT '????????????',
  `continent` varchar(50) DEFAULT NULL COMMENT '???',
  `country` varchar(50) DEFAULT NULL COMMENT '??????',
  `province` varchar(50) DEFAULT NULL COMMENT '??????',
  `city` varchar(50) DEFAULT NULL COMMENT '??????',
  `district` varchar(50) DEFAULT NULL COMMENT '??????',
  `isp` varchar(50) DEFAULT NULL COMMENT '?????????',
  `area_code` varchar(50) DEFAULT NULL COMMENT '????????????',
  `country_english` varchar(50) DEFAULT NULL COMMENT '????????????',
  `country_code` varchar(50) DEFAULT NULL COMMENT '??????',
  `longitude` varchar(50) DEFAULT NULL COMMENT '??????',
  `latitude` varchar(50) DEFAULT NULL COMMENT '??????',
  `login_type` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_login_log_creator_id_5f6dc165` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_menu;
CREATE TABLE `dvadmin_system_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `icon` varchar(64) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `sort` int DEFAULT NULL COMMENT '????????????',
  `is_link` tinyint(1) NOT NULL COMMENT '????????????',
  `is_catalog` tinyint(1) NOT NULL COMMENT '????????????',
  `web_path` varchar(128) DEFAULT NULL COMMENT '????????????',
  `component` varchar(128) DEFAULT NULL COMMENT '????????????',
  `component_name` varchar(50) DEFAULT NULL COMMENT '????????????',
  `status` tinyint(1) NOT NULL COMMENT '????????????',
  `cache` tinyint(1) NOT NULL COMMENT '??????????????????',
  `visible` tinyint(1) NOT NULL COMMENT '????????????????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `parent_id` bigint DEFAULT NULL COMMENT '????????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_menu_creator_id_430cdc1c` (`creator_id`),
  KEY `dvadmin_system_menu_parent_id_bc6f21bc` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_menu_button;
CREATE TABLE `dvadmin_system_menu_button` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '??????',
  `value` varchar(64) NOT NULL COMMENT '?????????',
  `api` varchar(200) NOT NULL COMMENT '????????????',
  `method` int DEFAULT NULL COMMENT '??????????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `menu_id` bigint NOT NULL COMMENT '????????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_menu_button_creator_id_3df058f7` (`creator_id`),
  KEY `dvadmin_system_menu_button_menu_id_f6aafcd8` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_message;
CREATE TABLE `dvadmin_system_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '?????????',
  `cclass` varchar(255) DEFAULT NULL COMMENT '????????????',
  `teacher` varchar(64) NOT NULL COMMENT '????????????',
  `num` int NOT NULL COMMENT '????????????',
  `roomID` int DEFAULT NULL COMMENT '??????ID',
  `weekDay` int DEFAULT NULL COMMENT '??????',
  `slot` int DEFAULT NULL COMMENT '??????',
  `sort` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_Message_creator_id_1a102e94` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_operation_log;
CREATE TABLE `dvadmin_system_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `request_modular` varchar(64) DEFAULT NULL COMMENT '????????????',
  `request_path` varchar(400) DEFAULT NULL COMMENT '????????????',
  `request_body` longtext COMMENT '????????????',
  `request_method` varchar(8) DEFAULT NULL COMMENT '????????????',
  `request_msg` longtext COMMENT '????????????',
  `request_ip` varchar(32) DEFAULT NULL COMMENT '??????ip??????',
  `request_browser` varchar(64) DEFAULT NULL COMMENT '???????????????',
  `response_code` varchar(32) DEFAULT NULL COMMENT '???????????????',
  `request_os` varchar(64) DEFAULT NULL COMMENT '????????????',
  `json_result` longtext COMMENT '????????????',
  `status` tinyint(1) NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_operation_log_creator_id_0914479c` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_post;
CREATE TABLE `dvadmin_system_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `code` varchar(32) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `status` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_post_creator_id_b5ef9351` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_role;
CREATE TABLE `dvadmin_system_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `key` varchar(64) NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `status` tinyint(1) NOT NULL COMMENT '????????????',
  `admin` tinyint(1) NOT NULL COMMENT '?????????admin',
  `data_range` int NOT NULL COMMENT '??????????????????',
  `remark` longtext COMMENT '??????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
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

DROP TABLE IF EXISTS dvadmin_system_schedule;
CREATE TABLE `dvadmin_system_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `image` varchar(255) DEFAULT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_Schedule_creator_id_d0f10415` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_student;
CREATE TABLE `dvadmin_system_student` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `name` varchar(64) NOT NULL COMMENT '????????????',
  `avatar` varchar(255) DEFAULT NULL COMMENT '????????????',
  `number` int NOT NULL COMMENT '????????????',
  `sort` int NOT NULL COMMENT '????????????',
  `absence` varchar(255) DEFAULT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  PRIMARY KEY (`id`),
  KEY `dvadmin_system_student_creator_id_b6493985` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dvadmin_system_users;
CREATE TABLE `dvadmin_system_users` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL COMMENT 'Designates that this user has all permissions without explicitly assigning them.',
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL COMMENT 'Designates whether the user can log into this admin site.',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '????????????',
  `date_joined` datetime(6) NOT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `description` varchar(255) DEFAULT NULL COMMENT '??????',
  `modifier` varchar(255) DEFAULT NULL COMMENT '?????????',
  `dept_belong_id` varchar(255) DEFAULT NULL COMMENT '??????????????????',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '????????????',
  `username` varchar(150) NOT NULL COMMENT '????????????',
  `email` varchar(255) DEFAULT NULL COMMENT '??????',
  `mobile` varchar(255) DEFAULT NULL COMMENT '??????',
  `avatar` varchar(255) DEFAULT NULL COMMENT '??????',
  `name` varchar(40) NOT NULL COMMENT '??????',
  `gender` int DEFAULT NULL COMMENT '??????',
  `user_type` int DEFAULT NULL COMMENT '????????????',
  `creator_id` bigint DEFAULT NULL COMMENT '?????????',
  `dept_id` bigint DEFAULT NULL COMMENT '????????????',
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



INSERT INTO auth_permission(id,name,content_type_id,codename) VALUES(1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can view permission',1,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add ?????????',5,'add_users'),(18,'Can change ?????????',5,'change_users'),(19,'Can delete ?????????',5,'delete_users'),(20,'Can view ?????????',5,'view_users'),(21,'Can add ?????????',6,'add_dept'),(22,'Can change ?????????',6,'change_dept'),(23,'Can delete ?????????',6,'delete_dept'),(24,'Can view ?????????',6,'view_dept'),(25,'Can add ?????????',7,'add_menu'),(26,'Can change ?????????',7,'change_menu'),(27,'Can delete ?????????',7,'delete_menu'),(28,'Can view ?????????',7,'view_menu'),(29,'Can add ???????????????',8,'add_menubutton'),(30,'Can change ???????????????',8,'change_menubutton'),(31,'Can delete ???????????????',8,'delete_menubutton'),(32,'Can view ???????????????',8,'view_menubutton'),(33,'Can add ???????????????',9,'add_systemconfig'),(34,'Can change ???????????????',9,'change_systemconfig'),(35,'Can delete ???????????????',9,'delete_systemconfig'),(36,'Can view ???????????????',9,'view_systemconfig'),(37,'Can add ?????????',10,'add_role'),(38,'Can change ?????????',10,'change_role'),(39,'Can delete ?????????',10,'delete_role'),(40,'Can view ?????????',10,'view_role'),(41,'Can add ?????????',11,'add_post'),(42,'Can change ?????????',11,'change_post'),(43,'Can delete ?????????',11,'delete_post'),(44,'Can view ?????????',11,'view_post'),(45,'Can add ????????????',12,'add_operationlog'),(46,'Can change ????????????',12,'change_operationlog'),(47,'Can delete ????????????',12,'delete_operationlog'),(48,'Can view ????????????',12,'view_operationlog'),(49,'Can add ????????????',13,'add_loginlog'),(50,'Can change ????????????',13,'change_loginlog'),(51,'Can delete ????????????',13,'delete_loginlog'),(52,'Can view ????????????',13,'view_loginlog'),(53,'Can add ????????????',14,'add_filelist'),(54,'Can change ????????????',14,'change_filelist'),(55,'Can delete ????????????',14,'delete_filelist'),(56,'Can view ????????????',14,'view_filelist'),(57,'Can add ?????????',15,'add_dictionary'),(58,'Can change ?????????',15,'change_dictionary'),(59,'Can delete ?????????',15,'delete_dictionary'),(60,'Can view ?????????',15,'view_dictionary'),(61,'Can add ???????????????',16,'add_button'),(62,'Can change ???????????????',16,'change_button'),(63,'Can delete ???????????????',16,'delete_button'),(64,'Can view ???????????????',16,'view_button'),(65,'Can add ?????????',17,'add_area'),(66,'Can change ?????????',17,'change_area'),(67,'Can delete ?????????',17,'delete_area'),(68,'Can view ?????????',17,'view_area'),(69,'Can add ???????????????',18,'add_apiwhitelist'),(70,'Can change ???????????????',18,'change_apiwhitelist'),(71,'Can delete ???????????????',18,'delete_apiwhitelist'),(72,'Can view ???????????????',18,'view_apiwhitelist'),(73,'Can add ?????????',19,'add_student'),(74,'Can change ?????????',19,'change_student'),(75,'Can delete ?????????',19,'delete_student'),(76,'Can view ?????????',19,'view_student'),(77,'Can add ?????????',20,'add_course'),(78,'Can change ?????????',20,'change_course'),(79,'Can delete ?????????',20,'delete_course'),(80,'Can view ?????????',20,'view_course'),(81,'Can add ???????????????',21,'add_cbook'),(82,'Can change ???????????????',21,'change_cbook'),(83,'Can delete ???????????????',21,'delete_cbook'),(84,'Can view ???????????????',21,'view_cbook'),(85,'Can add ?????????',22,'add_book'),(86,'Can change ?????????',22,'change_book'),(87,'Can delete ?????????',22,'delete_book'),(88,'Can view ?????????',22,'view_book'),(89,'Can add ?????????',23,'add_schedule'),(90,'Can change ?????????',23,'change_schedule'),(91,'Can delete ?????????',23,'delete_schedule'),(92,'Can view ?????????',23,'view_schedule'),(93,'Can add ?????????',24,'add_message'),(94,'Can change ?????????',24,'change_message'),(95,'Can delete ?????????',24,'delete_message'),(96,'Can view ?????????',24,'view_message'),(97,'Can add captcha store',25,'add_captchastore'),(98,'Can change captcha store',25,'change_captchastore'),(99,'Can delete captcha store',25,'delete_captchastore'),(100,'Can view captcha store',25,'view_captchastore');


INSERT INTO django_content_type(id,app_label,model) VALUES(2,'auth','group'),(1,'auth','permission'),(25,'captcha','captchastore'),(3,'contenttypes','contenttype'),(4,'sessions','session'),(18,'system','apiwhitelist'),(17,'system','area'),(22,'system','book'),(16,'system','button'),(21,'system','cbook'),(20,'system','course'),(6,'system','dept'),(15,'system','dictionary'),(14,'system','filelist'),(13,'system','loginlog'),(7,'system','menu'),(8,'system','menubutton'),(24,'system','message'),(12,'system','operationlog'),(11,'system','post'),(10,'system','role'),(23,'system','schedule'),(19,'system','student'),(9,'system','systemconfig'),(5,'system','users');

INSERT INTO django_migrations(id,app,name,applied) VALUES(1,'contenttypes','0001_initial','2022-06-10 01:19:33.912996'),(2,'contenttypes','0002_remove_content_type_name','2022-06-10 01:19:33.999620'),(3,'auth','0001_initial','2022-06-10 01:19:34.251271'),(4,'auth','0002_alter_permission_name_max_length','2022-06-10 01:19:34.308263'),(5,'auth','0003_alter_user_email_max_length','2022-06-10 01:19:34.315525'),(6,'auth','0004_alter_user_username_opts','2022-06-10 01:19:34.323469'),(7,'auth','0005_alter_user_last_login_null','2022-06-10 01:19:34.336450'),(8,'auth','0006_require_contenttypes_0002','2022-06-10 01:19:34.347735'),(9,'auth','0007_alter_validators_add_error_messages','2022-06-10 01:19:34.355463'),(10,'auth','0008_alter_user_username_max_length','2022-06-10 01:19:34.366754'),(11,'auth','0009_alter_user_last_name_max_length','2022-06-10 01:19:34.376474'),(12,'auth','0010_alter_group_name_max_length','2022-06-10 01:19:34.391439'),(13,'auth','0011_update_proxy_permissions','2022-06-10 01:19:34.402402'),(14,'auth','0012_alter_user_first_name_max_length','2022-06-10 01:19:34.409969'),(15,'captcha','0001_initial','2022-06-10 01:19:34.439240'),(16,'captcha','0002_alter_captchastore_id','2022-06-10 01:19:34.445006'),(17,'sessions','0001_initial','2022-06-10 01:19:34.480986'),(18,'system','0001_initial','2022-06-10 01:19:36.020446'),(19,'system','0002_auto_20220609_2236','2022-06-10 01:19:36.705484'),(20,'system','0003_auto_20220610_0055','2022-06-10 01:19:37.129831');


























