extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:bool:
	set(v):
		value = v
		$CheckButton.button_pressed = value

func _ready():
	$CheckButton.toggled.connect(
		func(button_pressed:bool):
			value = button_pressed
			value_changed_by_user.emit()
	)
