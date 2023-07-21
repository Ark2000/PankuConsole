class_name PankuModuleInteractiveShell extends PankuModule

var window:PankuLynxWindow
var interactive_shell:Control
var simple_launcher:Control

enum InputMode {
	Window,
	Launcher
}

var gui_mode:InputMode = InputMode.Window
var pause_if_input:bool = true
var unified_window_visibility:bool = false
var init_expr:String = ""
var _is_gui_open:bool = false

func get_intro() -> String:
	var intro:PackedStringArray = PackedStringArray()
	intro.append("[font_size=56][color=#ffffff44][b][i]> Panku Console[/i][/b][/color][/font_size]")
	intro.append("[font_size=18][color=#ffffff44]Feature-Packed Runtime Debugging Toolkit for Godot[/color][/font_size]")
	intro.append("[font_size=18][color=#ffffff44]Version: %s([url=%s][color=#10a00c]%s[/color][/url]) | Visit [color=#10a00c][url=https://github.com/Ark2000/PankuConsole]github repo[/url][/color] for more info[/color][/font_size]" % [PankuUtils.get_plugin_version(), PankuUtils.get_commit_url(), PankuUtils.get_commit_sha_short()])
	return "\n".join(intro)

func init_module():
	interactive_shell = preload("./console_ui/panku_console_ui.tscn").instantiate()
	window = core.windows_manager.create_window(interactive_shell)
	interactive_shell._repl._module = self
	window.queue_free_on_close = false
	window.set_window_title_text("Interative Shell V2")
	load_window_data(window)
	window.hide_window()

	interactive_shell.output(get_intro())

	simple_launcher = preload("./mini_repl_2.tscn").instantiate()
	simple_launcher.console = core
	core.add_child(simple_launcher)
	simple_launcher.repl._module = self
	simple_launcher.hide()

	core.toggle_console_action_just_pressed.connect(
		func():
			if gui_mode == InputMode.Window:
				if window.visible:
					window.hide_window()
				else:
					window.show_window()
			elif gui_mode == InputMode.Launcher:
				simple_launcher.visible = not simple_launcher.visible
	)

	gui_mode = load_module_data("gui_mode", InputMode.Window)
	pause_if_input = load_module_data("pause_if_input", true)
	unified_window_visibility = load_module_data("unified_window_visibility", false)
	init_expr = load_module_data("init_expr", "")

	window.visibility_changed.connect(update_gui_state)
	simple_launcher.visibility_changed.connect(update_gui_state)
	_is_gui_open = not (window.visible or simple_launcher.visible)
	update_gui_state()

	get_module_opt().init_expression = load_module_data("init_expr", "")
	# execute init_expr
	if init_expr != "":
		core.gd_exprenv.execute(init_expr)
	
	_input_histories = load_module_data("histories", [])

func quit_module():
	save_window_data(window)
	save_module_data("gui_mode", gui_mode)
	save_module_data("pause_if_input", pause_if_input)
	save_module_data("unified_window_visibility", unified_window_visibility)
	save_module_data("init_expr", init_expr)
	save_module_data("histories", _input_histories)

func update_gui_state():
	var is_gui_open = window.visible or simple_launcher.visible
	if _is_gui_open != is_gui_open:
		core.interactive_shell_visibility_changed.emit(is_gui_open)
		_is_gui_open = is_gui_open
	if _is_gui_open and pause_if_input:
		core.get_tree().paused = true
	else:
		core.get_tree().paused = false
	if unified_window_visibility:
		core.windows_manager.visible = _is_gui_open

func open_window():
	if gui_mode == InputMode.Window:
		if not window.visible:
			window.show_window()
		else:
			core.notify("The window is alreay opened.")
	elif gui_mode == InputMode.Launcher:
		gui_mode = InputMode.Window
		simple_launcher.hide()
		window.show_window()

func open_launcher():
	if gui_mode == InputMode.Window:
		gui_mode = InputMode.Launcher
		window.hide_window()
		simple_launcher.show()
	elif gui_mode == InputMode.Launcher:
		if not simple_launcher.visible:
			simple_launcher.show()
		else:
			core.notify("The launcher is alreay opened.")


func set_unified_window_visibility(enabled:bool):
	unified_window_visibility = enabled
	update_gui_state()

func set_pause_if_popup(enabled:bool):
	pause_if_input = enabled
	update_gui_state()

const MAX_HISTORY = 10
var _input_histories := []

func get_histories() -> Array:
	return _input_histories

func add_history(s:String) -> void:
	_input_histories.append(s)
	if _input_histories.size() > MAX_HISTORY:
		_input_histories.remove_at(0)
