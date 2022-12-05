#This script will always be loaded as first env.
#You can add your own methods or variables to play around.
#Panku will generate hints for thoses constants, variables and functions that don't begin with _
extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env("default",self)

#you can add const _HELP_xxx to provide help info which will be extracted by panku.
const _HELP_console_help = "Provide some information you may need"
var console_help:String = PankuUtils.generate_help_text_from_script(get_script())

const _HELP_console_hints = "Get a random hint!"
var console_hints:
	get:
		var words = [
			"[color=orange]Thank you for using Panku Console![/color]",
			"[color=orange][Tip][/color]Type [b]help[/b] to learn more.",
			"[color=orange][Tip][/color]You can change the position of notifications in panku.tscn"
		]
		words.shuffle()
		get_parent().notify(words[0])

const _HELP_console_cls = "Clear console logs"
var console_cls:
	get:
		(func():
			await get_tree().process_frame
			get_parent()._console_logs.clear()
		).call()

const _HELP_console_enable_notifications = "Toggle notification system"
func console_enable_notifications(b:bool):
	get_parent()._resident_logs.visible = b

const _HELP_console_notify = "Send a notification"
func console_notify(s:String):
	get_parent().notify(s)

const _HELP_console_party_time = "Let's dance!"
var console_party_time:
	get:
		get_parent().party_time()

const _HELP_engine_fullscreen = "Toggle [fullscreen / window] mode"
func engine_fullscreen(b:bool):
	if b:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

const _HELP_engine_time_scale = "Equals to [color=green]Engine.time_scale[/color]"
func engine_time_scale(val:float):
	Engine.time_scale = val

const _HELP_engine_performance_info = "Show performance info"
var engine_performance_info:
	get:
		return "FPS: %d | Mem: %.2fMB | Objs: %d" % [Engine.get_frames_per_second(), OS.get_static_memory_usage()/1048576.0, Performance.get_monitor(Performance.OBJECT_COUNT)]

const _HELP_engine_snap_screenshot = "Snap a screenshot of current window"
var engine_snap_screenshot:
	get:
		var image = get_viewport().get_texture().get_image()
		var time = str(int(Time.get_unix_time_from_system() * 1000.0))
		var file_name = "screenshot_%s.png" % time
		var path = "user://".path_join(file_name)
		var real_path = OS.get_user_data_dir().path_join(file_name)
		image.save_png(path)
		console_notify("[b]Screenshot[/b] saved at [color=green][url=%s]%s[/url][/color]" % [real_path, real_path])

const _HELP_engine_quit = "Quit application"
var engine_quit:
	get:
		get_tree().quit()

const _HELP_widget_watch = "Add a widget to watch an expression"
func widget_watch(env:String, exp:String):
	get_parent().add_widget(
		0.1,
		env,
		"'[%s.%s]'+str(%s)" %[env, exp, exp],
		"",
		Vector2(0, 0)
	)

const _HELP_widget_button = "Add an expression widget button"
func widget_button(display_name:String, env:String, exp:String):
	get_parent().add_widget(
		9223372036854775807,
		env,
		var_to_str(display_name),
		exp,
		Vector2(0, 0)
	)

const _HELP_widget_plans = "Show all widgets plans"
var widget_plans:
	get:
		var c = get_parent()._config["widgets_system"]
		return "[b]Current Plan[/b]: %s\n[b]All Plans[/b]: %s" %[c["current_plan"], ",".join(PackedStringArray(c["plans"].keys()))]

const _HELP_widget_perf = "Add a widget to monitor performance"
var widget_perf:
	get:
		get_parent().add_widget(
			1.0,
			"default",
			"engine_performance_info",
			"",
			Vector2(0, 0)
		)

const _HELP_widget_save_as = "Save current widgets as a new plan"
func widget_save_as(plan:String):
	get_parent().save_current_widgets_as(plan)

const _HELP_widget_delete = "Delete a widgets plan (Except for current plan)"
func widget_delete(plan:String):
	if get_parent()._config["widgets_system"]["current_plan"] == plan:
		return "failed"
	get_parent().delete_widgets_plan(plan)

const _HELP_widget_load = "Clear current widgets and load a plan"
func widget_load(plan:String):
	if !get_parent().load_widgets_plan(plan):
		(func():
			await get_tree().process_frame
			get_parent().output("failed!")
		).call()
