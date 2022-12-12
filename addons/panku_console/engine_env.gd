extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env(name, self)

const _HELP_fullscreen = "Toggle [fullscreen / window] mode"
func fullscreen(b:bool):
	if b:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

const _HELP_time_scale = "Equals to [color=green]Engine.time_scale[/color]"
func time_scale(val:float):
	Engine.time_scale = val

const _HELP_performance_info = "Show performance info"
var performance_info:
	get:
		return "FPS: %d | Mem: %.2fMB | Objs: %d" % [Engine.get_frames_per_second(), OS.get_static_memory_usage()/1048576.0, Performance.get_monitor(Performance.OBJECT_COUNT)]

const _HELP_snap_screenshot = "Snap a screenshot of current window"
var snap_screenshot:
	get:
		var image = get_viewport().get_texture().get_image()
		var time = str(int(Time.get_unix_time_from_system() * 1000.0))
		var file_name = "screenshot_%s.png" % time
		var path = "user://".path_join(file_name)
		var real_path = OS.get_user_data_dir().path_join(file_name)
		image.save_png(path)
		get_parent().notify("[b]Screenshot[/b] saved at [color=green][url=%s]%s[/url][/color]" % [real_path, real_path])

const _HELP_quit = "Quit application"
var quit:
	get:
		get_tree().quit()
