extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env(name, self)

const _HELP_watch = "Add a widget to watch an expression"
func watch(exp:String):
	get_parent().add_widget(
		0.1,
		"'[%s]'+str(%s)" %[exp, exp],
		"",
		Vector2(0, 0)
	)

const _HELP_button = "Add an expression widget button"
func button(display_name:String, exp:String):
	get_parent().add_widget(
		9223372036854775807,
		var_to_str(display_name),
		exp,
		Vector2(0, 0)
	)

const _HELP_plans = "Show all widgets plans"
var plans:
	get:
		var c = get_parent()._config["widgets_system"]
		return "[b]Current Plan[/b]: %s\n[b]All Plans[/b]: %s" %[c["current_plan"], ",".join(PackedStringArray(c["plans"].keys()))]

const _HELP_profiler = "Add a widget to monitor performance"
var profiler:
	get:
		get_parent().add_widget(
			1.0,
			"engine.performance_info",
			"",
			Vector2(0, 0)
		)

const _HELP_save_as_new_plan = "Save current widgets as a new plan"
func save_as_new_plan(plan:String):
	get_parent().save_current_widgets_as(plan)

const _HELP_delete_plan = "Delete a widgets plan (Except for current plan)"
func delete_plan(plan:String):
	if get_parent()._config["widgets_system"]["current_plan"] == plan:
		return "failed"
	get_parent().delete_widgets_plan(plan)

const _HELP_load_plan = "Clear current widgets and load a plan"
func load_plan(plan:String):
	if !get_parent().load_widgets_plan(plan):
		(func():
			await get_tree().process_frame
			get_parent().output("failed!")
		).call()
