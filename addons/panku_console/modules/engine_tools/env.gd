var _module:PankuModule

const _HELP_toggle_fullscreen = "Toggle [fullscreen / windowed] mode"
func toggle_fullscreen() -> void:
	_module.toggle_fullscreen()

const _HELP_set_time_scale = "Equals to [color=green]Engine.time_scale[/color]"
func set_time_scale(val:float) -> void:
	_module.set_time_scale(val)

const _HELP_get_performance_info = "Show performance info"
func get_performance_info() -> String:
	return _module.get_performance_info()

const _HELP_take_screenshot = "Take a screenshot of current window"
func take_screenshot() -> void:
	_module.take_screenshot()

const _HELP_quit = "Quit application"
func quit() -> void:
	_module.quit()

const _HELP_toggle_2d_collision_shape_visibility = "Toggle visibility of 2D collision shapes, useful for debugging"
func toggle_2d_collision_shape_visibility() -> void:
	_module.toggle_2d_collision_shape_visibility()

const _HELP_reload_current_scene = "Reload current scene"
func reload_current_scene() -> void:
	_module.reload_current_scene()

