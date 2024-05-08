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
var _was_tree_paused: bool = false
var _previous_mouse_mode := Input.MOUSE_MODE_VISIBLE
var _show_side_menu:bool

func get_intro() -> String:
	var intro:PackedStringArray = PackedStringArray()
	intro.append("[color=#ffffff44][b][i]> Panku Console[/i][/b][/color]")
	intro.append("[color=#ffffff44]Feature-Packed Runtime Debugging Toolkit for Godot[/color]")
	intro.append("[color=#ffffff44]Version: %s([url=%s][color=#10a00c]%s[/color][/url]) | Visit [color=#3feeb6][url=https://github.com/Ark2000/PankuConsole]github repo[/url][/color] for more info[/color]" % [PankuUtils.get_plugin_version(), PankuUtils.get_commit_url(), PankuUtils.get_commit_sha_short()])
	return "\n".join(intro)

func init_module():
	interactive_shell = preload("./console_ui/panku_console_ui.tscn").instantiate()
	window = core.windows_manager.create_window(interactive_shell)
	add_auto_save_hook(window)
	interactive_shell._repl._module = self
	window.queue_free_on_close = false
	window.set_window_title_text("Interactive Shell V2")
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

	# Grab the mouse when the dev console is visible (e.g. FPS games)
	window.visibility_changed.connect(
		func():
			# the mouse is grabbed when the window is visible
			if window.visible:
				_previous_mouse_mode = Input.mouse_mode
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			# restore the mouse mode when the window is hidden
			else:
				Input.mouse_mode = _previous_mouse_mode
	)

	gui_mode = load_module_data("gui_mode", InputMode.Window)
	pause_if_input = load_module_data("pause_if_popup", true)
	unified_window_visibility = load_module_data("unified_visibility", false)
	init_expr = load_module_data("init_expression", "print('Panku Console Loaded!')")

	_show_side_menu = load_module_data("show_side_menu", true)
	set_side_menu_visible(_show_side_menu)

	window.visibility_changed.connect(update_gui_state)
	simple_launcher.visibility_changed.connect(update_gui_state)
	_is_gui_open = not (window.visible or simple_launcher.visible)
	update_gui_state()

	# TODO: this signal is emitted twice when the window is shown, investigate
	# window.visibility_changed.connect(
	# 	func():
	# 		print("window visibility changed: ", window.visible)
	# )

	# execute init_expr after a short delay
	if init_expr != "":
		core.create_tween().tween_callback(
			func():
				var result = core.gd_exprenv.execute(init_expr)
				core.new_expression_entered.emit(init_expr, result)
		).set_delay(0.1)

	_input_histories = load_module_data("histories", [])

func quit_module():
	super.quit_module()
	save_window_data(window)
	save_module_data("gui_mode", gui_mode)
	save_module_data("histories", _input_histories)
	save_module_data("show_side_menu", _show_side_menu)

func update_gui_state():
	var is_gui_open = window.visible or simple_launcher.visible

	if is_gui_open == _is_gui_open:
		return
	
	if _is_gui_open != is_gui_open:
		core._shell_visibility = is_gui_open
		core.interactive_shell_visibility_changed.emit(is_gui_open)
		_is_gui_open = is_gui_open

	if _is_gui_open and pause_if_input:
		_was_tree_paused = core.get_tree().paused
		core.get_tree().paused = true
	else:
		if core.get_tree().paused:
			core.get_tree().paused = _was_tree_paused
	
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

func set_side_menu_visible(enabled:bool):
	_show_side_menu = enabled
	interactive_shell.enable_side_menu = enabled
	interactive_shell.resized.emit()

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
