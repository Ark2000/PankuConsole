class_name PankuConfig

const CONFIG_SECTION = "panku"
const OPTIONS = {
	# See https://github.com/Ark2000/PankuConsole/issues/170
	DISABLE_ON_RELEASE = 'disable_on_release',
	# See https://github.com/Ark2000/PankuConsole/issues/173
	CUSTOM_DEFAULT_CONFIG = 'custom_default_config',
}

const INITIAL_DEFAULT_CONFIG_FILE_PATH = "res://addons/panku_console/default_panku_config.tres"
const USER_CONFIG_FILE_PATH = "user://panku_config.tres"

static var _cfg:Dictionary = {}
static var _timer:SceneTreeTimer

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
static func _load_config_file(file_path:String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var res := load(file_path) as PankuConsoleSimpleRes
		if res == null: return {}
		return res.data
	return {}

# save user config to file with a time delay
static func save_config_with_delay(delay := 0.2) -> void:
	if _timer: _timer.timeout.disconnect(save_config_immediately)
	_timer = (Engine.get_main_loop() as SceneTree).create_timer(delay, true, false, true)
	_timer.timeout.connect(save_config_immediately)
	
static func save_config_immediately() -> void:
	var res := PankuConsoleSimpleRes.new()
	res.data = _cfg
	var status = ResourceSaver.save(res, USER_CONFIG_FILE_PATH)
	if status != OK: push_error("Failed to save panku config.")
	# print("Saved to ", USER_CONFIG_FILE_PATH)

# get config, if user config exists, return user config, otherwise return default config configured by plugin user
static func _get_config() -> Dictionary:
	if not _cfg.is_empty(): return _cfg
	var user_config:Dictionary = _load_config_file(USER_CONFIG_FILE_PATH)
	if not user_config.is_empty():
		_cfg = user_config
	# if no user config, return default config, which is read-only
	elif is_custom_default_config_exists():
		_cfg = _load_config_file(get_custom_default_config_path())
	else:
		_cfg = _load_config_file(INITIAL_DEFAULT_CONFIG_FILE_PATH)
	return _cfg

static func get_value(key:String, default:Variant = null) -> Variant:
	var cfg := _get_config()
	return cfg.get(key, default)

static func set_value(key:String, val:Variant) -> void:
	var cfg := _get_config()
	cfg[key] = val
	# print("set_value: ", key, val)
	save_config_with_delay()
