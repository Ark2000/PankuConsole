extends PankuConsole.ExporterRowUI

@export var line_edit:LineEdit
@export var button_inc:Button
@export var button_dec:Button

func get_ui_val(): 
	return line_edit.text.to_int()

func update_ui(val:float):
	line_edit.text = str(val)

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
	button_inc.pressed.connect(
		func():
			update_ui(get_ui_val() + 1)
			ui_val_changed.emit(get_ui_val())
	)
	button_dec.pressed.connect(
		func():
			update_ui(get_ui_val() - 1)
			ui_val_changed.emit(get_ui_val())
	)
