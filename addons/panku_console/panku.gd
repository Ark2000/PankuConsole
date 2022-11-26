extends "res://addons/panku_console/components/panku_impl.gd"

#check out default_env.gd to get some examples.
#func add_widget(update_delay:float, update_func:Callable, pressed_func:Callable = (func():pass)):
#	return super.add_widget(update_delay, update_func, pressed_func)

#it gets called when you submit something in the console window.
func execute(env:String, exp:String):
	return super.execute(env, exp)

func get_env(env_name:String):
	return super.get_env(env_name)

#add expression environment (or base instance)
func register_env(env_name:String, env) -> void:
	return super.register_env(env_name, env)

#remove expression environment (or base instance)
func remove_env(env_name:String) -> void:
	return super.remove_env(env_name)

#output to console logs
func output(bbcode:String) -> void:
	return super.output(bbcode)

#output to both resident logs and console logs.
func notify(bbcode:String) -> void:
	return super.notify(bbcode)

func is_console_window_opened() -> bool:
	return super.is_console_window_opened()
