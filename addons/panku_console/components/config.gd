class_name PankuConfig

const FILE_NAME = "panku_config"

static func set_config(config:Dictionary):
	var path = "user://" + FILE_NAME
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(config)

static func get_config() -> Dictionary:
	var path = "user://" + FILE_NAME
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var config = file.get_var()
		if config: return config
	return {
		"widgets_data": [],
		"init_exp": [],
		"repl": {
			"visible":false,
			"position":Vector2(0, 0),
			"size":Vector2(200, 200),
		}
	}
