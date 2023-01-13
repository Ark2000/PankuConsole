extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:Vector2:
	set(v):
		value = v
		$PanelContainer/HBoxContainer/LineEdit.text = str(value.x)
		$PanelContainer/HBoxContainer/LineEdit2.text = str(value.y)

func _ready():
	$PanelContainer/HBoxContainer/LineEdit.text_submitted.connect(
		func(new_text:String):
			value.x = new_text.to_float()
			value_changed_by_user.emit()
			$PanelContainer/HBoxContainer/LineEdit.release_focus()
	)

	$PanelContainer/HBoxContainer/LineEdit2.text_submitted.connect(
		func(new_text:String):
			value.y = new_text.to_float()
			value_changed_by_user.emit()
			$PanelContainer/HBoxContainer/LineEdit2.release_focus()
	)

	$Button.gui_input.connect(
		func(e:InputEvent):
			if e is InputEventMouseMotion and e.button_mask != MOUSE_BUTTON_NONE:
				value += e.velocity * 0.01
				value_changed_by_user.emit()
	)
