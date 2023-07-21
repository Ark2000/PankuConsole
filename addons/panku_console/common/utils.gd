#@tool
#extends EditorScript
class_name PankuUtils

# It will be included if you download the plugin from mirror repo(https://github.com/Ark2000/panku_console)
const COMMIT_SHA_FILE_PATH = "res://addons/panku_console/COMMIT_SHA"

static func get_plugin_version() -> String:
	var error_result = "Unknown version"
	#load version string from plugin.cfg
	var cfg = ConfigFile.new()
	if cfg.load("res://addons/panku_console/plugin.cfg") != OK:
		return error_result
	return cfg.get_value("plugin", "version", error_result)

static func get_commit_sha() -> String:
	if FileAccess.file_exists(COMMIT_SHA_FILE_PATH):
		return FileAccess.get_file_as_string(COMMIT_SHA_FILE_PATH)
	return ""

static func get_commit_sha_short() -> String:
	return get_commit_sha().substr(0, 7)

static func get_commit_url() -> String:
	var sha := get_commit_sha()
	if sha != "":
		return "https://github.com/Ark2000/PankuConsole/commit/" + sha
	return ""

#func _run():
#	print("plugin_version: ", get_plugin_version())
#	print("commit_sha: ", get_commit_sha())
#	print("commit_sha_short: ", get_commit_sha_short())
#	print("commit_url: ", get_commit_url())
