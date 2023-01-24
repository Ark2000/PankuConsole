extends MarginContainer

#not sure about the performance
const MAX_LOGS = 400

func _ready():
	$R.meta_clicked.connect(
		func(meta):
			OS.shell_open(meta)
	)

func add_log(bbcode:String):
	$R.text += (bbcode + "\n")

func clear():
	$R.text = ""
