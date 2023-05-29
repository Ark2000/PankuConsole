extends Control

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)
@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _repl := $REPL

## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()
