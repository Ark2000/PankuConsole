extends PankuConsole.ExporterRowUI

@export var check_box:CheckBox
@export var label:Label
@export var label_btn:Button

func get_ui_val() -> bool:
	return check_box.button_pressed

func update_ui(val:bool):
	check_box.button_pressed = val
	label.text = "ON" if val else "OFF"

func _ready():
	check_box.toggled.connect(
		func(_s):
			ui_val_changed.emit(get_ui_val())
	)
	label_btn.pressed.connect(
		func():
			check_box.button_pressed = !check_box.button_pressed
	)
