extends "./row_ui.gd"

const JoystickButton = preload("./joystick_button.gd")

@export var line_edit:LineEdit
@export var joystick_button:Button

func get_ui_val(): 
	return line_edit.text.to_float()

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
	var j_button:JoystickButton = joystick_button
	j_button.value_changed.connect(
		func(delta:Vector2): 
			update_ui(get_ui_val() + delta.x)
			ui_val_changed.emit(get_ui_val())
	)
