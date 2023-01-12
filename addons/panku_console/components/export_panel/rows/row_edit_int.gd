extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:int:
	set(v):
		value = v
		$LineEdit.text = str(value)

func _ready():
	$LineEdit.text_submitted.connect(
		func(new_text:String):
			value = new_text.to_int()
			value_changed_by_user.emit()
			$LineEdit.release_focus()
	)
	$Button.pressed.connect(
		func():
			value -= 1
			value_changed_by_user.emit()
	)
	$Button2.pressed.connect(
		func():
			value += 1
			value_changed_by_user.emit()
	)
