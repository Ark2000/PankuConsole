extends HBoxContainer

var title:String = "?":
	set(v):
		title = v
		$Label.text = title

var value
