#This script will always be loaded as first env.
#You can add your own methods or variables to play around.
extends Node

const help = """[color=orange][b]available methods[/b][/color]:
[color=orange][b]- Misc[/b][/color]
[b]help[/b] - [i]You are currently using it[/i]
[b]cls[/b] - [i]Clear console logs[/i]
[b]hints[/b] - [i]Random words[/i]
[b]notify(s:String)[/b] - [i]Add a notification[/i]
[b]enable_notifications(b:bool)[/b] - [i]Enable notifications[/i]
[color=orange][b]- Widgets[/b][/color]
[b]w_watch(env:String, exp:String)[/b] - [i]Add a widget to watch an expression[/i]
[b]w_button(text:String, env:String, exp:String)[/b] - [i]Add an expression widget button[/i]
[b]w_perf[/b] - [i]Add a widget to monitor performance[/i]
[b]w_plans[/b] - [i]Show all widgets plans[/i]
[b]w_save_as(plan:String)[/b] - [i]Save current widgets as a new plan[/i]
[b]w_load(plan:String)[/b] - [i]Clear current widgets and load a plan[/i]
[b]w_delete(plan:String)[/b] - [i]Delete a widgets plan (Except for current plan)[/i]
"""

var hints:
	get:
		var words = [
			"[color=orange]Thank you for using Panku Console![/color]",
			"[color=orange][Tip][/color]Type [b]help[/b] to learn more.",
			"[color=orange][Tip][/color]You can change the position of notifications in panku.tscn"
		]
		words.shuffle()
		get_parent().notify(words[0])

#clear console logs
var cls:
	get:
		(func():
			await get_tree().process_frame
			get_parent()._console_logs.clear()
		).call()

var performance_info:
	get:
		return "FPS: %d | Mem: %.2fMB | Objs: %d" % [Engine.get_frames_per_second(), OS.get_static_memory_usage()/1048576.0, Performance.get_monitor(Performance.OBJECT_COUNT)]

var w_plans:
	get:
		var c = get_parent()._config["widgets_system"]
		return "[b]Current Plan[/b]: %s\n[b]All Plans[/b]: %s" %[c["current_plan"], ",".join(PackedStringArray(c["plans"].keys()))]

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

func enable_notifications(b:bool):
	get_parent()._resident_logs.visible = b

func notify(s:String):
	get_parent().notify(s)

#Add a widget to watch an expression
func w_watch(env:String, exp:String):
	get_parent().add_widget(
		0.1,
		env,
		"'[%s.%s]'+str(%s)" %[env, exp, exp],
		"",
		Vector2(0, 0)
	)
#w_watch("player", "position")


#Add an expression widget button
func w_button(display_name:String, env:String, exp:String):
	get_parent().add_widget(
		9223372036854775807,
		env,
		var_to_str(display_name),
		exp,
		Vector2(0, 0)
	)

#w_button("test", "default", "notify('fuck')")

func w_save_as(plan:String):
	get_parent().save_current_widgets_as(plan)

func w_delete(plan:String):
	if get_parent()._config["widgets_system"]["current_plan"] == plan:
		return "failed"
	get_parent().delete_widgets_plan(plan)

func w_load(plan:String):
	if !get_parent().load_widgets_plan(plan):
		(func():
			await get_tree().process_frame
			get_parent().output("failed!")
		).call()
