# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.7.28-log)
# Database: byzer_console
# Generation Time: 2020-12-24 04:27:40 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE byzer_console CHARACTER SET utf8;

USE byzer_console;

# Dump of table access_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `access_token`;

CREATE TABLE `access_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `byzer_user_id` int(11) DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `byzer_user_id` (`byzer_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table aliyun_cluster_process
# ------------------------------------------------------------

DROP TABLE IF EXISTS `aliyun_cluster_process`;

CREATE TABLE `aliyun_cluster_process` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `start_time` text,
  `end_time` text,
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table app_kv
# ------------------------------------------------------------

DROP TABLE IF EXISTS `app_kv`;

CREATE TABLE `app_kv` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_analysis_plugin
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_analysis_plugin`;

CREATE TABLE `byzer_analysis_plugin` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `content` mediumtext,
  `byzer_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_apply
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_apply`;

CREATE TABLE `byzer_apply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `content` longtext,
  `status` int(11) DEFAULT NULL,
  `byzer_user_id` int(11) DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `finish_at` bigint(20) DEFAULT NULL,
  `script_file_id` int(11) DEFAULT NULL,
  `reason` text,
  `response` longtext,
  `apply_sql` longtext,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `byzer_user_id` (`byzer_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_backend_proxy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_backend_proxy`;

CREATE TABLE `byzer_backend_proxy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_group_id` int(11) DEFAULT NULL,
  `backend_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `backend_name` (`backend_name`),
  KEY `byzer_group_id` (`byzer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_ds
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_ds`;

CREATE TABLE `byzer_ds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `format` varchar(256) DEFAULT NULL,
  `params` text,
  `byzer_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_engine
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_engine`;

CREATE TABLE `byzer_engine` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `home` varchar(1024) DEFAULT NULL,
  `console_url` varchar(1024) DEFAULT NULL,
  `file_server_url` varchar(1024) DEFAULT NULL,
  `auth_server_url` varchar(1024) DEFAULT NULL,
  `skip_auth` int(11) DEFAULT NULL,
  `extra_opts` text,
  `access_token` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group`;

CREATE TABLE `byzer_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group_role`;

CREATE TABLE `byzer_group_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `byzer_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `byzer_group_id` (`byzer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group_role_auth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group_role_auth`;

CREATE TABLE `byzer_group_role_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_table_id` int(11) DEFAULT NULL,
  `byzer_group_role_id` int(11) DEFAULT NULL,
  `operate_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `byzer_table_id` (`byzer_table_id`),
  KEY `byzer_group_role_id` (`byzer_group_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group_script_file
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group_script_file`;

CREATE TABLE `byzer_group_script_file` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `byzer_group_id` int(11) DEFAULT NULL,
  `script_file_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group_table
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group_table`;

CREATE TABLE `byzer_group_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_table_id` int(11) DEFAULT NULL,
  `byzer_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `byzer_table_id` (`byzer_table_id`),
  KEY `byzer_group_id` (`byzer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_group_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_group_user`;

CREATE TABLE `byzer_group_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_group_id` int(11) DEFAULT NULL,
  `byzer_user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `byzer_group_id` (`byzer_group_id`),
  KEY `byzer_user_id` (`byzer_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_indexer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_indexer`;

CREATE TABLE `byzer_indexer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `sync_interval` bigint(20) DEFAULT NULL,
  `last_execute_time` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `content` longtext CHARACTER SET utf8,
  `byzer_user_id` int(11) DEFAULT NULL,
  `last_status` int(11) DEFAULT NULL,
  `indexer_config` mediumtext CHARACTER SET utf8,
  `last_fail_msg` text CHARACTER SET utf8,
  `last_job_id` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `indexer_type` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `ori_format` varchar(255) DEFAULT NULL,
  `ori_path` varchar(255) DEFAULT NULL,
  `ori_storage_name` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `storage_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table byzer_job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_job`;

CREATE TABLE `byzer_job` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `content` longtext,
  `status` int(11) DEFAULT NULL,
  `byzer_user_id` int(11) DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `finish_at` bigint(20) DEFAULT NULL,
  `script_file_id` int(11) DEFAULT NULL,
  `reason` text,
  `response` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_role_member
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_role_member`;

CREATE TABLE `byzer_role_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byzer_user_id` int(11) DEFAULT NULL,
  `byzer_group_role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `byzer_user_id` (`byzer_user_id`),
  KEY `byzer_group_role_id` (`byzer_group_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_table
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_table`;

CREATE TABLE `byzer_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `db` varchar(255) DEFAULT NULL,
  `table_type` varchar(255) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_user`;

CREATE TABLE `byzer_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `backend_tags` text,
  `role` text,
  `status` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table byzer_workshop_table
# ------------------------------------------------------------

DROP TABLE IF EXISTS `byzer_workshop_table`;

CREATE TABLE `byzer_workshop_table` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(256) DEFAULT NULL,
  `content` longtext,
  `byzer_user_id` int(11) DEFAULT NULL,
  `session_id` varchar(256) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `table_schema` mediumtext,
  `job_name` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table script_file
# ------------------------------------------------------------

DROP TABLE IF EXISTS `script_file`;

CREATE TABLE `script_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `has_caret` int(11) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `is_dir` int(11) DEFAULT NULL,
  `content` longtext,
  `is_expanded` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table script_user_rw
# ------------------------------------------------------------

DROP TABLE IF EXISTS `script_user_rw`;

CREATE TABLE `script_user_rw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `script_file_id` int(11) DEFAULT NULL,
  `byzer_user_id` int(11) DEFAULT NULL,
  `is_owner` int(11) DEFAULT NULL,
  `readable` int(11) DEFAULT NULL,
  `writable` int(11) DEFAULT NULL,
  `is_delete` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `script_file_id` (`script_file_id`),
  KEY `byzer_user_id` (`byzer_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;