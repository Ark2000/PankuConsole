@tool
extends EditorPlugin

#When enable this plugin, it will add a singleton to Autoload and an input action to Input Map.
#You may need to add a random input action to update Input Map UI.
#Maybe I'll work on this engine bug later, https://github.com/godotengine/godot/issues/25865
func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton("Panku", "res://addons/panku_console/panku.tscn")
	var default_open_console_event = InputEventKey.new()
	default_open_console_event.physical_keycode = KEY_QUOTELEFT
	ProjectSettings.set_setting("input/open_console", {"deadzone":0.5,"events":[default_open_console_event]})
	ProjectSettings.save()
	print("Panku was initialized!")
	print("Project page: https://github.com/Ark2000/PankuConsole")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("Panku")
	ProjectSettings.clear("input/open_console")
	ProjectSettings.save()
	print("Panku was unloaded!")
