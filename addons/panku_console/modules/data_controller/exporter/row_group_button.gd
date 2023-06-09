extends Button

@export var unpressed_icon:Texture2D = preload("res://addons/panku_console/res/icons2/chevron_right.svg")
@export var pressed_icon:Texture2D = preload("res://addons/panku_console/res/icons2/expand_more.svg")

@export var control_group:Array[Control]

func _ready():
	toggled.connect(
		func(button_pressed:bool):
			if button_pressed:
				icon = pressed_icon
				for node in control_group:
					node.show()
			else:
				icon = unpressed_icon
				for node in control_group:
					node.hide()
	)
