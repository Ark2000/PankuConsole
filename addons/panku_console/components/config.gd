const FILE_NAME = "panku_config.cfg"

static func set_config(config:Dictionary):
	var path = "user://" + FILE_NAME
	var file = FileAccess.open(path, FileAccess.WRITE)
	var content = var_to_str(config)
	file.store_string(content)

static func get_config() -> Dictionary:
	var path = "user://" + FILE_NAME
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		var config:Dictionary = str_to_var(content)
		if config: return config
	return {
		"widgets_data": [],
		"init_exp": [],
		"repl": {
			"visible":false,
			"position":Vector2(0, 0),
			"size":Vector2(400, 400),
		},
		"mini_repl": false
	}
