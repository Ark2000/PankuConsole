extends Button

@export var unpressed_icon:Texture2D = preload("res://addons/panku_console/res/pics/arrow-right-2-svgrepo-com.svg")
@export var pressed_icon:Texture2D = preload("res://addons/panku_console/res/pics/arrow-down-2-svgrepo-com.svg")

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

	#show all by default
	button_pressed = true
	toggled.emit(button_pressed)
