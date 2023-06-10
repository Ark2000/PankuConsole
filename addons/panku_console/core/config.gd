const FILE_NAME = "panku_config.cfg"
const FILE_PATH = "user://" + FILE_NAME

static func set_config(config:Dictionary):
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	var content = var_to_str(config)
	file.store_string(content)

static func get_config() -> Dictionary:
	if FileAccess.file_exists(FILE_PATH):
		var file = FileAccess.open(FILE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var config:Dictionary = str_to_var(content)
		if config: return config
	return {}
