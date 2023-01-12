extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:String:
	set(v):
		value = v
		$LineEdit.text = value

func _ready():
	$LineEdit.text_submitted.connect(
		func(new_text:String):
			value = new_text
			value_changed_by_user.emit()
			$LineEdit.release_focus()
	)
