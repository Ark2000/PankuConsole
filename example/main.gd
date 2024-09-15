extends Node2D

func e():
	return Panku.module_manager.get_module("expression_monitor_2")

func say_hello():
	print("hello!")

func set_bg_to_blue():
	RenderingServer.set_default_clear_color(Color("#5b94c6"))

func set_bg_to_white():
	RenderingServer.set_default_clear_color(Color("#ffffff"))
