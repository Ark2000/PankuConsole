class_name PankuConfig

const FILE_NAME = "panku_config"

#default config
static func get_default_configs():
	return {
	"widgets_system": {
		"current_plan": "default",
		"plans": {
			"default": [
				{
					"position": Vector2(80, 0),
					"update_delay": 0.5,
					"env": "default",
					"update_exp": 'engine_performance_info',
					"pressed_exp": "",
				},
				{
					"position": Vector2(0, 0),
					"update_delay": 9223372036854775807,
					"env": "default",
					"update_exp": '"Hint!"',
					"pressed_exp": 'console_hints'
				},
			],
			"empty": []
		}
	}
}

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
	return get_default_configs()
