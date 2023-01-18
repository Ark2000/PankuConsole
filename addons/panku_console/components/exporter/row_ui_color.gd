extends PankuConsole.ExporterRowUI

@export var line_edit:LineEdit
@export var color_picker_button:ColorPickerButton

func get_ui_val() -> Color: 
	return color_picker_button.color

func update_ui(val:Color):
	color_picker_button.color = val
	line_edit.text = color_picker_button.color.to_html().to_upper()

func is_active() -> bool:
	return line_edit.has_focus() or color_picker_button.has_focus()

func _ready():
	color_picker_button.color_changed.connect(
		func(c:Color):
			line_edit.text = color_picker_button.color.to_html().to_upper()
			ui_val_changed.emit(get_ui_val())
	)
	line_edit.text_submitted.connect(
		func(s:String):
			color_picker_button.color = Color(s)
			ui_val_changed.emit(get_ui_val())
	)
	line_edit.focus_exited.connect(
		func():
			color_picker_button.color = Color(line_edit.text)
			ui_val_changed.emit(get_ui_val())
	)
