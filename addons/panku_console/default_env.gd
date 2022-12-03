#This script will always be loaded as first env.
#You can add your own methods or variables to play around.
#Panku will generate hints for thoses constants, variables and functions that don't begin with _
extends Node

#you can add const _HELP_xxx to provide help info which will be extracted by panku.
const _HELP_help = "Provide some information you may need"
var help:String = PankuUtils.generate_help_text_from_script(get_script())

const _HELP_hints = "Get a random hint!"
var hints:
	get:
		var words = [
			"[color=orange]Thank you for using Panku Console![/color]",
			"[color=orange][Tip][/color]Type [b]help[/b] to learn more.",
			"[color=orange][Tip][/color]You can change the position of notifications in panku.tscn"
		]
		words.shuffle()
		get_parent().notify(words[0])

const _HELP_cls = "clear console logs"
var cls:
	get:
		(func():
			await get_tree().process_frame
			get_parent()._console_logs.clear()
		).call()


const _HELP_performance_info = "show performance info"
var performance_info:
	get:
		return "FPS: %d | Mem: %.2fMB | Objs: %d" % [Engine.get_frames_per_second(), OS.get_static_memory_usage()/1048576.0, Performance.get_monitor(Performance.OBJECT_COUNT)]

const _HELP_w_plans = "Show all widgets plans"
var w_plans:
	get:
		var c = get_parent()._config["widgets_system"]
		return "[b]Current Plan[/b]: %s\n[b]All Plans[/b]: %s" %[c["current_plan"], ",".join(PackedStringArray(c["plans"].keys()))]

const _HELP_w_perf = "Add a widget to monitor performance"
var w_perf:
	get:
		get_parent().add_widget(
			1.0,
			"default",
			"performance_info",
			"",
			Vector2(0, 0)
		)

func _ready():
	await get_parent().ready
	get_parent().register_env("default",self)

const _HELP_fullscreen = "toggle [fullscreen / window] mode"
func fullscreen(b:bool):
	if b:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

const _HELP_enable_notifications = "toggle notification system"
func enable_notifications(b:bool):
	get_parent()._resident_logs.visible = b

const _HELP_notify = "Send a notification"
func notify(s:String):
	get_parent().notify(s)

const _HELP_w_watch = "Add a widget to watch an expression"
func w_watch(env:String, exp:String):
	get_parent().add_widget(
		0.1,
		env,
		"'[%s.%s]'+str(%s)" %[env, exp, exp],
		"",
		Vector2(0, 0)
	)

const _HELP_w_button = "Add an expression widget button"
func w_button(display_name:String, env:String, exp:String):
	get_parent().add_widget(
		9223372036854775807,
		env,
		var_to_str(display_name),
		exp,
		Vector2(0, 0)
	)

const _HELP_w_save_as = "Save current widgets as a new plan"
func w_save_as(plan:String):
	get_parent().save_current_widgets_as(plan)

const _HELP_w_delete = "Delete a widgets plan (Except for current plan)"
func w_delete(plan:String):
	if get_parent()._config["widgets_system"]["current_plan"] == plan:
		return "failed"
	get_parent().delete_widgets_plan(plan)

const _HELP_w_load = "Clear current widgets and load a plan"
func w_load(plan:String):
	if !get_parent().load_widgets_plan(plan):
		(func():
			await get_tree().process_frame
			get_parent().output("failed!")
		).call()
