extends ModuleOptions

@export_group("engine_tools")

@export var export_button_toggle_fullscreen := "Toggle Fullscreen"

func toggle_fullscreen():
	_module.toggle_fullscreen()

@export var export_button_take_screenshot := "Take Screenshot"

func take_screenshot():
	_module.take_screenshot()

@export var export_button_quit := "Quit"

func quit():
	_module.quit()

@export var export_button_toggle_2d_debug_draw := "Toggle 2D Debug Draw"

func toggle_2d_debug_draw():
	_module.toggle_2d_collision_shape_visibility()

@export var export_button_reload_current_scene := "Reload Current Scene"

func reload_current_scene():
	_module.reload_current_scene()

@export_range(0.1, 2.0) var time_scale := 1.0:
	set(v):
		time_scale = v
		_module.set_time_scale(time_scale)

@export var readonly_performance_info:String:
	get:
		return _module.get_performance_info()
