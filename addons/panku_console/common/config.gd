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


# Full option name in project settings.
static func panku_option(option: String) -> String:
	return CONFIG_SECTION + "/" + option


# A helper function to add custom project settings
# See https://dfaction.net/handling-custom-project-settings-using-gdscript/
static func add_custom_project_setting(
		name: String,
		default_value,
		type: int,
		hint: int = PROPERTY_HINT_NONE, hint_string: String = ""
	) -> void:
	if ProjectSettings.has_setting(name): return

	var setting_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string
	}

	ProjectSettings.set_setting(name, default_value)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(name, default_value)
	ProjectSettings.set_as_basic(name, true)


static func init_all_project_settings() -> void:
	# Seems we can't add descriptions to custom settings now.

	# Disable Panku Console in release builds
	add_custom_project_setting(
		panku_option(OPTIONS.DISABLE_ON_RELEASE),
		false,
		TYPE_BOOL
	)

	# Path to the custom
	# `res://` path default config file, useful if you are going to keep panku console in release builds.
	add_custom_project_setting(
		panku_option(OPTIONS.CUSTOM_DEFAULT_CONFIG),
		INITIAL_DEFAULT_CONFIG_FILE_PATH,
		TYPE_STRING,
		PROPERTY_HINT_FILE,
		"*.cfg"
	)

	# save_project_settings()


static func clear_all_project_settings() -> void:
	for option in OPTIONS.values():
		var opt: String = panku_option(option)
		if ProjectSettings.has_setting(opt):
			ProjectSettings.clear(opt)

	save_project_settings()


static func save_project_settings() -> void:
	var error: int = ProjectSettings.save()
	if error != OK:
		push_error("Encountered error %d when saving project settings." % error)


# Get custom config file path from project settings
static func get_custom_default_config_path() -> String:
	return ProjectSettings.get_setting(panku_option(OPTIONS.CUSTOM_DEFAULT_CONFIG), INITIAL_DEFAULT_CONFIG_FILE_PATH)

# Check if custom config file from project settings exist
static func is_custom_default_config_exists() -> bool:
	return FileAccess.file_exists(get_custom_default_config_path())


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
