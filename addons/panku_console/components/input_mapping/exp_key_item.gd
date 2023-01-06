extends HBoxContainer

signal exp_edit_submitted(new_exp:String)

@export var exp_edit:LineEdit
@export var remap_button:Button
@export var delete_button:Button

func _ready():
	delete_button.pressed.connect(queue_free)
	exp_edit.text_submitted.connect(
		func(new_text:String):
			exp_edit.release_focus()
			exp_edit_submitted.emit(new_text)
	)
	exp_edit.focus_exited.connect(
		func():
			exp_edit_submitted.emit(exp_edit.text)
	)
