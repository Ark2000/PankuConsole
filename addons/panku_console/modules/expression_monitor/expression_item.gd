extends Control

signal expr_changed(new_expr:String)
signal removing

@export var x_btn:Button
@export var ledit:LineEdit
@export var label:Label

func set_result(text:String):
	label.text = text
	label.get_parent().visible = (text != "")

func set_expr(text:String):
	ledit.text = text

func get_expr() -> String:
	return ledit.text

func _ready():
	x_btn.pressed.connect(
		func():
			removing.emit()
			queue_free()
	)
	ledit.focus_exited.connect(
		func():
			expr_changed.emit(ledit.text)
	)
	ledit.text_submitted.connect(
		func(new_text:String):
			expr_changed.emit(new_text)
	)
