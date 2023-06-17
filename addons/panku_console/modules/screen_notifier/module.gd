class_name PankuModuleScreenNotifier extends PankuModule 

var notifier_layer := preload("./resident_logs.tscn").instantiate()

func notify(bbcode:String):
	print("ScreenNotifier: " + bbcode)
	notifier_layer.add_log(bbcode)

func init_module():
	core.new_notification_created.connect(notify)

	# setup ui
	core.add_child(notifier_layer)
