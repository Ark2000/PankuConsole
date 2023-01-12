extends HBoxContainer

signal value_changed_by_user

var option_button:OptionButton:
	get: return $OptionButton

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value:int:
	set(v):
		$OptionButton.select(v)
		value = $OptionButton.selected

func _ready():
	$OptionButton.item_selected.connect(
		func(index:int):
			value = index
			value_changed_by_user.emit()
	)
