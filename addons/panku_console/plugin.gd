@tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton("Panku", "res://addons/panku_console/panku.tscn")
	print("Panku is initialized!")
	print("Project page: www.github.com")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("Panku")
	print("Panku is unloaded!")
