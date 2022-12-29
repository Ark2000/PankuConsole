extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:float:
	set(v):
		value = v
		$LineEdit.text = str(value)

func _ready():
	$LineEdit.text_submitted.connect(
		func(new_text:String):
			value = new_text.to_float()
			value_changed_by_user.emit()
			$LineEdit.release_focus()
	)
	$Button.gui_input.connect(
		func(e:InputEvent):
			if e is InputEventMouseMotion and e.button_mask != MOUSE_BUTTON_NONE:
				value += e.velocity.x * 0.01
				value_changed_by_user.emit()
	)
