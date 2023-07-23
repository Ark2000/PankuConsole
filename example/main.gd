extends Node2D

func say_hello():
	print("hello!")

func set_bg_to_blue():
	RenderingServer.set_default_clear_color(Color("#5b94c6"))

func set_bg_to_white():
	RenderingServer.set_default_clear_color(Color("#ffffff"))
