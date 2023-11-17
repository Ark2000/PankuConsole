class_name PankuModuleScreenNotifier extends PankuModule 

var notifier_layer := preload("./resident_logs.tscn").instantiate()

func notify(bbcode:String, id:=-1):
	notifier_layer.add_log(bbcode, id)

func init_module():
	core.new_notification_created.connect(notify)

	# setup ui
	core.add_child(notifier_layer)
