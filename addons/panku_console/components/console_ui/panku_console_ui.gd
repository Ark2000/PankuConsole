extends Control

@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _network := $Network
@onready var _repl := $REPL

## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()

func check_latest_release():
	_network.check_latest_release()
	return "Checking latest release..."

func _ready():
	_network.response_received.connect(
		func(msg:Dictionary):
			if !msg["success"]:
				Console.notify("[color=red][Error][/color] Failed! " + msg["msg"])
				return
			Console.notify("[color=green][info][/color] Latest: [%s] [url=%s]%s[/url]" % [msg["published_at"], msg["html_url"], msg["name"]])
	)
