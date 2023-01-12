extends HBoxContainer

signal value_changed_by_user

var slider:HSlider:
	get: return $HSlider

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:float:
	set(v):
		$HSlider.value = v
		value = $HSlider.value
		$LineEdit.text = str(value)

func _ready():
	$LineEdit.text_submitted.connect(
		func(new_text:String):
			value = new_text.to_float()
			$LineEdit.release_focus()
	)
	$HSlider.value_changed.connect(
		func(val:float):
			value = val
			value_changed_by_user.emit()
	)
	value_changed_by_user.connect(
		func():
			print(value)
	)
