extends Button

@export var ratio := 0.01

signal value_changed(delta:Vector2)

func _gui_input(e:InputEvent):
	if e is InputEventMouseMotion and e.button_mask != MOUSE_BUTTON_NONE:
		value_changed.emit(e.velocity * ratio)
