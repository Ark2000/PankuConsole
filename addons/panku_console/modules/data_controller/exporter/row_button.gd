extends Button

var obj:Object = self
var callback:String = "default_callback"
var btn_text:String = "click me"

func default_callback():
	print("hello")

func _ready():
	text = btn_text
	pressed.connect(
		func():
			if is_instance_valid(obj):
				obj.call(callback)
	)
