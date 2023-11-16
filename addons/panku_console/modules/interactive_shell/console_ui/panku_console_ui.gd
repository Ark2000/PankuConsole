extends Control

@onready var _console_logs = $HBoxContainer/Control/VBoxContainer/ConsoleLogs
@onready var _repl := $REPL
@onready var side_button_separator:Node = $HBoxContainer/SideButtons/Space
@onready var side_buttons:Control = $HBoxContainer/SideButtons
@onready var side_separator:Control = $HBoxContainer/VSeparator

const side_button_packed := preload("res://addons/panku_console/modules/interactive_shell/console_ui/side_button.tscn")
const side_menu_config_file_path := "res://addons/panku_console/modules/interactive_shell/side_menu_config.json"

var enable_side_menu := true

func _ready() -> void:
	_repl.output.connect(output)
	
	var config_str := FileAccess.get_file_as_string(side_menu_config_file_path)
	var cfg:Dictionary = JSON.parse_string(config_str)
	
	for item in cfg["items.top"]:
		add_side_button(item["command"], load(item["icon"]), item["text"])
	for item in cfg["items.bottom"]:
		add_side_button(item["command"], load(item["icon"]), item["text"], false)

	resized.connect(
		func():
			var vis := side_buttons.get_minimum_size().y < size.y
			vis = vis and enable_side_menu
			side_buttons.visible = vis
			side_separator.visible = vis
	)

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
