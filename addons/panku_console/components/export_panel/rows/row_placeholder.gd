extends HBoxContainer

signal value_changed_by_user

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value
