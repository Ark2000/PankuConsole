@tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton("Panku", "res://addons/panku_console/panku.tscn")
	print("Panku was initialized!")
	print("Project page: https://github.com/Ark2000/PankuConsole")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("Panku")
	print("Panku was unloaded!")
