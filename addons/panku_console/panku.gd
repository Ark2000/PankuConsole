extends "res://addons/panku_console/components/panku_impl.gd"

func is_console_window_opened() -> bool:
	return super.is_console_window_opened()

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
