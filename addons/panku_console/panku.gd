extends "res://addons/panku_console/components/panku_impl.gd"

func register_env(env_name:String, env):
	super.register_env(env_name, env)
	
func remove_env(env_name:String):
	super.remove_env(env_name)

func output(bbcode:String):
	super.output(bbcode)
