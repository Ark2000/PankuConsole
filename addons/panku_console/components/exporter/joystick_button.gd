extends Button

signal value_changed(delta:Vector2)

var prev_mouse_mode
var prev_mouse_pos

func _gui_input(e:InputEvent):
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		prev_mouse_mode = DisplayServer.mouse_get_mode()
		prev_mouse_pos = get_viewport().get_mouse_position()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	if e is InputEventMouseMotion and e.button_mask != MOUSE_BUTTON_NONE:
		value_changed.emit(e.relative)
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and !e.pressed:
		DisplayServer.mouse_set_mode(prev_mouse_mode)
		DisplayServer.warp_mouse(prev_mouse_pos)
