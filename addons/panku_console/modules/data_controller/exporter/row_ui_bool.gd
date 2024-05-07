extends "./row_ui.gd"

@export var label_btn:Button

func get_ui_val() -> bool:
	return label_btn.button_pressed

func update_ui(val:bool):
	label_btn.button_pressed = val
	if val:
		label_btn.text = "[x] ON"
		set_font_color(label_btn, Color("#3ab38f"))
	else:
		label_btn.text = "[ ] OFF"
		set_font_color(label_btn, Color("#b25566"))
		
# wtf
static func set_font_color(node, color):
	node.set("theme_override_colors/font_color", color)
	node.set("theme_override_colors/font_pressed_color", color)
	node.set("theme_override_colors/font_hover_color", color)
	node.set("theme_override_colors/font_focus_color", color)
	node.set("theme_override_colors/font_disabled_color", color)
	node.set("theme_override_colors/font_hover_pressed_color", color)
	node.set("theme_override_colors/font_outline_color", color)

func _ready():
	update_ui(false)
	label_btn.toggled.connect(
		func(_s):
			ui_val_changed.emit(get_ui_val())
	)
