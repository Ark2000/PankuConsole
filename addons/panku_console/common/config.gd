class_name PankuConfig

const CONFIG_SECTION = "panku"
const OPTIONS = {
	# See https://github.com/Ark2000/PankuConsole/issues/170
	DISABLE_ON_RELEASE = 'disable_on_release',
	# See https://github.com/Ark2000/PankuConsole/issues/173
	CUSTOM_DEFAULT_CONFIG = 'custom_default_config',
}

const INITIAL_DEFAULT_CONFIG_FILE_PATH = "res://addons/panku_console/default_panku_config.cfg"
const USER_CONFIG_FILE_PATH = "user://panku_config.cfg"

# Get custom config file path from project settings
static func get_custom_default_config_path() -> String:
	return ProjectSettings.get_setting(panku_option(OPTIONS.CUSTOM_DEFAULT_CONFIG), INITIAL_DEFAULT_CONFIG_FILE_PATH)

# Check if custom config file from project settings exist
static func is_custom_default_config_exists() -> bool:
	return FileAccess.file_exists(get_custom_default_config_path())


# Full option name in project settings.
static func panku_option(option: String) -> String:
	return CONFIG_SECTION + "/" + option


# load config from file, always return a dictionary
static func _get_config(file_path:String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content := file.get_as_text()
		var config:Dictionary = str_to_var(content)
		if config: return config
	return {}

# save user config to file
static func set_config(config:Dictionary):
	var file = FileAccess.open(USER_CONFIG_FILE_PATH, FileAccess.WRITE)
	var content = var_to_str(config)
	file.store_string(content)

# get config, if user config exists, return user config, otherwise return default config configured by plugin user
static func get_config() -> Dictionary:
	var user_config:Dictionary = _get_config(USER_CONFIG_FILE_PATH)
	if not user_config.is_empty():
		return user_config
	# if no user config, return default config, which is read-only
	if is_custom_default_config_exists():
		return _get_config(get_custom_default_config_path())

	return _get_config(INITIAL_DEFAULT_CONFIG_FILE_PATH)

static func get_value(key:String, default:Variant) -> Variant:
	return get_config().get(key, default)

static func set_value(key:String, val:Variant) -> void:
	var config = _get_config(USER_CONFIG_FILE_PATH)
	config[key] = val
	set_config(config)
