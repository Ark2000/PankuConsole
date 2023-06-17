extends Button

@export var unpressed_icon:Texture2D = preload("res://addons/panku_console/res/icons2/chevron_right.svg")
@export var pressed_icon:Texture2D = preload("res://addons/panku_console/res/icons2/expand_more.svg")

@export var control_group:Array

func _ready():
	toggled.connect(set_group_visibility)
	set_group_visibility(false)
	button_pressed = false

func set_group_visibility(enabled:bool):
	icon = pressed_icon if enabled else unpressed_icon
	for node in control_group:
		node.visible = enabled
