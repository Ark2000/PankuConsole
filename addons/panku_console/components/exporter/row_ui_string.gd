extends PankuConsole.ExporterRowUI

@export var line_edit:LineEdit

func get_ui_val() -> String: 
	return line_edit.text

func update_ui(val:String):
	line_edit.text = val

func is_active() -> bool:
	return line_edit.has_focus()

func _ready():
	line_edit.text_submitted.connect(
		func(_s):
			ui_val_changed.emit(get_ui_val())
	)
	line_edit.focus_exited.connect(
		func():
			ui_val_changed.emit(get_ui_val())
	)
