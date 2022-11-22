extends "res://addons/panku_console/components/panku_impl.gd"

#add expression environment (or base instance)
func register_env(env_name:String, env):
	super.register_env(env_name, env)

#remove expression environment (or base instance)
func remove_env(env_name:String):
	super.remove_env(env_name)

#output to console logs
func output(bbcode:String):
	super.output(bbcode)

#output to both resident logs and console logs.
func notify(bbcode:String):
	super.notify(bbcode)
