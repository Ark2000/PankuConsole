extends Control

@onready var _console_logs = $HBoxContainer/Control/VBoxContainer/ConsoleLogs
@onready var _repl := $REPL
@onready var side_button_separator:Node = $HBoxContainer/SideButtons/Space

const side_button_packed := preload("res://addons/panku_console/modules/interactive_shell/console_ui/side_button.tscn")

func _ready() -> void:
	_repl.output.connect(output)
	
	add_side_button("native_logger.open()", preload("res://addons/panku_console/res/icons2/info2.svg"), "Debug Logs")
	add_side_button("expression_monitor.open_window()", preload("res://addons/panku_console/res/icons2/eye.svg"), "Watch Exp")
	add_side_button("keyboard_shortcuts.open()", preload("res://addons/panku_console/res/icons2/keyboard.svg"), "Shortcut")
	add_side_button("history_manager.open()", preload("res://addons/panku_console/res/icons2/history.svg"), "History")
	
	add_side_button("general_settings.open()", preload("res://addons/panku_console/res/icons2/gear.svg"), "Settings", false)

## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()

func add_side_button(exp:String, icon:Texture2D, text:String, top:= true):
	var new_button:Button = side_button_packed.instantiate()
	new_button.icon = icon
	new_button.title = text
	side_button_separator.get_parent().add_child(new_button)
	side_button_separator.get_parent().move_child(
		new_button, 
		side_button_separator.get_index() + int(!top)
	)
	new_button.pressed.connect(
		func():
			_repl._module.core.gd_exprenv.execute(exp)
	)
