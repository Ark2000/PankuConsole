extends Button

func _ready():
	var obj_:Object = get_meta("obj_")
	var func_:String = get_meta("func_")
	var text_:String = get_meta("text_")
	if !(obj_ != null and func_ != null and (func_ in obj_)):
		return
	text = text_
	pressed.connect(
		func():
			if is_instance_valid(obj_):
				obj_.call(func_)
	)
