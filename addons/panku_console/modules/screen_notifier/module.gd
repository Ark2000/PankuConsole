class_name PankuModuleScreenNotifier extends PankuModule 
func get_module_name(): return "ScreenNotifier"

var notifier_layer := preload("./resident_logs.tscn").instantiate()

func notify(bbcode:String):
	print("ScreenNotifier: " + bbcode)
	notifier_layer.add_log(bbcode)

func init_module():

	# register env
	var env = preload("./screen_notifier.gd").new()
	env._module = self
	core.register_env("screen_notifier", env)

	core.new_notification_created.connect(notify)

	# setup ui
	core.add_child(notifier_layer)
