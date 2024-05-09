class_name PankuButton extends Control

signal pressed
signal button_down
signal button_up

@export
var button:Button

@export
var trect:TextureRect

@export
var label:Label

var icon:
	set(v):
		trect.texture = v
	get:
		return trect.texture

var text:
	set(v):
		label.text = v
	get:
		return label.text

func _ready():
	
	button.pressed.connect(
		func():
			pressed.emit()
	)
	button.button_down.connect(
		func(): button_down.emit()
	)
	button.button_up.connect(
		func(): button_up.emit()
	)
