@tool
extends EditorPlugin

const SingletonName = "Panku"

#You may need to reload project to see the input action named `toggle_console` under input map after enabling plugin.
func _enable_plugin():
	# Initialization of the plugin goes here.
	add_autoload_singleton(SingletonName, "res://addons/panku_console/console.tscn")
	var default_open_console_event = InputEventKey.new()
	default_open_console_event.physical_keycode = KEY_QUOTELEFT
	ProjectSettings.set_setting("input/toggle_console", {"deadzone":0.5,"events":[default_open_console_event]})
	ProjectSettings.save()
	print("Panku Console enabled.")

func _disable_plugin():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(SingletonName)
	ProjectSettings.clear("input/toggle_console")
	ProjectSettings.save()
	print("Panku Console disabled.")

func _enter_tree():
	print("Panku Console initialized! Project page: https://github.com/Ark2000/PankuConsole")
