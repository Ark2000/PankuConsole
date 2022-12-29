extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:Color:
	set(v):
		value = v
		$ColorPickerButton.color = v

func _ready():
	$ColorPickerButton.color_changed.connect(
		func(color:Color):
			value = color
			value_changed_by_user.emit()
	)
