extends Control

@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _repl := $REPL

func _ready() -> void:
	_repl.output.connect(output)

## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()
