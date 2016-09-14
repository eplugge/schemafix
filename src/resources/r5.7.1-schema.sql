CREATE TABLE `application_descriptor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `app_config_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_tunnel_id` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_model` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` varchar(1) COLLATE utf8_unicode_ci DEFAULT 'A'
  `user_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `action_source` varchar(1) COLLATE utf8_unicode_ci DEFAULT 'p'
  `app_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `last_sync_time` datetime DEFAULT NULL
  `app_tunnel_version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_bundle_id` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `comment` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uq_device_uuid_config_uuid_user_name` (`app_device_uuid`,`app_config_uuid`,`user_name`)
  KEY `eas_fk_app_desc_to_device` (`app_device_uuid`)
  CONSTRAINT `fk_app_desc_to_device_uuid` FOREIGN KEY (`app_device_uuid`) REFERENCES `mi_device` (`uuid`)
);
CREATE TABLE `bes_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `copyright` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `vendor` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_application_n01` (`domid`,`name`,`version`)
  CONSTRAINT `application_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_id` int(11) NOT NULL
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `home_carrier` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `model` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `phone_number` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `pin` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `mi_device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_action_at` datetime DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `domid` bigint(20) NOT NULL
  `user_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  UNIQUE KEY `mi_device_uuid` (`mi_device_uuid`)
  KEY `bes_device_to_domain` (`domid`)
  KEY `bes_user_device_to_user` (`user_id`)
  CONSTRAINT `bes_device_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
  CONSTRAINT `bes_user_device_to_user` FOREIGN KEY (`user_id`) REFERENCES `bes_user` (`id`)
);
CREATE TABLE `bes_device_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `value` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_id` bigint(20) NOT NULL
  `last_updated_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_device_details_to_device_id` (`device_id`)
  CONSTRAINT `bes_device_details_to_device_id` FOREIGN KEY (`device_id`) REFERENCES `bes_device` (`id`)
);
CREATE TABLE `bes_domain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `host` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `port` int(11) NOT NULL
  `secondary_host` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `secondary_port` int(11) DEFAULT NULL
  `username` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `password` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `user_domain` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `locale` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `sync_status` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'IDLE'
  `sync_result` varchar(4098) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_sync_attempt` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `bes_mailbox` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `display_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `email_address` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `mailbox_id` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `server_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_mailbox_n01` (`domid`,`mailbox_id`(255))
  CONSTRAINT `mailbox_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_map_application_device` (
  `app_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`app_id`,`device_id`)
  KEY `bes_application_device_to_device_id` (`device_id`)
  CONSTRAINT `bes_application_device_to_app_id` FOREIGN KEY (`app_id`) REFERENCES `bes_application` (`id`)
  CONSTRAINT `bes_application_device_to_device_id` FOREIGN KEY (`device_id`) REFERENCES `bes_device` (`id`)
);
CREATE TABLE `bes_map_module_device` (
  `module_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`module_id`,`device_id`)
  KEY `bes_module_device_to_device_id` (`device_id`)
  CONSTRAINT `bes_module_device_to_device_id` FOREIGN KEY (`device_id`) REFERENCES `bes_device` (`id`)
  CONSTRAINT `module_device_to_app_id` FOREIGN KEY (`module_id`) REFERENCES `bes_module` (`id`)
);
CREATE TABLE `bes_map_policy_to_group` (
  `group_id` bigint(20) NOT NULL
  `policy_id` bigint(20) NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `last_modified_at` datetime NOT NULL
  PRIMARY KEY (`group_id`,`policy_id`)
  KEY `bes_policy_group_to_policy` (`policy_id`)
  CONSTRAINT `bes_group_group_to_policy` FOREIGN KEY (`group_id`) REFERENCES `bes_user_group` (`id`)
  CONSTRAINT `bes_policy_group_to_policy` FOREIGN KEY (`policy_id`) REFERENCES `bes_policy` (`id`)
);
CREATE TABLE `bes_map_policy_to_user` (
  `user_id` bigint(20) NOT NULL
  `policy_id` bigint(20) NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `last_modified_at` datetime NOT NULL
  PRIMARY KEY (`user_id`,`policy_id`)
  KEY `bes_policy_user_to_policy` (`policy_id`)
  CONSTRAINT `bes_policy_user_to_policy` FOREIGN KEY (`policy_id`) REFERENCES `bes_policy` (`id`)
  CONSTRAINT `bes_user_user_to_policy` FOREIGN KEY (`user_id`) REFERENCES `bes_user` (`id`)
);
CREATE TABLE `bes_map_service_book_device` (
  `service_book_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`service_book_id`,`device_id`)
  KEY `bes_sb_device_to_device_id` (`device_id`)
  CONSTRAINT `bes_sb_device_to_device_id` FOREIGN KEY (`device_id`) REFERENCES `bes_device` (`id`)
  CONSTRAINT `bes_sb_device_to_app_id` FOREIGN KEY (`service_book_id`) REFERENCES `bes_service_book` (`id`)
);
CREATE TABLE `bes_map_user_mailbox` (
  `user_id` bigint(20) NOT NULL
  `mailbox_id` bigint(20) NOT NULL
  PRIMARY KEY (`user_id`,`mailbox_id`)
  UNIQUE KEY `mailbox_id` (`mailbox_id`)
  UNIQUE KEY `user_id` (`user_id`)
  CONSTRAINT `bes_user_mailbox_to_mailbox` FOREIGN KEY (`mailbox_id`) REFERENCES `bes_mailbox` (`id`)
  CONSTRAINT `bes_user_mailbox_to_user` FOREIGN KEY (`user_id`) REFERENCES `bes_user` (`id`)
);
CREATE TABLE `bes_map_user_to_group` (
  `user_id` bigint(20) NOT NULL
  `group_id` bigint(20) NOT NULL
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`user_id`,`group_id`)
  KEY `fk_bes_group_group_to_user` (`group_id`)
  CONSTRAINT `fk_bes_group_group_to_user` FOREIGN KEY (`group_id`) REFERENCES `bes_user_group` (`id`)
  CONSTRAINT `fk_bes_user_group_to_user` FOREIGN KEY (`user_id`) REFERENCES `bes_user` (`id`)
);
CREATE TABLE `bes_module` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `size` int(11) NOT NULL
  `created_at` datetime NOT NULL
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_module_n01` (`domid`,`name`,`version`)
  CONSTRAINT `bes_module_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_policy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `policy_id` int(11) NOT NULL
  `name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `org_id` int(11) NOT NULL
  `priority` int(11) NOT NULL
  `created_at` datetime NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_policy_to_domain` (`domid`)
  CONSTRAINT `bes_policy_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_policy_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `tag` int(11) NOT NULL
  `subtag` int(11) NOT NULL
  `name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `value` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `policy_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_bes_policy_to_policy_item` (`policy_id`)
  CONSTRAINT `fk_bes_policy_to_policy_item` FOREIGN KEY (`policy_id`) REFERENCES `bes_policy` (`id`)
);
CREATE TABLE `bes_service_book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `content_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `service_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `service_data_length` int(11) DEFAULT NULL
  `created_at` datetime NOT NULL
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_service_book_n01` (`domid`,`name`,`content_id`,`service_id`,`service_data_length`)
  CONSTRAINT `service_book_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `display_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `email_address` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `org_id` int(11) DEFAULT NULL
  `user_id` int(11) NOT NULL
  `user_state` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_contact_date` datetime DEFAULT NULL
  `device_it_policy` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `it_policy` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `created_at` datetime NOT NULL
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_user_to_domain` (`domid`)
  CONSTRAINT `bes_user_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `bes_user_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `group_id` int(11) NOT NULL
  `name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `org_id` int(11) DEFAULT NULL
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `current` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `domid` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `bes_group_to_domain` (`domid`)
  CONSTRAINT `bes_group_to_domain` FOREIGN KEY (`domid`) REFERENCES `bes_domain` (`id`)
);
CREATE TABLE `cert_inventory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `common_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `checksum` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `cert` text COLLATE utf8_unicode_ci NOT NULL
  `is_identity` tinyint(1) NOT NULL DEFAULT '0'
  `trash` tinyint(1) NOT NULL DEFAULT '0'
  `created_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  KEY `idx_cert_inventory_checksum_common_name` (`checksum`,`common_name`)
);
CREATE TABLE `cert_inventory_to_client` (
  `cert_id` bigint(20) NOT NULL
  `client_id` bigint(20) NOT NULL
  PRIMARY KEY (`cert_id`,`client_id`)
  KEY `fkey_cert_inventory_client_id` (`client_id`)
  CONSTRAINT `fk_cert_inventory_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
  CONSTRAINT `fkey_cert_inventory_cert_id` FOREIGN KEY (`cert_id`) REFERENCES `cert_inventory` (`id`)
);
CREATE TABLE `eas_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `device_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `phone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `model` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `identity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `active_sync_status` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `first_sync_time` datetime DEFAULT NULL
  `comment` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `status_change_note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `mailbox_id` bigint(20) NOT NULL
  `domain_id` bigint(20) NOT NULL
  `mi_device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_sync_time` datetime DEFAULT NULL
  `alias` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` char(1) COLLATE utf8_unicode_ci DEFAULT 'A'
  `server_policy_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `client_policy_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `proxy` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `action_source` char(1) COLLATE utf8_unicode_ci DEFAULT 'E'
  `server_key_updated_at` datetime DEFAULT NULL
  `client_key_updated_at` datetime DEFAULT NULL
  `block` int(11) DEFAULT NULL
  `heartbeat_interval_secs` bigint(20) NOT NULL DEFAULT '3540'
  `redirect_url` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `sentry_ip_list` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `policy_id` bigint(20) DEFAULT NULL
  `policy_enforced_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  UNIQUE KEY `uq_deviceid_identity` (`device_id`,`identity`)
  KEY `eas_fk_device_to_domain` (`domain_id`)
  KEY `eas_fk_device_to_mailbox` (`mailbox_id`)
  KEY `idx_device_id` (`device_id`)
  KEY `idx_eas_device_mi_device_uuid` (`mi_device_uuid`)
  KEY `idx_eas_device_trash_created_at_device_id_mailbox_id` (`trash`,`created_at`,`device_id`,`mailbox_id`)
  CONSTRAINT `eas_fk_device_to_domain` FOREIGN KEY (`domain_id`) REFERENCES `eas_domain` (`id`)
  CONSTRAINT `eas_fk_device_to_mailbox` FOREIGN KEY (`mailbox_id`) REFERENCES `eas_mailbox` (`id`)
);
CREATE TABLE `eas_device_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_updated_at` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `eas_fk_device_detail_to_device` (`device_id`)
  CONSTRAINT `eas_fk_device_detail_to_device` FOREIGN KEY (`device_id`) REFERENCES `eas_device` (`id`)
);
CREATE TABLE `eas_domain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `host` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `port` int(11) NOT NULL
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `secret` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `proxy` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `secondary_host` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `secondary_port` int(11) DEFAULT NULL
  `sync_status` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'IDLE'
  `sync_result` varchar(4098) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_sync_attempt` datetime DEFAULT NULL
  `default_mode` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'a'
  `query_filter` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `remote_shell_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `remote_server` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `remote_use_service_credentials` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `remote_dont_save_credentials` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `remote_user` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `remote_password` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `remote_auth_type` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `remote_use_ssl` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `remote_ssl_skip_server_ca_checks` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `remote_query_session_status` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `sentry_version` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `enc_secret` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `enc_remote_password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `idx_eas_domain_proxy_trash` (`proxy`,`trash`)
);
CREATE TABLE `eas_ios_model_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_agent` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `model` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `eas_it_policy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `identity` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `guid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `last_updated_at` datetime NOT NULL
  `active` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `domain_id` bigint(20) NOT NULL
  `is_default` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `eas_fk_it_policy_to_domain` (`domain_id`)
  CONSTRAINT `eas_fk_it_policy_to_domain` FOREIGN KEY (`domain_id`) REFERENCES `eas_domain` (`id`)
);
CREATE TABLE `eas_it_policy_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `policy_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `eas_fk_it_policy_to_it_policy_item` (`policy_id`)
  CONSTRAINT `eas_fk_it_policy_to_it_policy_item` FOREIGN KEY (`policy_id`) REFERENCES `eas_it_policy` (`id`)
);
CREATE TABLE `eas_mailbox` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mailbox_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `guid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `active_sync_enabled` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `mi_user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `policy_id` bigint(20) DEFAULT NULL
  `domain_id` bigint(20) NOT NULL
  `version` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `eas_fk_mailbox_to_policy` (`policy_id`)
  KEY `eas_fk_mailbox_to_domain` (`domain_id`)
  CONSTRAINT `eas_fk_mailbox_to_domain` FOREIGN KEY (`domain_id`) REFERENCES `eas_domain` (`id`)
  CONSTRAINT `eas_fk_mailbox_to_policy` FOREIGN KEY (`policy_id`) REFERENCES `eas_it_policy` (`id`)
);
CREATE TABLE `eas_mailbox_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_updated_at` datetime NOT NULL
  `mailbox_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `eas_fk_mailbox_detail_to_mailbox` (`mailbox_id`)
  CONSTRAINT `eas_fk_mailbox_detail_to_mailbox` FOREIGN KEY (`mailbox_id`) REFERENCES `eas_mailbox` (`id`)
);
CREATE TABLE `eas_platform_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `platform_type` char(1) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `eas_proxy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `host` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `port` int(11) NOT NULL
  `servers` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `server_tls` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `client_tls` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `dead_time` int(11) NOT NULL
  `dead_threshold` int(11) NOT NULL
  `failure_window` int(11) NOT NULL
  `scheduling` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `server_cert` text COLLATE utf8_unicode_ci
  `server_key` text COLLATE utf8_unicode_ci
  `ca_cert` text COLLATE utf8_unicode_ci
  `sync_status` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'IDLE'
  `sync_result` varchar(4098) COLLATE utf8_unicode_ci DEFAULT NULL
  `pass_through_mode` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `server_type` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_test_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_test_password` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `password_encrypt` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL
  `trusted_chains` text COLLATE utf8_unicode_ci
  `kerberos_config` text COLLATE utf8_unicode_ci
  `device_auth_type` varchar(64) COLLATE utf8_unicode_ci DEFAULT 'BASIC'
  `attachment_config` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `redirect_processing` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `app_tunnel_config` text COLLATE utf8_unicode_ci
  `active_sync_enable` varchar(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `app_tunnel_enable` varchar(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `capabilities` text COLLATE utf8_unicode_ci
  `uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `active_sync_proto_version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `bg_health_check_enable` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `bg_health_check_interval_secs` int(11) NOT NULL DEFAULT '60'
  `bg_health_check_live_threshold` int(11) NOT NULL DEFAULT '3'
  `advanced_config` text COLLATE utf8_unicode_ci
  `encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
  KEY `idx_eas_proxy_trash` (`trash`)
);
CREATE TABLE `ecm_connector` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `ec_uid` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `version` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `protocol_version` int(11) DEFAULT NULL
  `package_format` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `enabled` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `status` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `source` char(1) COLLATE utf8_unicode_ci DEFAULT 'A'
  `last_upgraded` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `ec_uid` (`ec_uid`)
  UNIQUE KEY `name` (`name`)
);
CREATE TABLE `ecm_connector_to_tag` (
  `tag_id` bigint(20) NOT NULL
  `connector_id` bigint(20) NOT NULL
  PRIMARY KEY (`tag_id`,`connector_id`)
  KEY `mi_ecm_connector_to_tag_connector_id` (`connector_id`)
  CONSTRAINT `mi_ecm_connector_to_tag_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `ecm_tag` (`id`)
  CONSTRAINT `mi_ecm_connector_to_tag_connector_id` FOREIGN KEY (`connector_id`) REFERENCES `ecm_connector` (`id`)
);
CREATE TABLE `ecm_service` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `service` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `service` (`service`)
);
CREATE TABLE `ecm_service_to_tag` (
  `tag_id` bigint(20) NOT NULL
  `service_id` bigint(20) NOT NULL
  PRIMARY KEY (`tag_id`,`service_id`)
  KEY `mi_ecm_service_to_tag_service_id` (`service_id`)
  CONSTRAINT `mi_ecm_service_to_tag_service_id` FOREIGN KEY (`service_id`) REFERENCES `ecm_service` (`id`)
  CONSTRAINT `mi_ecm_service_to_tag_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `ecm_tag` (`id`)
);
CREATE TABLE `ecm_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `tag` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `tag` (`tag`)
);
CREATE TABLE `mdm_command` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mdm_command_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `state_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mdm_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `udid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `client_id` bigint(20) NOT NULL
  `topic` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_token` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `push_magic` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `unlock_token` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `cert_serial_number` bigint(20) DEFAULT NULL
  `last_sync_at` datetime DEFAULT NULL
  `sync_modulus` int(11) DEFAULT NULL
  `sync_max_modulus` int(11) DEFAULT NULL
  `new_cert_serial_number` bigint(20) DEFAULT NULL
  `device_info_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `security_info_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `restrictions_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `profile_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `prov_profile_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `cert_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `managed_app_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `client_id` (`client_id`)
  UNIQUE KEY `udid` (`udid`)
  KEY `mdm_device_n01` (`id`,`udid`,`client_id`,`cert_serial_number`,`sync_modulus`,`sync_max_modulus`)
  KEY `mdmd_idx_01` (`client_id`,`cert_serial_number`,`device_token`,`last_sync_at`,`push_magic`,`sync_max_modulus`,`sync_modulus`,`topic`,`udid`,`unlock_token`(255))
  KEY `idx_mdm_device_sync_max_modulus_sync_modulus` (`sync_max_modulus`,`sync_modulus`)
  CONSTRAINT `fk_mdm_device_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mdm_notification_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `command_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `command` int(11) NOT NULL
  `command_args` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` bigint(20) NOT NULL DEFAULT '101'
  `send_attempts` int(11) NOT NULL
  `priority` int(11) NOT NULL
  `created_at` datetime NOT NULL
  `modified_at` datetime DEFAULT NULL
  `client_id` bigint(20) NOT NULL
  `response_data` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `request_data` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `command_args_ext` text COLLATE utf8_unicode_ci
  PRIMARY KEY (`id`)
  UNIQUE KEY `command_uuid` (`command_uuid`)
  KEY `fkey_mdm_notification_event_state` (`state`)
  KEY `mdm_notification_event_n01` (`modified_at`,`state`)
  KEY `mdm_notification_event_n02` (`state`,`client_id`,`command`)
  KEY `fk_mdm_notification_event_to_mi_client_id` (`client_id`)
  KEY `mdm_notification_event_n03` (`created_at`,`command`,`state`)
  CONSTRAINT `fkey_mdm_notification_event_state` FOREIGN KEY (`state`) REFERENCES `mdm_command_state` (`id`)
  CONSTRAINT `fk_mdm_notification_event_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mdm_profile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `identifier` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `version` int(11) NOT NULL
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `org` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `content` text COLLATE utf8_unicode_ci
  `removal_disallowed` tinyint(1) NOT NULL DEFAULT '0'
  `has_removal_passcode` tinyint(1) NOT NULL DEFAULT '0'
  `is_encrypted` tinyint(1) NOT NULL DEFAULT '0'
  `is_managed` tinyint(1) NOT NULL DEFAULT '0'
  `trash` tinyint(1) NOT NULL DEFAULT '0'
  `created_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_mdm_profile_unique` (`identifier`,`uuid`)
  KEY `idx_mdm_profile_uuid` (`uuid`)
);
CREATE TABLE `mdm_profile_to_client` (
  `profile_id` bigint(20) NOT NULL
  `client_id` bigint(20) NOT NULL
  PRIMARY KEY (`profile_id`,`client_id`)
  KEY `fkey_mdm_profile_client_id` (`client_id`)
  CONSTRAINT `fk_mdm_profile_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
  CONSTRAINT `fkey_mdm_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `mdm_profile` (`id`)
);
CREATE TABLE `mdm_profile_url` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` bigint(20) NOT NULL
  `mdm` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `checkin` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_mdm_checkin_url` (`mdm`,`checkin`)
);
CREATE TABLE `mdm_provisioning_profile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `expiry_date` datetime DEFAULT NULL
  `trash` tinyint(1) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
);
CREATE TABLE `mdm_provisioning_profile_to_client` (
  `profile_id` bigint(20) NOT NULL
  `client_id` bigint(20) NOT NULL
  PRIMARY KEY (`profile_id`,`client_id`)
  KEY `fkey_mdm_provisioning_profile_client_id` (`client_id`)
  CONSTRAINT `fk_mdm_provisioning_profile_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
  CONSTRAINT `fkey_mdm_provisiong_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `mdm_provisioning_profile` (`id`)
);
CREATE TABLE `mi_app_catalog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime NOT NULL
  `catalog_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` text COLLATE utf8_unicode_ci
  `install_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `logo_resource_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `installer_resource_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `uuid` char(8) COLLATE utf8_unicode_ci NOT NULL
  `revocation_hash` char(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'ADMIN'
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `FK_APP_CATALOG_LOGO_RESOURCE_ID` (`logo_resource_uuid`)
  KEY `FK_APP_CATALOG_INSTALLER_RESOURCE_ID` (`installer_resource_uuid`)
  CONSTRAINT `FK_APP_CATALOG_INSTALLER_RESOURCE_ID` FOREIGN KEY (`installer_resource_uuid`) REFERENCES `mi_resource` (`uuid`)
  CONSTRAINT `FK_APP_CATALOG_LOGO_RESOURCE_ID` FOREIGN KEY (`logo_resource_uuid`) REFERENCES `mi_resource` (`uuid`)
);
CREATE TABLE `mi_app_catalog_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_catalog_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_app_catalog_entry_app_catalog_id` (`app_catalog_id`)
  CONSTRAINT `fk_app_catalog_entry_app_catalog_id` FOREIGN KEY (`app_catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_catalog_to_category` (
  `catalog_id` bigint(20) NOT NULL
  `category_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`category_id`)
  KEY `FK5151D7A9B4A7FD0C` (`category_id`)
  CONSTRAINT `FK1581601A4DCD49B7` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `FK5151D7A9B4A7FD0C` FOREIGN KEY (`category_id`) REFERENCES `mi_app_categories` (`id`)
);
CREATE TABLE `mi_app_catalog_to_client` (
  `catalog_id` bigint(20) NOT NULL
  `client_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`client_id`)
  KEY `FKEF6471EBCA9658C8` (`client_id`)
  CONSTRAINT `fk_mi_app_catalog_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
  CONSTRAINT `FK648B767329447DD0` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_catalog_to_installer_files` (
  `catalog_id` bigint(20) NOT NULL
  `resource_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`catalog_id`,`resource_uuid`)
  KEY `FKE8608A7DAC3E6907` (`resource_uuid`)
  CONSTRAINT `FK5FEC3829BC91BD33` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `FKE8608A7DAC3E6907` FOREIGN KEY (`resource_uuid`) REFERENCES `mi_resource` (`uuid`)
);
CREATE TABLE `mi_app_catalog_to_label` (
  `catalog_id` bigint(20) NOT NULL
  `label_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`label_id`)
  KEY `FK99B0003C6C1C0D21` (`label_id`)
  CONSTRAINT `FK5ED4705CE0959461` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `FK99B0003C6C1C0D21` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
);
CREATE TABLE `mi_app_catalog_to_platform` (
  `catalog_id` bigint(20) NOT NULL
  `platform_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`platform_id`)
  KEY `FKE8008A7DAC356907` (`platform_id`)
  CONSTRAINT `FKE8008A7DAC356907` FOREIGN KEY (`platform_id`) REFERENCES `mi_app_platforms` (`id`)
  CONSTRAINT `FK5FEC98296C91BD33` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_catalog_vpp_to_label` (
  `catalog_id` bigint(20) NOT NULL
  `label_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`label_id`)
  KEY `fk_label_for_vpp` (`label_id`)
  CONSTRAINT `fk_app_catalog_for_vpp` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `fk_label_for_vpp` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
);
CREATE TABLE `mi_app_categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `name` (`name`)
);
CREATE TABLE `mi_app_fingerprints` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `catalog_id` bigint(20) NOT NULL
  `checksum` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `FKADBAA35DF331D492` (`catalog_id`)
  KEY `idx_mi_app_fingerprints_checksum_id_desc_catalog_id` (`checksum`,`id`,`catalog_id`)
  CONSTRAINT `FKADBAA35DF331D492` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_group_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'g'
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_app_group_permission_assoc` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `risk` int(11) NOT NULL DEFAULT '500'
  `app_inventory_id` bigint(20) NOT NULL
  `app_group_id` bigint(20) DEFAULT NULL
  `app_permission_id` bigint(20) NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_app_group_to_permission` (`app_group_id`)
  KEY `fk_permission_to_group` (`app_permission_id`)
  KEY `fk_app_inventory_to_group` (`app_inventory_id`)
  CONSTRAINT `fk_app_group_to_permission` FOREIGN KEY (`app_group_id`) REFERENCES `mi_app_group_permission` (`id`)
  CONSTRAINT `fk_permission_to_group` FOREIGN KEY (`app_permission_id`) REFERENCES `mi_app_permission` (`id`)
  CONSTRAINT `fk_app_inventory_to_group` FOREIGN KEY (`app_inventory_id`) REFERENCES `mi_app_inventory` (`id`)
);
CREATE TABLE `mi_app_inventory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime NOT NULL
  `exec_path` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `checksum` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `install_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `catalog_id` bigint(20) DEFAULT NULL
  `revocation_hash` char(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `version_int` int(11) DEFAULT NULL
  `type` char(1) COLLATE utf8_unicode_ci DEFAULT 'N'
  `bundle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `permissionComplete` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `version_long` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `version_short` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `FK4393A1554E1E1744` (`catalog_id`)
  KEY `idx_mi_app_inventory_common` (`install_name`,`checksum`,`platform`,`catalog_id`)
  KEY `idx_mi_app_inventory_n01` (`install_name`,`checksum`,`platform`,`catalog_id`,`created_at`,`exec_path`(255),`name`,`revocation_hash`,`version`)
  KEY `idx_mi_app_inventory_checksum` (`checksum`)
  KEY `idx_install_checksum_7` (`install_name`,`checksum`,`platform`,`catalog_id`,`created_at`,`exec_path`(255),`name`,`revocation_hash`,`version`)
  KEY `idx_mi_app_inventory_bundle` (`bundle`)
  CONSTRAINT `FK4393A1554E1E1744` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_inventory_rollup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `bundle` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `platform` char(1) COLLATE utf8_unicode_ci NOT NULL
  `decision` int(11) NOT NULL DEFAULT '0'
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `app_inventory_id` bigint(20) DEFAULT NULL
  `device_count` int(11) NOT NULL DEFAULT '0'
  `appthority_score` int(11) DEFAULT '0'
  `appthority_rating` int(11) DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_appbundle_platformtype` (`bundle`,`platform`)
  KEY `fk_rollup_to_app_inventory` (`app_inventory_id`)
  KEY `idx_mi_app_inventory_rollup_platform_bundle` (`platform`,`bundle`)
  CONSTRAINT `fk_rollup_to_app_inventory` FOREIGN KEY (`app_inventory_id`) REFERENCES `mi_app_inventory` (`id`)
);
CREATE TABLE `mi_app_iphoneapp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `catalog_id` bigint(20) NOT NULL
  `appstore_id` bigint(20) NOT NULL
  `app_sort_order` bigint(20) NOT NULL DEFAULT '50'
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'PRE-2.0'
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `fk_mi_app_iphoneapp_mi_app_catalog_id` (`catalog_id`)
  KEY `idx_app_sort_order` (`app_sort_order`)
  CONSTRAINT `fk_mi_app_iphoneapp_mi_app_catalog_id` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
);
CREATE TABLE `mi_app_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'r'
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_app_permission_assoc` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `risk` int(11) NOT NULL DEFAULT '500'
  `app_inventory_id` bigint(20) NOT NULL
  `app_permission_id` bigint(20) NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_permission_to_app_inventory` (`app_permission_id`)
  KEY `fk_app_inventory_to_permission` (`app_inventory_id`)
  CONSTRAINT `fk_permission_to_app_inventory` FOREIGN KEY (`app_permission_id`) REFERENCES `mi_app_permission` (`id`)
  CONSTRAINT `fk_app_inventory_to_permission` FOREIGN KEY (`app_inventory_id`) REFERENCES `mi_app_inventory` (`id`)
);
CREATE TABLE `mi_app_platforms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `platform_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `kernel_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform_type` char(1) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `platform_name` (`platform_name`)
  KEY `map_idx_01` (`platform_type`,`kernel_name`,`platform_name`)
);
CREATE TABLE `mi_app_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime NOT NULL
  `setting_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `app_type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'C'
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'ADMIN'
  `version` int(11) DEFAULT '1'
  `hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT '0'
  `created_by` bigint(20) NOT NULL DEFAULT '9000'
  `modified_by` bigint(20) NOT NULL DEFAULT '9000'
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_created_by_app_setting_to_user` (`created_by`)
  KEY `fk_modified_by_app_setting_to_user` (`modified_by`)
  KEY `idx_mi_app_setting_uuid` (`uuid`)
  CONSTRAINT `fk_created_by_app_setting_to_user` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `fk_modified_by_app_setting_to_user` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_app_setting_change_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `modified_at` datetime DEFAULT NULL
  `app_setting_id` bigint(20) NOT NULL
  `modified_by` bigint(20) NOT NULL DEFAULT '9000'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_app_setting_history_app_setting_id` (`app_setting_id`)
  KEY `fk_app_setting_change_history_to_user` (`modified_by`)
  CONSTRAINT `fk_app_setting_change_history_to_user` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `mi_app_setting_history_app_setting_id` FOREIGN KEY (`app_setting_id`) REFERENCES `mi_app_setting` (`id`)
);
CREATE TABLE `mi_app_setting_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_setting_id` bigint(20) NOT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'C'
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_app_setting_entry_prop_id` (`property`,`app_setting_id`)
  KEY `fk_app_setting_entry_app_setting_id` (`app_setting_id`)
  CONSTRAINT `fk_app_setting_entry_app_setting_id` FOREIGN KEY (`app_setting_id`) REFERENCES `mi_app_setting` (`id`)
);
CREATE TABLE `mi_app_setting_subject_holder` (
  `app_setting_id` bigint(20) NOT NULL
  `subject_holder_id` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`app_setting_id`,`subject_holder_id`)
  KEY `fk_app_setting_to_subject_subject_holder_id` (`subject_holder_id`)
  KEY `idx_mi_app_setting_subject_holder_trash_etc` (`trash`,`app_setting_id`,`subject_holder_id`)
  CONSTRAINT `fk_app_setting_to_label` FOREIGN KEY (`subject_holder_id`) REFERENCES `mi_label` (`id`)
  CONSTRAINT `fk_app_setting_to_subject_app_setting_id` FOREIGN KEY (`app_setting_id`) REFERENCES `mi_app_setting` (`id`)
);
CREATE TABLE `mi_app_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `token` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `url` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `app_catalog_id` bigint(20) NOT NULL
  `user_id` bigint(20) DEFAULT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `redeemed` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `fk_app_catalog_to_token` (`app_catalog_id`)
  KEY `fk_user_to_token` (`user_id`)
  CONSTRAINT `fk_app_catalog_to_token` FOREIGN KEY (`app_catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `fk_user_to_token` FOREIGN KEY (`user_id`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_app_wp8app` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `catalog_id` bigint(20) NOT NULL
  `appstore_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `app_sort_order` bigint(20) NOT NULL DEFAULT '50'
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'WP8'
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_area_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT
  `country_code` bigint(20) NOT NULL
  `area` varchar(8) COLLATE utf8_unicode_ci NOT NULL
  `area_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_id_country_code` (`country_code`)
  CONSTRAINT `fk_id_country_code` FOREIGN KEY (`country_code`) REFERENCES `mi_country` (`id`)
);
CREATE TABLE `mi_asset` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'd'
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_av_infected_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `logged_at` datetime DEFAULT NULL
  `resource_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `uri` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `action_taken` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `virus_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `file_handle_id` char(32) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_infected_log_resource_uuid` (`resource_uuid`)
  KEY `fk_key_process_file_handle_uuid` (`file_handle_id`)
  KEY `fk_key_infected_log_rh_id` (`resource_holder_id`)
  CONSTRAINT `fk_key_infected_log_resource_uuid` FOREIGN KEY (`resource_uuid`) REFERENCES `mi_resource` (`uuid`)
  CONSTRAINT `fk_key_process_file_handle_uuid` FOREIGN KEY (`file_handle_id`) REFERENCES `mi_file_handle` (`file_handle_uuid`)
  CONSTRAINT `fk_key_infected_log_rh_id` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
);
CREATE TABLE `mi_badge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `app_catalog_id` bigint(20) NOT NULL
  `mi_device_id` bigint(20) DEFAULT NULL
  `created_at` bigint(20) NOT NULL
  `read_at` bigint(20) DEFAULT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `reason` int(11) DEFAULT NULL
  `completed_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_badge_to_app_catalog_id` (`app_catalog_id`)
  KEY `fk_badge_to_device_id` (`mi_device_id`)
  CONSTRAINT `fk_badge_to_app_catalog_id` FOREIGN KEY (`app_catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `fk_badge_to_device_id` FOREIGN KEY (`mi_device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_bmw_acl` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_bmw_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `acl_id` bigint(20) NOT NULL
  `pattern` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `operator` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'IS'
  `version` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `version_operator` varchar(64) COLLATE utf8_unicode_ci DEFAULT '='
  `platform_type` char(1) COLLATE utf8_unicode_ci DEFAULT '0'
  PRIMARY KEY (`id`)
  KEY `fk_bmw_acl` (`acl_id`)
  CONSTRAINT `fk_bmw_acl` FOREIGN KEY (`acl_id`) REFERENCES `mi_bmw_acl` (`id`)
);
CREATE TABLE `mi_carrier_operator` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `carrier_id` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `carrier_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `operator_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `mi_carrier_to_operator` (`operator_id`)
  CONSTRAINT `mi_carrier_to_operator` FOREIGN KEY (`operator_id`) REFERENCES `mi_operator` (`id`)
);
CREATE TABLE `mi_certificate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `passkey` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` varchar(60) COLLATE utf8_unicode_ci NOT NULL
  `expired_at` datetime DEFAULT NULL
  `created_at` datetime DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `scep_id` bigint(20) DEFAULT NULL
  `user_id` bigint(20) NOT NULL
  `device_id` bigint(20) DEFAULT NULL
  `passkeyHash` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `serial_number` bigint(20) DEFAULT NULL
  `mi_local_ca_id` bigint(20) DEFAULT NULL
  `cert_type` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL
  `enrollment_id` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  `serial_number_string` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_certificate_device_id` (`device_id`)
  KEY `fk_certificate_app_setting_id` (`scep_id`)
  KEY `fk_certificate_user_id` (`user_id`)
  KEY `mi_certificate_serial_number_device_id` (`serial_number`,`device_id`)
  CONSTRAINT `fk_certificate_app_setting_id` FOREIGN KEY (`scep_id`) REFERENCES `mi_app_setting` (`id`)
  CONSTRAINT `fk_certificate_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
  CONSTRAINT `fk_certificate_user_id` FOREIGN KEY (`user_id`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_client` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mi_device_id` bigint(20) DEFAULT NULL
  `virus_scan_stats` bigint(20) DEFAULT NULL
  `next_snapshot_version` int(11) NOT NULL DEFAULT '1'
  PRIMARY KEY (`id`)
  UNIQUE KEY `mi_client_n01_covering` (`id`,`mi_device_id`,`virus_scan_stats`,`next_snapshot_version`)
  KEY `FKD019BCE7AE38420` (`virus_scan_stats`)
  KEY `FKD019BCEAF98C84F` (`mi_device_id`)
  CONSTRAINT `FKD019BCE7AE38420` FOREIGN KEY (`virus_scan_stats`) REFERENCES `virus_scan_stats` (`id`)
  CONSTRAINT `FKD019BCEAF98C84F` FOREIGN KEY (`mi_device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_client_app_inventory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `client_id` bigint(20) NOT NULL
  `resource_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `catalog_id` bigint(20) DEFAULT NULL
  `inventory_id` bigint(20) DEFAULT NULL
  `bmw_failures` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `bmw_failure_type` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` bigint(20) DEFAULT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `status` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `FK85A491757DA6C5EF` (`resource_uuid`)
  KEY `FK72A19EB0E51F22BB` (`catalog_id`)
  KEY `FK548E1DF057E410B4` (`client_id`)
  KEY `FK4393A15548DE1744` (`inventory_id`)
  KEY `idx_mi_client_app_inventory_1` (`client_id`,`catalog_id`,`trash`,`status`)
  KEY `idx_mi_client_app_inventory_2` (`client_id`,`inventory_id`,`trash`,`status`)
  CONSTRAINT `FK4393A15548DE1744` FOREIGN KEY (`inventory_id`) REFERENCES `mi_app_inventory` (`id`)
  CONSTRAINT `FK72A19EB0E51F22BB` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `FK85A491757DA6C5EF` FOREIGN KEY (`resource_uuid`) REFERENCES `mi_resource` (`uuid`)
  CONSTRAINT `fk_mi_client_app_inventory_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mi_client_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `session_id` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  `client_id` int(11) NOT NULL
  `logged_at` datetime DEFAULT NULL
  `event` int(11) NOT NULL
  `log_entry` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `event_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `FK88907751ADBFE78B` (`event_id`)
  CONSTRAINT `FK88907751ADBFE78B` FOREIGN KEY (`event_id`) REFERENCES `mi_notification_event` (`id`)
);
CREATE TABLE `mi_compliance_actions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `compliance_action` int(11) NOT NULL
  `quarantine_action` bigint(20) NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_contact` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `contact_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `device_id` bigint(20) NOT NULL
  `flags` smallint(6) NOT NULL DEFAULT '0'
  `account_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `anniversary` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `assistant_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `assistant_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `birthday` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_city` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_country` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_postal_code` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_state` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_street` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_fax_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `business2_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `car_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `children` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `company_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `company_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `customer_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `department` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `display_name` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `email1address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `email2address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `email3address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `file_as` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `first_name` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `middle_name` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_name` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `government_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_city` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_country` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_postal_code` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_state` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_street` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_fax_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `home2_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `im1address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `im2address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `im3address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `job_title` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `manager` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `mms` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `mobile_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `nickname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `note` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL
  `office_location` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `other_address` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `other_address_city` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `other_address_country` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `other_address_postal_code` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `other_address_state` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `pager_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `radio_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `sms` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `spouse` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `suffix` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `prefix` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `web_page` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `black_berry_pin` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user1` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user2` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user3` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user4` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `direct_connect_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `unknown` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `deleted` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `rank1m` int(11) NOT NULL DEFAULT '2147483647'
  `rank3m` int(11) NOT NULL DEFAULT '2147483647'
  `rank6m` int(11) NOT NULL DEFAULT '2147483647'
  `rank1y` int(11) NOT NULL DEFAULT '2147483647'
  `rankAll` int(11) NOT NULL DEFAULT '2147483647'
  `to_sync` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `do_not_sync` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `other_telephone_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `home_address_street2` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `business_address_street2` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `score_all_time` int(11) NOT NULL DEFAULT '-2147483648'
  `score_1m` int(11) NOT NULL DEFAULT '-2147483648'
  `score_3m` int(11) NOT NULL DEFAULT '-2147483648'
  `score_6m` int(11) NOT NULL DEFAULT '-2147483648'
  `score_1y` int(11) NOT NULL DEFAULT '-2147483648'
  PRIMARY KEY (`id`)
  KEY `mi_contact_device_id` (`device_id`)
  CONSTRAINT `mi_contact_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_contact_next_id_holder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_id` bigint(20) NOT NULL
  `next_id` int(11) NOT NULL DEFAULT '2147483647'
  PRIMARY KEY (`id`)
  UNIQUE KEY `device_id` (`device_id`)
  CONSTRAINT `fk_key_mi_contact_next_id_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_contact_normalized_numbers` (
  `contact_id` bigint(20) NOT NULL
  `number_category` int(11) NOT NULL
  `normalized_number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  KEY `mi_contact_normalized_numbers_contact_id` (`contact_id`)
  CONSTRAINT `mi_contact_normalized_numbers_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `mi_contact` (`id`)
);
CREATE TABLE `mi_country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `country_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_code` int(11) DEFAULT NULL
  `iso_alpha2_code` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL
  `enabled_for_registration` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `mnc_position` int(11) DEFAULT '0'
  `enabled_for_itunes` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `idx_mi_country_country_code` (`country_code`)
);
CREATE TABLE `mi_customer_license` (
  `id` int(11) NOT NULL AUTO_INCREMENT
  `license_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `license_type` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `platform_code` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `seats_sold` int(11) DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `idx_mi_customer_license_name_platform` (`license_name`,`platform_code`)
);
CREATE TABLE `mi_customer_license_usage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mi_license_id` int(11) NOT NULL
  `seats_used` int(11) DEFAULT NULL
  `updated_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_license_usage_data_to_license_id` (`mi_license_id`)
  CONSTRAINT `fk_license_usage_data_to_license_id` FOREIGN KEY (`mi_license_id`) REFERENCES `mi_customer_license` (`id`) ON DELETE CASCADE
);
CREATE TABLE `mi_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `phone_number` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `carrier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `notify_user` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `device_info_id` bigint(20) DEFAULT NULL
  `created_by` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `mi_client_id` bigint(20) DEFAULT NULL
  `status_code` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'v'
  `status_change_note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_personal` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `comment` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_by` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `current_phone_number` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_code` char(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1'
  `operator_id` bigint(20) DEFAULT NULL
  `reg_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'DEFAULT'
  `reg_count` int(11) DEFAULT '0'
  `country_id` bigint(20) DEFAULT NULL
  `mdm_managed` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `compliance` int(11) DEFAULT '0'
  `last_connected_at` datetime DEFAULT NULL
  `app_platform_id` bigint(20) DEFAULT NULL
  `language_id` bigint(20) DEFAULT NULL
  `lang_country_id` bigint(20) DEFAULT NULL
  `block_reason` int(11) DEFAULT '-1'
  `quarantined_status` int(11) DEFAULT '0'
  `quarantined_action` bigint(20) DEFAULT '0'
  `mdm_profile_url_id` bigint(20) DEFAULT NULL
  `issued_enrollment_cert` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `mdm_terminated` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `is_roaming` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `current_operator_id` bigint(20) DEFAULT NULL
  `current_country_id` bigint(20) DEFAULT NULL
  `retired` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `registered_at` bigint(20) DEFAULT NULL
  `wipe_reason` int(11) DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  KEY `FKE59C65936243723` (`device_info_id`)
  KEY `FKE59C6596EA9862F` (`resource_holder_id`)
  KEY `FKE59C659AA06CC11` (`created_by`)
  KEY `mi_device_status_n01` (`mi_client_id`,`status_code`)
  KEY `fk_mi_device_to_mi_app_platforms` (`app_platform_id`)
  KEY `md_idx_01` (`mi_client_id`,`status_code`,`current_phone_number`)
  KEY `idx_mi_device_retired_n01` (`mi_client_id`,`retired`)
  KEY `idx_mi_device_02` (`mi_client_id`,`retired`,`current_phone_number`)
  KEY `idx_mi_device_id_issued_enrollment_cert` (`id`,`issued_enrollment_cert`)
  CONSTRAINT `FKE59C6596EA9862F` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
  CONSTRAINT `FKE59C659AA06CC11` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`uuid`)
  CONSTRAINT `fk_mi_device_to_mi_app_platforms` FOREIGN KEY (`app_platform_id`) REFERENCES `mi_app_platforms` (`id`)
  CONSTRAINT `fk_mi_device_to_mi_client` FOREIGN KEY (`mi_client_id`) REFERENCES `mi_client` (`id`)
);
CREATE TABLE `mi_device_alert` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_id` bigint(20) DEFAULT NULL
  `alert_sent` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `alert_sent_at` datetime DEFAULT NULL
  `alert_type` int(11) DEFAULT NULL
  `alerted_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `alerted_through` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
  `alert_cleared` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `alert_cleared_at` datetime DEFAULT NULL
  `alert_cleared_code` int(11) DEFAULT NULL
  `alert_cleared_by` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_mi_device_alert_user_id` (`alert_cleared_by`)
  CONSTRAINT `fk_key_mi_device_alert_user_id` FOREIGN KEY (`alert_cleared_by`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_device_app_setting_assoc` (
  `device_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `app_setting_id` bigint(20) NOT NULL
  `status` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'P'
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'C'
  `last_updated_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`device_id`,`app_setting_id`)
  KEY `fk_app_setting_to_device_setting_id` (`app_setting_id`)
  KEY `idx_mi_device_app_setting_assoc_appsetting_state_status` (`app_setting_id`,`state`,`status`)
  CONSTRAINT `fk_app_setting_to_device_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_subject_holder` (`uuid`)
  CONSTRAINT `fk_app_setting_to_device_setting_id` FOREIGN KEY (`app_setting_id`) REFERENCES `mi_app_setting` (`id`)
);
CREATE TABLE `mi_device_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `last_updated_at` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `idx_mi_device_detail_value_property_device_id` (`value`,`property`,`device_id`)
  KEY `FK635E28F7AFE71332` (`device_id`)
  KEY `idx_property_value_device_id` (`property`,`value`,`device_id`)
  KEY `mdd_idx_01` (`property`,`value`,`device_id`)
  KEY `idx_mi_device_detail_device_id_property` (`device_id`,`property`)
  KEY `idx_mi_device_detail_device_prop_val_last` (`device_id`,`property`,`value`,`last_updated_at`)
  CONSTRAINT `FK635E28F7AFE71332` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `type` char(32) COLLATE utf8_unicode_ci NOT NULL
  `old_value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `new_value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `fk_key_mi_device_history_device_id` (`device_id`)
  CONSTRAINT `fk_key_mi_device_history_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_location` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `type` int(11) NOT NULL
  `cell_id` int(11) DEFAULT NULL
  `mnc` int(11) DEFAULT NULL
  `mcc` int(11) DEFAULT NULL
  `lac` int(11) DEFAULT NULL
  `signal_strength` int(11) DEFAULT NULL
  `recorded_time` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  `latitude` double DEFAULT NULL
  `longitude` double DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_location_device_id` (`device_id`)
  CONSTRAINT `fk_key_location_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `type` int(11) NOT NULL
  `caller_number` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `caller_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `start_time` datetime DEFAULT NULL
  `end_time` datetime DEFAULT NULL
  `outgoing` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `incoming` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `missed` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `roaming` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `connected` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `ended` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `message` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_id` bigint(20) NOT NULL
  `caller_number_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `num_participants` int(11) DEFAULT NULL
  `current_phone_number` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `caller_id_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `conference` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0'
  `status` tinyint(4) DEFAULT NULL
  `contact_id` bigint(20) DEFAULT NULL
  `cell_bytes_in` int(11) DEFAULT NULL
  `cell_bytes_out` int(11) DEFAULT NULL
  `wifi_bytes_in` int(11) DEFAULT NULL
  `wifi_bytes_out` int(11) DEFAULT NULL
  `app_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `client_log_id` int(11) NOT NULL DEFAULT '0'
  `archived` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_mi_device_log_constraint2` (`device_id`,`type`,`caller_number`,`start_time`,`client_log_id`)
  KEY `mdl_idx_01` (`contact_id`)
  KEY `idx_mi_device_log_type_archived` (`type`,`archived`)
  KEY `idx_mi_device_log_start_time_caller_number` (`start_time`,`caller_number`)
  CONSTRAINT `fk_key_log_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_policy_assoc` (
  `policy_id` bigint(20) NOT NULL
  `device_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'C'
  `status` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'P'
  `last_modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`policy_id`,`device_id`)
  KEY `fk_device_policy_assoc_device_id` (`device_id`)
  KEY `mi_device_policy_assoc_pid_state_status_dev` (`policy_id`,`state`,`status`,`device_id`)
  KEY `idx_mi_device_policy_assoc_policy_state_status` (`policy_id`,`state`,`status`)
  CONSTRAINT `fk_device_policy_assoc_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_subject_holder` (`uuid`)
  CONSTRAINT `fk_device_policy_assoc_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `mi_policy` (`id`)
);
CREATE TABLE `mi_device_preference` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_updated_at` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_mi_device_preference_mi_device` (`device_id`)
  CONSTRAINT `fk_mi_device_preference_mi_device` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_process` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `process_id` bigint(20) NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_process_device_id` (`device_id`)
  CONSTRAINT `fk_key_process_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_device_status` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `need_exchange` char(1) COLLATE utf8_unicode_ci DEFAULT 'n'
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
);
CREATE TABLE `mi_document` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `location` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `catalog_id` bigint(20) NOT NULL
  `resource_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `uuid` char(16) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
  UNIQUE KEY `resource_uuid` (`resource_uuid`)
  KEY `mi_document_document_catalog_fk` (`catalog_id`)
  CONSTRAINT `mi_document_catalog_entry_resource_fk` FOREIGN KEY (`resource_uuid`) REFERENCES `mi_resource` (`uuid`)
  CONSTRAINT `mi_document_document_catalog_fk` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
);
CREATE TABLE `mi_document_catalog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime NOT NULL
  `modified_at` datetime DEFAULT NULL
  `catalog_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `default_location` varchar(2048) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `type` char(1) COLLATE utf8_unicode_ci DEFAULT 'a'
  `parent_id` bigint(20) DEFAULT NULL
  `created_by` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `catalog_name` (`catalog_name`)
  KEY `FK_DOCCAT_PARENT` (`parent_id`)
  CONSTRAINT `FK_DOCCAT_PARENT` FOREIGN KEY (`parent_id`) REFERENCES `mi_document_catalog` (`id`)
);
CREATE TABLE `mi_document_catalog_to_device` (
  `catalog_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`device_id`)
  KEY `mi_document_catalog_to_device_device_fk` (`device_id`)
  CONSTRAINT `mi_document_catalog_to_device_catalog_fk` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
  CONSTRAINT `mi_document_catalog_to_device_device_fk` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_document_catalog_to_device_from_label` (
  `catalog_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`device_id`)
  KEY `mi_document_catalog_to_device_device_from_label_fk` (`device_id`)
  CONSTRAINT `mi_document_catalog_to_device_catalog_from_label_fk` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
  CONSTRAINT `mi_document_catalog_to_device_device_from_label_fk` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_document_catalog_to_label` (
  `catalog_id` bigint(20) NOT NULL
  `label_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`label_id`)
  KEY `mi_document_catalog_to_label_label_fk` (`label_id`)
  CONSTRAINT `mi_document_catalog_to_label_label_fk` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
  CONSTRAINT `mi_document_catalog_to_label_catalog_fk` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
);
CREATE TABLE `mi_document_resource_holder_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `resource_holder_id` bigint(20) NOT NULL
  `resource_id` bigint(20) NOT NULL
  `catalog_id` bigint(20) NOT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'U'
  `type` int(11) DEFAULT NULL
  `created_at` datetime NOT NULL
  `modified_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `mi_document_resource_holder_state_u01` (`resource_holder_id`,`resource_id`,`catalog_id`,`state`,`type`,`created_at`,`modified_at`)
  KEY `FKdocumentCatalog` (`catalog_id`)
  KEY `FKdocumentResourceAssoc` (`resource_id`)
  CONSTRAINT `FKdocumentResourceHolderAssoc` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`id`)
  CONSTRAINT `FKdocumentCatalog` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
  CONSTRAINT `FKdocumentResourceAssoc` FOREIGN KEY (`resource_id`) REFERENCES `mi_resource` (`id`)
);
CREATE TABLE `mi_exchange_client` (
  `id` int(11) NOT NULL
  `name` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_exclude_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_mi_exclude_device_uuid` (`uuid`)
  CONSTRAINT `fk_key_mi_exclude_device_uuid` FOREIGN KEY (`uuid`) REFERENCES `mi_device` (`uuid`)
);
CREATE TABLE `mi_failed_login_attempts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `failed_attempts` int(11) NOT NULL DEFAULT '0'
  `user_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_attempt_at` datetime NOT NULL
  `rsn` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_file_bucket` (
  `file_bucket_uuid` char(16) COLLATE utf8_unicode_ci NOT NULL
  `rel_path` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `file_count` int(11) NOT NULL
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`file_bucket_uuid`)
  UNIQUE KEY `file_bucket_uuid` (`file_bucket_uuid`)
  KEY `FK37574FEA6EA9862F` (`resource_holder_id`)
  CONSTRAINT `FK37574FEA6EA9862F` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
);
CREATE TABLE `mi_file_handle` (
  `file_handle_uuid` char(32) COLLATE utf8_unicode_ci NOT NULL
  `length` bigint(20) DEFAULT NULL
  `ref_count` int(11) DEFAULT '0'
  `checksum` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `version` int(11) DEFAULT NULL
  `bucket_id` char(16) COLLATE utf8_unicode_ci NOT NULL
  `av_status` char(1) COLLATE utf8_unicode_ci DEFAULT 'n'
  `last_scanned_at` datetime DEFAULT NULL
  `complete` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`file_handle_uuid`)
  UNIQUE KEY `file_handle_uuid` (`file_handle_uuid`)
  KEY `FK407F74284C2CF34E` (`bucket_id`)
  CONSTRAINT `FK407F74284C2CF34E` FOREIGN KEY (`bucket_id`) REFERENCES `mi_file_bucket` (`file_bucket_uuid`)
);
CREATE TABLE `mi_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL
  `group_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `created_at` datetime NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `created_by` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `parent_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  KEY `FK954BC21C6EA9862F` (`resource_holder_id`)
  KEY `FK954BC21CAA06CC11` (`created_by`)
  KEY `FK954BC21C2EA25717` (`parent_id`)
  CONSTRAINT `FK954BC21C2EA25717` FOREIGN KEY (`parent_id`) REFERENCES `mi_group` (`uuid`)
  CONSTRAINT `FK954BC21C6EA9862F` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
  CONSTRAINT `FK954BC21CAA06CC11` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`uuid`)
);
CREATE TABLE `mi_idd` (
  `id` int(11) NOT NULL AUTO_INCREMENT
  `idd` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `idd` (`idd`)
);
CREATE TABLE `mi_idd_to_cc` (
  `idd_id` int(11) NOT NULL
  `cc_id` bigint(20) NOT NULL
  PRIMARY KEY (`idd_id`,`cc_id`)
  KEY `fk_idd_to_cc2` (`cc_id`)
  CONSTRAINT `fk_idd_to_cc2` FOREIGN KEY (`cc_id`) REFERENCES `mi_country` (`id`)
  CONSTRAINT `fk_idd_to_cc` FOREIGN KEY (`idd_id`) REFERENCES `mi_idd` (`id`)
);
CREATE TABLE `mi_installed_app_count_by_label` (
  `label_id` bigint(20) NOT NULL
  `inventory_id` bigint(20) DEFAULT NULL
  `installed_count` bigint(21) NOT NULL DEFAULT '0'
  KEY `label_id` (`label_id`,`inventory_id`)
);
CREATE TABLE `mi_installed_app_count_by_label2` (
  `label_id` bigint(20) NOT NULL
  `inventory_id` bigint(20) DEFAULT NULL
  `installed_count` bigint(21) NOT NULL DEFAULT '0'
  KEY `label_id` (`label_id`,`inventory_id`)
);
CREATE TABLE `mi_label` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_by` bigint(20) NOT NULL
  `created_at` datetime NOT NULL
  `modified_by` bigint(20) NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `named_query` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `query_params` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `exclude_criteria` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_static` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'ADMIN'
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `modified_at` bigint(20) DEFAULT NULL
  `is_es_search` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`id`)
  UNIQUE KEY `name` (`name`)
  KEY `fk_label_created_by_id` (`created_by`)
  KEY `fk_label_modified_by_id` (`modified_by`)
  CONSTRAINT `fk_label_created_by_id` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `fk_label_modified_by_id` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_label_asset_assoc` (
  `label_id` bigint(20) NOT NULL
  `asset_id` bigint(20) NOT NULL
  PRIMARY KEY (`label_id`,`asset_id`)
  KEY `fk_label_assoc_asset_id` (`asset_id`)
  CONSTRAINT `fk_label_assoc_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `mi_asset` (`id`)
  CONSTRAINT `fk_label_assoc_label_id` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
);
CREATE TABLE `mi_label_to_device` (
  `label_id` bigint(20) NOT NULL
  `device_id` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`label_id`,`device_id`)
  KEY `mi_label_to_device_device_id` (`device_id`)
);
CREATE TABLE `mi_lang_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `language_id` bigint(20) NOT NULL
  `country_id` bigint(20) DEFAULT NULL
  `code` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `message` text COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_message_to_country` (`country_id`)
  KEY `fk_message_to_lang` (`language_id`)
  CONSTRAINT `fk_message_to_country` FOREIGN KEY (`country_id`) REFERENCES `mi_country` (`id`)
  CONSTRAINT `fk_message_to_lang` FOREIGN KEY (`language_id`) REFERENCES `mi_language` (`id`)
);
CREATE TABLE `mi_lang_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `language_id` bigint(20) NOT NULL DEFAULT '1'
  `country_id` bigint(20) DEFAULT NULL
  `version` int(11) NOT NULL DEFAULT '0'
  `category` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform_type` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `row_type` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'admin'
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_template_to_country` (`country_id`)
  KEY `fk_template_to_lang` (`language_id`)
  CONSTRAINT `fk_template_to_country` FOREIGN KEY (`country_id`) REFERENCES `mi_country` (`id`)
  CONSTRAINT `fk_template_to_lang` FOREIGN KEY (`language_id`) REFERENCES `mi_language` (`id`)
);
CREATE TABLE `mi_lang_template_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `template_id` bigint(20) NOT NULL
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT ''
  `template` text COLLATE utf8_unicode_ci NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_data_to_template` (`template_id`)
  CONSTRAINT `fk_data_to_template` FOREIGN KEY (`template_id`) REFERENCES `mi_lang_template` (`id`)
);
CREATE TABLE `mi_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `english_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `lang_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `iso_639_2` varchar(3) COLLATE utf8_unicode_ci NOT NULL
  `iso_639_1` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL
  `enabled` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `appliance_enabled` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
  KEY `idx_mi_language_iso_639_1` (`iso_639_1`)
);
CREATE TABLE `mi_local_ca` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `signature_algorithm` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `cert_lifetime` bigint(20) DEFAULT NULL
  `crl_url` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `crl_lifetime` bigint(20) DEFAULT NULL
  `serial_number` bigint(20) DEFAULT NULL
  `client_cert_lifetime` bigint(20) NOT NULL
  `client_cert_keysize` int(11) NOT NULL
  `client_cert_hash_algorithm` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `cert_url` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_local_ca_certs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mi_local_ca_id` bigint(20) NOT NULL
  `serial_number` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `subject` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  `status` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'A'
  `cert_expiration` datetime NOT NULL
  `created_at` datetime DEFAULT NULL
  `modified_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  KEY `idx_ca_certs_local_ca_id` (`mi_local_ca_id`)
  CONSTRAINT `fk_mi_local_ca_certs_to_mi_local_ca_id` FOREIGN KEY (`mi_local_ca_id`) REFERENCES `mi_local_ca` (`id`)
);
CREATE TABLE `mi_local_ca_extensions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mi_local_ca_id` bigint(20) DEFAULT NULL
  `extension_name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `idx_local_ca_id` (`mi_local_ca_id`)
  CONSTRAINT `fk_local_ca_ext_local_ca_id` FOREIGN KEY (`mi_local_ca_id`) REFERENCES `mi_local_ca` (`id`)
);
CREATE TABLE `mi_mai_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `captured_at` datetime NOT NULL
  `phone_status` int(11) DEFAULT NULL
  `cell_available` int(11) DEFAULT NULL
  `cell_connected` int(11) DEFAULT NULL
  `mcc` int(11) DEFAULT NULL
  `mnc` int(11) DEFAULT NULL
  `lac` int(11) DEFAULT NULL
  `cellid` int(11) DEFAULT NULL
  `nid` int(11) DEFAULT NULL
  `sid` int(11) DEFAULT NULL
  `signal_strength` int(11) DEFAULT NULL
  `bluetooth_status` int(11) DEFAULT NULL
  `wifi_status` int(11) DEFAULT NULL
  `battery_percentage` int(11) DEFAULT NULL
  `latitude` double DEFAULT NULL
  `longitude` double DEFAULT NULL
  `created_at` datetime NOT NULL
  `device_id` bigint(20) NOT NULL
  `reason` int(11) DEFAULT NULL
  `cell_bytes_in` int(11) DEFAULT NULL
  `cell_bytes_out` int(11) DEFAULT NULL
  `wifi_bytes_in` int(11) DEFAULT NULL
  `wifi_bytes_out` int(11) DEFAULT NULL
  `client_log_id` int(11) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_mi_mai_state_constraint2` (`device_id`,`captured_at`,`reason`,`client_log_id`)
  CONSTRAINT `fk_key_mai_state_device_id` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_mcc_mnc_codes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mcc` int(11) NOT NULL
  `mnc` int(11) NOT NULL
  `country_id` bigint(20) NOT NULL
  `carrier_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `mi_mcc_mnc_codes_to_carrier_id` (`carrier_id`)
  KEY `mi_mcc_mnc_codes_to_country_id` (`country_id`)
  KEY `idx_mi_mcc_mnc_codes_mcc_country_id` (`mcc`,`country_id`)
  CONSTRAINT `mi_mcc_mnc_codes_to_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `mi_carrier_operator` (`id`)
  CONSTRAINT `mi_mcc_mnc_codes_to_country_id` FOREIGN KEY (`country_id`) REFERENCES `mi_country` (`id`)
);
CREATE TABLE `mi_notification_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `client_id` bigint(20) NOT NULL
  `opcode` int(11) NOT NULL
  `file_id` int(11) DEFAULT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL
  `send_attempts` int(11) NOT NULL
  `priority` int(11) NOT NULL
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `message_sender` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `source` char(1) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `modified_at` datetime NOT NULL
  `cookie` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_data` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `mne_idx_01` (`client_id`,`opcode`,`state`)
  KEY `idx_app_data` (`app_data`(45))
);
CREATE TABLE `mi_oem_network_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_id` bigint(20) NOT NULL
  `bundle` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `device_token` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `created_at` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `idx_mi_oem_network_token_device_bundle` (`device_id`,`bundle`)
  CONSTRAINT `fk_device_to_oem_token` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_operator` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `carrier_short_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_id` bigint(20) DEFAULT NULL
  `carrier_type` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
  `email_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `enabled` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `APN` text COLLATE utf8_unicode_ci
  `created_at` datetime DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `FK_OPERATOR_COUNTRY` (`country_id`)
  KEY `idx_mi_operator_carrier_short_name_carrier_type` (`carrier_short_name`,`carrier_type`)
  CONSTRAINT `FK_OPERATOR_COUNTRY` FOREIGN KEY (`country_id`) REFERENCES `mi_country` (`id`)
);
CREATE TABLE `mi_password_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `password_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL
  `user_id` bigint(20) NOT NULL
  `changed_at` datetime NOT NULL
  `changed_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_policy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `priority` bigint(20) NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `active` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `user_override` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `policy_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `profile_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime NOT NULL
  `state` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'C'
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `version` int(11) DEFAULT '1'
  `hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT '0'
  `created_by` bigint(20) NOT NULL DEFAULT '9000'
  `modified_by` bigint(20) NOT NULL DEFAULT '9000'
  `modified_at` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `fk_created_by_policy_to_user` (`created_by`)
  KEY `fk_modified_by_policy_to_user` (`modified_by`)
  KEY `idx_mi_policy_name_profile_type_state` (`name`,`profile_type`,`state`)
  KEY `idx_mi_policy_policy_type_profile_type` (`policy_type`,`profile_type`)
  KEY `idx_mi_policy_profile_type_state_active_priority` (`profile_type`,`state`,`active`,`priority`)
  CONSTRAINT `fk_created_by_policy_to_user` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `fk_modified_by_policy_to_user` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_policy_change_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `modified_at` datetime DEFAULT NULL
  `policy_id` bigint(20) NOT NULL
  `modified_by` bigint(20) NOT NULL DEFAULT '9000'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_policy_history_policy_id` (`policy_id`)
  KEY `fk_policy_change_history_to_user` (`modified_by`)
  CONSTRAINT `fk_policy_change_history_to_user` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `mi_policy_history_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `mi_policy` (`id`)
);
CREATE TABLE `mi_policy_subject_holder` (
  `policy_id` bigint(20) NOT NULL
  `subject_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`policy_id`,`subject_holder_id`)
  KEY `FK5865FC69FE5462FB` (`subject_holder_id`)
  KEY `idx_mi_policy_subject_holder_trash_subject_holder_id` (`trash`,`subject_holder_id`)
  CONSTRAINT `FK5865FC69B5F555B2` FOREIGN KEY (`policy_id`) REFERENCES `mi_policy` (`id`)
);
CREATE TABLE `mi_pub_app_catalog_to_label` (
  `catalog_id` bigint(20) NOT NULL
  `label_id` bigint(20) NOT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`catalog_id`,`label_id`)
  KEY `fk_pub_app_catalog_label` (`label_id`)
  CONSTRAINT `fk_pub_app_catalog_catalog` FOREIGN KEY (`catalog_id`) REFERENCES `mi_app_catalog` (`id`)
  CONSTRAINT `fk_pub_app_catalog_label` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
);
CREATE TABLE `mi_pub_document_catalog_to_label` (
  `catalog_id` bigint(20) NOT NULL
  `label_id` bigint(20) NOT NULL
  PRIMARY KEY (`catalog_id`,`label_id`)
  KEY `fk_document_catalog_to_label_label` (`label_id`)
  CONSTRAINT `fk_document_catalog_to_label_label` FOREIGN KEY (`label_id`) REFERENCES `mi_label` (`id`)
  CONSTRAINT `fk_document_catalog_to_label_catalog` FOREIGN KEY (`catalog_id`) REFERENCES `mi_document_catalog` (`id`)
);
CREATE TABLE `mi_rating` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL
  `value` int(11) NOT NULL
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `region_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_rating_region` (`region_id`)
  CONSTRAINT `fk_rating_region` FOREIGN KEY (`region_id`) REFERENCES `mi_rating_region` (`id`)
);
CREATE TABLE `mi_rating_region` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(2) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`,`name`,`value`)
);
CREATE TABLE `mi_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `file_id` int(11) NOT NULL
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `secure` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `uri` varchar(2048) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `resource_type` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` datetime NOT NULL
  `link_type` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_dir` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `content_length` bigint(20) DEFAULT NULL
  `file_handle_id` char(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_by` bigint(20) DEFAULT NULL
  `created_by` bigint(20) NOT NULL
  `parent_id` bigint(20) DEFAULT NULL
  `linked_to` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `snapshot_id` bigint(20) DEFAULT NULL
  `is_rom` tinyint(1) NOT NULL DEFAULT '0'
  `is_excluded` tinyint(1) NOT NULL DEFAULT '0'
  `is_freq_changing` tinyint(1) NOT NULL DEFAULT '0'
  `is_system` tinyint(1) NOT NULL DEFAULT '0'
  `is_encrypted` tinyint(1) NOT NULL DEFAULT '0'
  `is_temp_volatile` tinyint(1) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  KEY `FK88907751AA06CC11` (`created_by`)
  KEY `FK88907751622FE78B` (`file_handle_id`)
  KEY `FK88907751FC58B090` (`modified_by`)
  KEY `FK88907751D3605016` (`parent_id`)
  KEY `FK88907751F77609A7` (`linked_to`)
  KEY `FKCA94A269C42B004A` (`snapshot_id`)
  KEY `mi_resource_n01` (`file_id`,`trash`,`snapshot_id`)
  CONSTRAINT `FK88907751622FE78B` FOREIGN KEY (`file_handle_id`) REFERENCES `mi_file_handle` (`file_handle_uuid`)
  CONSTRAINT `FK88907751AA06CC11` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `FK88907751D3605016` FOREIGN KEY (`parent_id`) REFERENCES `mi_resource` (`id`)
  CONSTRAINT `FK88907751F77609A7` FOREIGN KEY (`linked_to`) REFERENCES `mi_resource` (`uuid`)
  CONSTRAINT `FK88907751FC58B090` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `FKCA94A269C42B004A` FOREIGN KEY (`snapshot_id`) REFERENCES `mi_snapshots` (`id`)
);
CREATE TABLE `mi_resource_holder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `next_file_id` int(11) NOT NULL DEFAULT '2147483647'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  UNIQUE KEY `mi_resource_holder_n01_covering` (`uuid`,`next_file_id`)
);
CREATE TABLE `mi_resource_holder_resource` (
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `resource_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  PRIMARY KEY (`resource_holder_id`,`resource_id`)
  KEY `FK229BD4536EA9862F` (`resource_id`)
  CONSTRAINT `FK229BD453A18F2A32` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
  CONSTRAINT `FK229BD4536EA9862F` FOREIGN KEY (`resource_id`) REFERENCES `mi_resource` (`uuid`)
);
CREATE TABLE `mi_resource_holder_to_resource` (
  `resource_holder_id` bigint(20) NOT NULL
  `resource_id` bigint(20) NOT NULL
  PRIMARY KEY (`resource_holder_id`,`resource_id`)
  KEY `FK229BD4536EA9863F` (`resource_id`)
  CONSTRAINT `FK229BD453A18F2A33` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`id`)
  CONSTRAINT `FK229BD4536EA9863F` FOREIGN KEY (`resource_id`) REFERENCES `mi_resource` (`id`)
);
CREATE TABLE `mi_restore_folder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `folder_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_id` bigint(20) NOT NULL
  `snapshot_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `mi_device_restore_folder_device_fk` (`device_id`)
  KEY `mi_device_restore_folder_snapshot_fk` (`snapshot_id`)
  CONSTRAINT `mi_device_restore_folder_device_fk` FOREIGN KEY (`device_id`) REFERENCES `mi_device` (`id`)
  CONSTRAINT `mi_device_restore_folder_snapshot_fk` FOREIGN KEY (`snapshot_id`) REFERENCES `mi_snapshots` (`id`)
);
CREATE TABLE `mi_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `action_value` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `client_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `policy_id` bigint(20) NOT NULL
  `condition_id` bigint(20) DEFAULT NULL
  `parent_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  UNIQUE KEY `mi_rule_u01` (`type`,`policy_id`)
  KEY `FK3EA463BFB5F555B2` (`policy_id`)
  KEY `FK3EA463BFD3C87F04` (`parent_id`)
  KEY `K3EA463BF844946AC` (`condition_id`)
  CONSTRAINT `FK3EA463BFB5F555B2` FOREIGN KEY (`policy_id`) REFERENCES `mi_policy` (`id`)
  CONSTRAINT `FK3EA463BFD3C87F04` FOREIGN KEY (`parent_id`) REFERENCES `mi_rule` (`id`)
  CONSTRAINT `K3EA463BF844946AC` FOREIGN KEY (`condition_id`) REFERENCES `policy_condition` (`id`)
);
CREATE TABLE `mi_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `modified_at` datetime NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `idx_mi_settings_u01` (`property`,`value`,`modified_at`)
);
CREATE TABLE `mi_sid_country_code` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `start_sid` int(11) NOT NULL
  `end_sid` int(11) NOT NULL
  `no_of_sids` int(11) NOT NULL
  `country_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `country_code` bigint(20) NOT NULL
  `has_conflicts` char(1) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_sid_country_conflict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `sid` int(11) NOT NULL
  `country_assigned` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_code_assigned` int(11) NOT NULL
  `country_using` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_code_using` int(11) NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mi_snapshots` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `client_id` bigint(20) NOT NULL
  `version` int(11) NOT NULL
  `created_at` datetime NOT NULL
  `description` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `status_code` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 's'
  PRIMARY KEY (`id`)
  KEY `FK93DB121AC093F2BE` (`client_id`)
  CONSTRAINT `fk_mi_snapshots_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mi_subject_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `subject_type` char(1) COLLATE utf8_unicode_ci NOT NULL
  `subject_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `subject_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `policy_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `from_policy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `to_policy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `phone_count` int(11) DEFAULT '0'
  `modified_by` bigint(20) NOT NULL DEFAULT '9000'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `fk_modified_by_subject_history_to_user` (`modified_by`)
  CONSTRAINT `fk_modified_by_subject_history_to_user` FOREIGN KEY (`modified_by`) REFERENCES `mi_user` (`id`)
);
CREATE TABLE `mi_subject_holder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `profile_version` bigint(20) NOT NULL DEFAULT '0'
  `profile_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `profile_pin` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `scep_challenge` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `sync_profile_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  UNIQUE KEY `uuid` (`uuid`)
  UNIQUE KEY `idx_mi_subject_holder_uuid_type_profile_hash_profile_pin_etc` (`uuid`,`type`,`profile_hash`,`profile_pin`,`profile_version`,`scep_challenge`,`sync_profile_hash`)
);
CREATE TABLE `mi_sync_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` text COLLATE utf8_unicode_ci
  `client_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_mi_sync_settings_to_mi_client_id` (`client_id`)
  CONSTRAINT `fk_mi_sync_settings_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mi_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `principal` varchar(50) COLLATE utf8_unicode_ci NOT NULL
  `account_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT 't'
  `created_at` datetime NOT NULL
  `created_by` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `email_address` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `source` char(1) COLLATE utf8_unicode_ci DEFAULT 'L'
  `password_hash` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `first_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `language_id` bigint(20) DEFAULT NULL
  `country_id` bigint(20) DEFAULT NULL
  `modified_at` bigint(20) DEFAULT NULL
  `force_password_change` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `google_apps_password` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `google_apps_password_hash` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `google_apps_password_lifetime` bigint(20) DEFAULT NULL
  `saml_pseudonymous_id` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_admin_portal_login_time` bigint(20) DEFAULT NULL
  `encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  `google_apps_encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
  UNIQUE KEY `principal` (`principal`)
  UNIQUE KEY `uuid` (`uuid`)
  UNIQUE KEY `mu_idx_01` (`uuid`,`country_id`,`created_at`,`created_by`,`email_address`,`account_enabled`,`first_name`,`language_id`,`last_name`,`name`,`password`,`password_hash`,`principal`,`source`,`trash`)
  KEY `FK3EA5B88EAA06CC11` (`created_by`)
  KEY `idx_mi_user_source_trash_principal_` (`source`,`trash`,`principal`,`email_address`,`password_hash`)
  KEY `idx_mi_user_email_address_trash_source_id` (`email_address`,`trash`,`source`,`id`)
  KEY `idx_mi_user_first_name` (`first_name`)
  KEY `idx_mi_user_last_name` (`last_name`)
  KEY `idx_mi_user_emailaddress` (`email_address`)
  CONSTRAINT `FK3EA5B88EAA06CC11` FOREIGN KEY (`created_by`) REFERENCES `mi_user` (`uuid`)
);
CREATE TABLE `mi_user_action` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `action_type` varchar(32) COLLATE utf8_unicode_ci NOT NULL
  `actor_id` bigint(20) DEFAULT NULL
  `user_in_role` bigint(20) DEFAULT NULL
  `requested_at` datetime NOT NULL
  `completed_at` datetime DEFAULT NULL
  `reason` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `result_message` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL
  `status` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `parent_id` bigint(20) DEFAULT NULL
  `subject_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `update_request_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `subject_type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'n'
  `object_type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'n'
  `object_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `subject_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `cookie` char(16) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `fk_admin_action_actor_id` (`actor_id`)
  KEY `fk_admin_action_role_id` (`user_in_role`)
  KEY `fk_user_action_parent_id` (`parent_id`)
  KEY `mua_idx_01` (`actor_id`,`requested_at`)
  KEY `idx_mi_user_action_subject_id_status_action_type_etc` (`subject_id`,`status`,`action_type`,`actor_id`,`parent_id`)
  CONSTRAINT `fk_user_action_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `mi_user_action` (`id`) ON DELETE SET NULL
  CONSTRAINT `fk_admin_action_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `fk_admin_action_role_id` FOREIGN KEY (`user_in_role`) REFERENCES `role` (`id`)
);
CREATE TABLE `mi_user_device` (
  `id` bigint(20) NOT NULL
  `user_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `FKB6BD47274F9E1112` (`user_id`)
  CONSTRAINT `FKB6BD47274F9E1112` FOREIGN KEY (`user_id`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `FKB6BD4727AE6674A9` FOREIGN KEY (`id`) REFERENCES `mi_device` (`id`)
);
CREATE TABLE `mi_user_group` (
  `user_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `group_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  `primary_group` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`user_id`,`group_id`)
  KEY `FK692DEF8ED16A1D22` (`group_id`)
  CONSTRAINT `FK692DEF8ED16A1D22` FOREIGN KEY (`group_id`) REFERENCES `mi_group` (`uuid`)
  CONSTRAINT `FK692DEF8E4F9E1112` FOREIGN KEY (`user_id`) REFERENCES `mi_user` (`uuid`)
);
CREATE TABLE `mi_virtual_phone` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `base_dir` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `mi_client_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `fk_virtual_to_mi_client_id` (`mi_client_id`)
  CONSTRAINT `fk_mi_virtual_phone_to_mi_client_id` FOREIGN KEY (`mi_client_id`) REFERENCES `mi_device` (`mi_client_id`)
);
CREATE TABLE `mi_winmo_registries` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `client_id` bigint(20) NOT NULL
  `resource_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `snapshot_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `FK0280E8CF63BA6BE7` (`client_id`)
  KEY `FKB5EDD8369750CEF89` (`resource_uuid`)
  KEY `FK8571FD765C73A573` (`snapshot_id`)
  CONSTRAINT `fk_mi_winmo_registries_to_mi_client_id` FOREIGN KEY (`client_id`) REFERENCES `mi_device` (`mi_client_id`)
  CONSTRAINT `FK8571FD765C73A573` FOREIGN KEY (`snapshot_id`) REFERENCES `mi_snapshots` (`id`)
  CONSTRAINT `FKB5EDD8369750CEF89` FOREIGN KEY (`resource_uuid`) REFERENCES `mi_resource` (`uuid`)
);
CREATE TABLE `mi_winmo_rom_apps` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `file_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `created_at` datetime NOT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mifs_authorized_device_attributes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  PRIMARY KEY (`id`)
);
CREATE TABLE `mifs_display_filters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `parameter_key` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `search` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `replace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uidx_mifs_display_filters_parameter_key_etc` (`parameter_key`,`platform_id`,`search`,`replace`)
  UNIQUE KEY `uidx_mifs_display_filters_search_etc` (`search`,`parameter_key`,`platform_id`,`replace`)
  KEY `fk_display_filter_platform` (`platform_id`)
  KEY `mdf_idx_01` (`platform_id`,`parameter_key`,`search`,`replace`)
  CONSTRAINT `fk_display_filter_platform` FOREIGN KEY (`platform_id`) REFERENCES `mi_app_platforms` (`id`)
);
CREATE TABLE `mifs_ldap_authorized_entities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `dn` varchar(640) COLLATE utf8_unicode_ci DEFAULT NULL
  `dn_type` char(1) COLLATE utf8_unicode_ci NOT NULL
  `priority` int(11) NOT NULL
  `principal` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `idx_mifs_ldap_authorized_entities_dn_dn_type_priority` (`dn`(255),`dn_type`,`priority`)
);
CREATE TABLE `mifs_ldap_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `dn` varchar(640) COLLATE utf8_unicode_ci DEFAULT NULL
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `mifs_ldap_server_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `url` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `failover_url` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `auth_principal` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `auth_password` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `auth_password_hash` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `search_timeout` bigint(20) DEFAULT NULL
  `referral_action` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `ad_domain` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `ou_base_dn` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `ou_search_filter` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `user_base_dn` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_search_filter` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `user_search_scope` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  `user_attr_uid` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `user_attr_first_name` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_last_name` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_display_name` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_email_address` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_dn` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_upn` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_locale` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_member_of` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_custom1` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_custom2` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_custom3` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_attr_custom4` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_base_dn` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_search_filter` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `group_search_scope` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  `group_attr_name` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `group_attr_member` varchar(512) COLLATE utf8_unicode_ci NOT NULL
  `group_attr_custom1` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_attr_custom2` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_attr_custom3` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_attr_custom4` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `enabled` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `trash` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `auth_method` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `auth_id_format` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `use_client_cert` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `request_mutual_auth` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `qop` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `krb_realm` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `krb_kdc` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL
  `krb_encryption` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `auth_properties` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `group_member_format` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
  `directory_type` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `disable_wildcards` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
);
CREATE TABLE `mifs_ldap_user_attributes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `value` varchar(640) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `mifs_ldap_user_attributes_1` (`user_id`)
  CONSTRAINT `mifs_ldap_user_attributes_1` FOREIGN KEY (`user_id`) REFERENCES `mifs_ldap_users` (`id`)
);
CREATE TABLE `mifs_ldap_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `dn` varchar(640) COLLATE utf8_unicode_ci DEFAULT NULL
  `principal` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `first_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `email` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `display_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `attr_dn` varchar(640) COLLATE utf8_unicode_ci DEFAULT NULL
  `upn` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `locale` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `mlu_idx_01` (`principal`)
  KEY `idx_mifs_ldap_users_email` (`email`)
);
CREATE TABLE `mifs_map_ldap_authorized_entities_to_roles` (
  `ldap_entity_id` bigint(20) NOT NULL
  `role_id` bigint(20) NOT NULL
  PRIMARY KEY (`ldap_entity_id`,`role_id`)
  KEY `mifs_map_ldap_authorized_entities_to_roles_2` (`role_id`)
  CONSTRAINT `mifs_map_ldap_authorized_entities_to_roles_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
  CONSTRAINT `mifs_map_ldap_authorized_entities_to_roles_1` FOREIGN KEY (`ldap_entity_id`) REFERENCES `mifs_ldap_authorized_entities` (`id`)
);
CREATE TABLE `mifs_map_ldap_users_to_ldap_groups` (
  `user_id` bigint(20) NOT NULL
  `group_id` bigint(20) NOT NULL
  PRIMARY KEY (`user_id`,`group_id`)
  KEY `mifs_map_ldap_users_ldap_groups_2` (`group_id`)
  CONSTRAINT `mifs_map_ldap_users_ldap_groups_1` FOREIGN KEY (`user_id`) REFERENCES `mifs_ldap_users` (`id`)
  CONSTRAINT `mifs_map_ldap_users_ldap_groups_2` FOREIGN KEY (`group_id`) REFERENCES `mifs_ldap_groups` (`id`)
);
CREATE TABLE `mifs_map_users_to_roles` (
  `user_id` bigint(20) NOT NULL
  `role_id` bigint(20) NOT NULL
  PRIMARY KEY (`user_id`,`role_id`)
  KEY `mifs_map_users_to_roles_2` (`role_id`)
  CONSTRAINT `mifs_map_users_to_roles_1` FOREIGN KEY (`user_id`) REFERENCES `mi_user` (`id`)
  CONSTRAINT `mifs_map_users_to_roles_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
);
CREATE TABLE `notify_alert` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_id` bigint(20) DEFAULT NULL
  `event_subscription_id` bigint(20) DEFAULT NULL
  `alert_defn_id` bigint(20) NOT NULL
  `alert_severity_id` bigint(20) DEFAULT NULL
  `alert_transport_id` bigint(20) DEFAULT NULL
  `alert_status_id` bigint(20) NOT NULL
  `device_uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `dispatch_device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `label_id` bigint(20) DEFAULT NULL
  `alert_date` datetime NOT NULL
  `expiry_date` datetime DEFAULT NULL
  `alert_text` text COLLATE utf8_unicode_ci
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_active` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `source_alert_id` bigint(20) DEFAULT NULL
  `retries` int(11) DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `alert_defn_id` bigint(20) NOT NULL
  `config_param_id` bigint(20) NOT NULL
  `default_param_value` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_defn` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `alert_severity_id` bigint(20) NOT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `default_lang_template_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_param` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `alert_id` bigint(20) NOT NULL
  `config_param_id` bigint(20) NOT NULL
  `param_value` text COLLATE utf8_unicode_ci
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_alert_param_n01` (`alert_id`)
);
CREATE TABLE `notify_alert_policy_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `mi_policy_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `alert_defn_id` bigint(20) NOT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_preference` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscription_id` bigint(20) NOT NULL
  `alert_defn_id` bigint(20) NOT NULL
  `alert_transport_id` bigint(20) DEFAULT NULL
  `alert_severity_id` bigint(20) DEFAULT NULL
  `send_to` bigint(20) DEFAULT NULL
  `config_param_id` bigint(20) DEFAULT NULL
  `param_value` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_severity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `severity_order` int(11) NOT NULL
  `lang_template_data_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `severity_order` (`severity_order`)
  UNIQUE KEY `description` (`description`)
  UNIQUE KEY `name` (`name`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_status` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `name` (`name`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_transport` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `retries` int(11) DEFAULT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `name` (`name`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_alert_transport_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `alert_defn_id` bigint(20) NOT NULL
  `alert_transport_id` bigint(20) NOT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_config_param` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `param_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `param_description` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `param_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `param_datatype` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `parent_param_id` bigint(20) DEFAULT NULL
  `lang_template_data_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_defn_id` bigint(20) NOT NULL
  `device_uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `event_date` datetime NOT NULL
  `is_processed` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_expired` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_action` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_action_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_defn_id` bigint(20) NOT NULL
  `event_action_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `notify_fk_event_actions2` (`event_action_id`)
  KEY `notify_fk_event_defns` (`event_defn_id`)
  CONSTRAINT `notify_fk_event_actions2` FOREIGN KEY (`event_action_id`) REFERENCES `notify_event_action` (`id`)
  CONSTRAINT `notify_fk_event_defns` FOREIGN KEY (`event_defn_id`) REFERENCES `notify_event_defn` (`id`)
);
CREATE TABLE `notify_event_alert_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_defn_id` bigint(20) NOT NULL
  `alert_defn_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_defn_id` bigint(20) NOT NULL
  `config_param_id` bigint(20) NOT NULL
  `default_param_value` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_defn` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_system_event` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_exclusion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscription_id` bigint(20) NOT NULL
  `user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `label_id` bigint(20) DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `notify_event_exclusion_n01` (`event_subscription_id`)
);
CREATE TABLE `notify_event_param` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_id` bigint(20) NOT NULL
  `config_param_id` bigint(20) NOT NULL
  `param_value` text COLLATE utf8_unicode_ci
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_event_param_n01` (`event_id`)
);
CREATE TABLE `notify_event_preference` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscription_id` bigint(20) NOT NULL
  `config_param_id` bigint(20) NOT NULL
  `param_value` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_subscriber` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscription_id` bigint(20) NOT NULL
  `user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `cc_user_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `cc_device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `label_id` bigint(20) DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_event_subscriber_n01` (`device_uuid`)
  KEY `mi_event_subscriber_n02` (`cc_device_uuid`)
  KEY `mi_event_subscriber_n03` (`label_id`)
  KEY `notify_event_subscriber_n04` (`event_subscription_id`)
);
CREATE TABLE `notify_event_subscriber_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscriber_id` bigint(20) NOT NULL
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `config_param_id` bigint(20) NOT NULL
  `current_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `mi_event_subscriber_data_n01` (`device_uuid`)
  KEY `mi_event_subscriber_data_n02` (`event_subscriber_id`)
);
CREATE TABLE `notify_event_subscription` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_defn_id` bigint(20) NOT NULL
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_enabled` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `updated_by` varchar(100) COLLATE utf8_unicode_ci NOT NULL
  `updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `notify_event_subscription_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `event_subscription_id` bigint(20) DEFAULT NULL
  `lang_template_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_event_sub_lang_template_id` (`lang_template_id`)
  KEY `fk_event_sub_id` (`event_subscription_id`)
  CONSTRAINT `fk_event_sub_lang_template_id` FOREIGN KEY (`lang_template_id`) REFERENCES `mi_lang_template` (`id`)
  CONSTRAINT `fk_event_sub_id` FOREIGN KEY (`event_subscription_id`) REFERENCES `notify_event_subscription` (`id`)
);
CREATE TABLE `os_version` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `build` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  `version` bigint(20) NOT NULL
  `version_string` varchar(16) COLLATE utf8_unicode_ci NOT NULL
  `platform_type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'I'
  PRIMARY KEY (`id`)
  UNIQUE KEY `pk_build_and_platform_type` (`build`,`platform_type`)
);
CREATE TABLE `policy_condition` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `days_of_week` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `start_time` time DEFAULT NULL
  `end_time` time DEFAULT NULL
  `start_date` date DEFAULT NULL
  `end_date` date DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
);
CREATE TABLE `policy_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `resource_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `rule_id` bigint(20) NOT NULL
  `value` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` char(1) COLLATE utf8_unicode_ci DEFAULT 'C'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  KEY `FK285087BB4B07772` (`rule_id`)
  KEY `policy_resource_rule_id` (`rule_id`)
  CONSTRAINT `FK285087BB4B07772` FOREIGN KEY (`rule_id`) REFERENCES `mi_rule` (`id`)
);
CREATE TABLE `portal_appliance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime DEFAULT NULL
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `domainName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `portal_device_registration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `status` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `passcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_primary` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 't'
  `hashed` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'f'
  `deviceId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `carrier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `domain_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `binary_location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `passcode_expires_at` datetime DEFAULT NULL
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `last_status` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `owner_uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `notification_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `platform` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL
  `is_personal` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `total_try` int(11) DEFAULT NULL
  `is_restore` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `snapshot_id` bigint(20) DEFAULT NULL
  `device_id_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `num_reminders` int(11) DEFAULT NULL
  `is_reinstall` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `notify_user` char(1) COLLATE utf8_unicode_ci DEFAULT 't'
  `operator_id` bigint(20) DEFAULT NULL
  `country_id` bigint(20) DEFAULT NULL
  `email_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `appliance_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `passcode` (`passcode`)
  KEY `FKA5BAB0024962D7E` (`appliance_id`)
  CONSTRAINT `FKA5BAB0024962D7E` FOREIGN KEY (`appliance_id`) REFERENCES `portal_appliance` (`id`)
);
CREATE TABLE `portal_mi_domain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `created_at` datetime DEFAULT NULL
  `created_by` datetime DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `modifying_comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
  UNIQUE KEY `uuid` (`uuid`)
);
CREATE TABLE `portal_mi_resource_folder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `folder_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL
  `device_registration_id` bigint(20) NOT NULL
  PRIMARY KEY (`id`)
  KEY `FK9557F51CFCF47E43` (`device_registration_id`)
  CONSTRAINT `FK9557F51CFCF47E43` FOREIGN KEY (`device_registration_id`) REFERENCES `portal_device_registration` (`id`)
);
CREATE TABLE `q_activation_request` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `created_at` datetime DEFAULT NULL
  `completed_at` datetime DEFAULT NULL
  `state` char(1) COLLATE utf8_unicode_ci DEFAULT 'p'
  `priority` int(11) DEFAULT NULL
  `json` text COLLATE utf8_unicode_ci NOT NULL
  `type` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `device_id` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `idx_q_activation_request_p_s` (`state`,`priority`)
  KEY `idx_activation_request_check_duplicate` (`state`,`type`,`device_id`)
);
CREATE TABLE `role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'R'
  PRIMARY KEY (`id`)
  UNIQUE KEY `id` (`id`)
  UNIQUE KEY `unq_role_name` (`name`)
  UNIQUE KEY `unq_role_description` (`description`)
);
CREATE TABLE `search_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `index_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL
  `document_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL
  `total_record_count` bigint(50) DEFAULT NULL
  `indexed_record_count` bigint(50) DEFAULT NULL
  `failed_record_count` bigint(50) DEFAULT NULL
  `batch_size` bigint(10) DEFAULT NULL
  `indexing_status` varchar(50) COLLATE utf8_unicode_ci NOT NULL
  `running_time_seconds` bigint(50) DEFAULT NULL
  `last_updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `sms_carrier` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `email_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `country_code` char(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1'
  PRIMARY KEY (`id`)
);
CREATE TABLE `user_role_assoc` (
  `user_uuid` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `role_id` bigint(20) NOT NULL
  `created_at` datetime NOT NULL
  `is_primary` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  PRIMARY KEY (`user_uuid`,`role_id`)
  KEY `FKBB72CC004FD90D75` (`role_id`)
  CONSTRAINT `FKBB72CC004FD90D75` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
  CONSTRAINT `FKBB72CC006CA08AB2` FOREIGN KEY (`user_uuid`) REFERENCES `mi_user` (`uuid`)
);
CREATE TABLE `virus_scan_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `scanned_at` datetime DEFAULT NULL
  `infected` char(1) COLLATE utf8_unicode_ci DEFAULT 'f'
  `scan_report_loc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `virus_scan_id` bigint(20) NOT NULL
  `mi_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  PRIMARY KEY (`id`)
  KEY `FK40B126D42BDA501C` (`virus_scan_id`)
  KEY `FK40B126D49708DB91` (`mi_user`)
  CONSTRAINT `FK40B126D42BDA501C` FOREIGN KEY (`virus_scan_id`) REFERENCES `virus_scan_stats` (`id`)
  CONSTRAINT `FK40B126D49708DB91` FOREIGN KEY (`mi_user`) REFERENCES `mi_user` (`uuid`)
);
CREATE TABLE `virus_scan_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `scanned_at` datetime DEFAULT NULL
  `resource_holder_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL
  `total_files_scanned` int(11) DEFAULT NULL
  `infected_count` int(11) DEFAULT NULL
  `error_count` int(11) DEFAULT NULL
  `scan_duration` bigint(20) DEFAULT NULL
  PRIMARY KEY (`id`)
  KEY `fk_key_virus_scan_stats_rh_id` (`resource_holder_id`)
  CONSTRAINT `fk_key_virus_scan_stats_rh_id` FOREIGN KEY (`resource_holder_id`) REFERENCES `mi_resource_holder` (`uuid`)
);
CREATE TABLE `wp_aet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `enterprise_id` text COLLATE utf8_unicode_ci
  `aet` text COLLATE utf8_unicode_ci
  `aet_hash` text COLLATE utf8_unicode_ci
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_csp_sd_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_updated_at` datetime DEFAULT NULL
  `version` int(11) DEFAULT NULL
  `disable` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_exchange_settings_csp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `account_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `app_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `email` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `domain` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `user_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
  `server_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `use_ssl` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `schedule` int(11) DEFAULT NULL
  `mail_age_filter` int(11) DEFAULT NULL
  `sync_email` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `sync_contacts` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `sync_calendar` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `sync_tasks` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
  `last_updated_at` datetime DEFAULT NULL
  `encryption_algorithm_version` int(11) NOT NULL DEFAULT '0'
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_app_enroll_token_csp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `enterprise_id` text COLLATE utf8_unicode_ci
  `last_updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_command` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `priority` int(11) DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_command_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `state_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_device` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `cert_serial_number` bigint(20) DEFAULT NULL
  `client_md5` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `client_nonce` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `server_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
  `server_md5` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
  `wp_last_sync_at` datetime DEFAULT NULL
  `node_cache_version` int(11) DEFAULT NULL
  `app_hash` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_device_lock_csp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `identifier` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `version` int(11) DEFAULT NULL
  `device_password_enabled` tinyint(1) DEFAULT NULL
  `allow_simple_device_password` tinyint(1) DEFAULT NULL
  `min_device_password_length` tinyint(4) DEFAULT NULL
  `alphanumeric_device_password_required` tinyint(4) DEFAULT NULL
  `device_password_expiration` smallint(6) DEFAULT NULL
  `device_password_history` tinyint(4) DEFAULT NULL
  `max_device_password_failed_attempts` smallint(6) DEFAULT NULL
  `max_inactivity_time_device_lock` smallint(6) DEFAULT NULL
  `min_device_password_complex_characters` tinyint(4) DEFAULT NULL
  `last_updated_at` datetime DEFAULT NULL
  `device_encryption` tinyint(1) DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_email2_csp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `identifier` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `version` int(11) DEFAULT NULL
  `account_guid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `connection_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `auth_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `auth_required` tinyint(1) DEFAULT NULL
  `auth_secret` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `domain` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `dwnday` int(11) DEFAULT NULL
  `format` smallint(6) DEFAULT NULL
  `in_server` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `keep_max` int(11) DEFAULT NULL
  `linger` int(11) DEFAULT NULL
  `name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `out_server` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `reply_addr` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `retrieve` int(11) DEFAULT NULL
  `service_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `service_type` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `smtp_alt_auth_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `smtp_alt_domain` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
  `smtp_alt_enabled` tinyint(1) DEFAULT NULL
  `smtp_alt_password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `in_ssl_enabled` tinyint(1) DEFAULT NULL
  `out_ssl_enabled` tinyint(1) DEFAULT NULL
  `named_props` text COLLATE utf8_unicode_ci
  `last_updated_at` datetime DEFAULT NULL
  PRIMARY KEY (`id`)
);
CREATE TABLE `wp_mdm_notification_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
  `command` int(11) DEFAULT NULL
  `command_args` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL
  `state` bigint(20) DEFAULT NULL
  `send_attempts` int(11) DEFAULT NULL
  `priority` int(11) DEFAULT NULL
  `created_at` datetime DEFAULT NULL
  `modified_at` datetime DEFAULT NULL
  `device_uuid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
  `request_data` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  `response_data` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL
  PRIMARY KEY (`id`)
);
