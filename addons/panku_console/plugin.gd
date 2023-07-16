@tool
extends EditorPlugin

const SingletonName = "Panku"

#When enable this plugin, it will add a singleton to Autoload and an input action to Input Map.
#You may need to add a random input action to update Input Map UI.
#Maybe I'll work on this engine bug later, https://github.com/godotengine/godot/issues/25865
func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton(SingletonName, "res://addons/panku_console/console.tscn")
	print("Panku Console was initialized!")
	print("Project page: https://github.com/Ark2000/PankuConsole")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(SingletonName)
	print("Panku Console was unloaded!")
