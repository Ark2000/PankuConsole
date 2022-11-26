extends MarginContainer

#not sure about the performance
const MAX_LOGS = 500

var logs = []

func _ready():
	$R.meta_clicked.connect(
		func(meta):
			OS.shell_open(meta)
	)

func add_log(bbcode:String):
	if logs.size() >= MAX_LOGS:
		logs.pop_front()
	logs.push_back(bbcode)
	$R.text = "\n".join(PackedStringArray(logs))

func clear():
	logs = []
	$R.text = "\n".join(PackedStringArray(logs))
