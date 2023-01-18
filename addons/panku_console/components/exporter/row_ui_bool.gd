extends PankuConsole.ExporterRowUI

@export var check_box:CheckBox

func get_ui_val() -> bool:
	return check_box.button_pressed

func update_ui(val:bool):
	check_box.button_pressed = val

func _ready():
	check_box.toggled.connect(
		func(_s):
			ui_val_changed.emit(get_ui_val())
	)
