extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env(name, self)

const _HELP_watch = "Add a widget to watch an expression"
func watch(exp:String):
	get_parent().add_widget2(exp, 0.1)

const _HELP_button = "Add an expression widget button"
func button(display_name:String, exp:String):
	get_parent().add_widget2(exp, 999999, Vector2(0, 0), Vector2(100, 20), display_name)
	
const _HELP_export_panel = "Add a widget to manage export properties"
func export_panel(target:Object):
	return get_parent().add_export_widget(target)

const _HELP_profiler = "Add a widget to monitor performance"
var profiler:
	get:
		get_parent().add_widget2("engine.performance_info", 0.2)
