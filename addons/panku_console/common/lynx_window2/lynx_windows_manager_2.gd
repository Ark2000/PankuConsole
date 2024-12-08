#A simple control node managing its child windows
class_name PankuLynxWindowsManager extends Control

const CFG_ENABLE_OS_WINDOW = "enable_os_window"
const CFG_OS_WINDOW_BGCOLOR = "os_window_bg_color"

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

var os_popup_btn_enabled:bool
var os_window_bg_color:Color

func _ready():
	load_data()

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		var flag = true
		#traverse child windows in reverse order, use double shadow to highlight current active window.
		for i in range(get_child_count() - 1, -1, -1):
			var w:Control = get_child(i)
			if w.visible and w.get_global_rect().has_point(get_global_mouse_position()):
				var forefront = get_child(get_child_count() - 1)
				if forefront.has_method("highlight"): forefront.highlight(false)
				w.move_to_front()
				forefront = get_child(get_child_count() - 1)
				if forefront.has_method("highlight"): forefront.highlight(true)
				flag = false
				break
		if flag and get_child_count() > 0:
			var forefront = get_child(get_child_count() - 1)
			if forefront.has_method("highlight"): forefront.highlight(false)

func create_window(content:Control) -> PankuLynxWindow:
	var new_window:PankuLynxWindow = preload("lynx_window_2.tscn").instantiate()
	content.anchors_preset = Control.PRESET_FULL_RECT
	new_window.set_content(content)
	add_child(new_window)
	new_window.show_window()
	return new_window

func enable_os_popup_btns(b:bool):
	#note that this may affect your project
	get_viewport().gui_embed_subwindows = !b
	os_popup_btn_enabled = b
	for w in get_children():
		#maybe there's a better way to get node type
		if !w.has_method("switch_to_os_window"):
			continue 
		w._pop_btn.visible = b

func get_enable_os_popup_btns() -> bool:
	return os_popup_btn_enabled

func set_os_window_bg_color(c:Color):
	os_window_bg_color = c
	for w in get_children():
		#maybe there's a better way to get node type
		if !w.has_method("switch_to_os_window"):
			continue 
		if w._os_window != null:
			w._os_window.get_child(0).color = c

func get_os_window_bg_color() -> Color:
	return os_window_bg_color

func save_data():
	PankuConfig.set_value(CFG_ENABLE_OS_WINDOW, os_popup_btn_enabled)
	PankuConfig.set_value(CFG_OS_WINDOW_BGCOLOR, os_window_bg_color)

func load_data():
	enable_os_popup_btns(PankuConfig.get_value(CFG_ENABLE_OS_WINDOW, false))
	set_os_window_bg_color(PankuConfig.get_value(CFG_OS_WINDOW_BGCOLOR, Color("#2b2e32")))
