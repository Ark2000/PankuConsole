extends Button

var obj:Object
var callback:String
var btn_text:String

func _ready():
	if !(obj != null and callback != null and (callback in obj)):
		text = "ERROR"
		return
	text = btn_text
	pressed.connect(
		func():
			if is_instance_valid(obj):
				obj.call(callback)
	)
