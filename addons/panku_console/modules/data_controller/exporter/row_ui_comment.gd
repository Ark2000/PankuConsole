class_name PankuCommentRow
extends HBoxContainer

@export var button: PankuButton

var console: PankuConsole


func _ready():
	button.pressed.connect(_send_notify)


func _send_notify() -> void:
	if console:
		console.notify(button.label.text)
