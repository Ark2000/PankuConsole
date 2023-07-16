@tool
extends EditorPlugin

const SingletonName = "Panku"

func _enter_tree():
	add_autoload_singleton(SingletonName, "res://addons/panku_console/console.tscn")
	print("Panku Console initialized! Project page: https://github.com/Ark2000/PankuConsole")

func _disable_plugin():
	remove_autoload_singleton(SingletonName)
	print("Panku Console disabled.")
