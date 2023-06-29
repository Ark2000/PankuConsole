class_name PankuUtils

static func get_plugin_version() -> String:
	var error_result = "Unknown version"
	#load version string from plugin.cfg
	var cfg = ConfigFile.new()
	if cfg.load("res://addons/panku_console/plugin.cfg") != OK:
		return error_result
	return cfg.get_value("plugin", "version", error_result)
