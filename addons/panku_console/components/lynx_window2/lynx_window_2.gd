extends ColorRect

#Do not connect the button node directly, use these signals to detect click event.
signal title_btn_clicked
signal window_closed

const bookmark_icon:CompressedTexture2D = preload("res://addons/panku_console/res/icons2/bookmark-svgrepo-com.svg")
const bookmark_filled_icon:CompressedTexture2D = preload("res://addons/panku_console/res/icons2/bookmark-filled-svgrepo-com.svg")

@export var _window_title_container:HBoxContainer
@export var _title_btn:Button
@export var _close_btn:Button
@export var _options_btn:Button
@export var _resize_btn:Button
@export var _shadow_focus:Panel
@export var _shadow:NinePatchRect
@export var _container:Panel
@export var _pop_btn:Button
@export var _bookmark_btn:Button

@export var no_resize := false
@export var no_resize_x := false
@export var no_resize_y := false
@export var no_move := false
@export var no_snap := false
@export var no_bookmark := true:
	set(v):
		no_bookmark = v
		_bookmark_btn.visible = !v

@export var no_title := false:
	set(v):
		no_title = v
		_window_title_container.visible = !v

@export var queue_free_on_close := true
@export var flicker := true

var _is_dragging := false
var _drag_start_position:Vector2
var _drag_start_position_global:Vector2
var _is_resizing := false
var _resize_start_position:Vector2
var _os_window:Window
var _content:Control
var _bookmarked := false

func centered():
	var window_rect = get_rect()
	var screen_rect = get_viewport_rect()
	position = (screen_rect.size - window_rect.size) / 2

func get_content():
	return _content

func set_content(node:Control):
	_content = node
	if _os_window and _os_window.visible:
		if _os_window.get_child_count() > 0:
			push_error("Error: error in set_content")
			return
		_os_window.add_child(node)
		return
	if _container.get_child_count() > 0:
		push_error("Error: error in set_content.")
		return
	_container.add_child(node)

func highlight(v:bool):
	_shadow_focus.visible = v

func _ready():
	custom_minimum_size = _window_title_container.get_minimum_size()

	_title_btn.button_down.connect(
		func():
			_is_dragging = true
			_drag_start_position = get_local_mouse_position()
			_drag_start_position_global = get_global_mouse_position()
	)
	_title_btn.button_up.connect(
		func():
			_is_dragging = false
	)
	_resize_btn.button_down.connect(
		func():
			_is_resizing = true
			_resize_start_position = _resize_btn.get_local_mouse_position()
	)
	_resize_btn.button_up.connect(
		func():
			_is_resizing = false
	)
	_close_btn.pressed.connect(
		func():
			window_closed.emit()
			if queue_free_on_close:
				queue_free()
			else:
				hide()
	)
	_bookmark_btn.pressed.connect(
		func():
			_bookmarked = !_bookmarked
			_bookmark_btn.icon = bookmark_filled_icon if _bookmarked else bookmark_icon
	)
	
	_title_btn.gui_input.connect(
		func(e):
			if e is InputEventMouseButton and !e.pressed:
				if e.button_index != MOUSE_BUTTON_NONE:
					if (get_global_mouse_position() - _drag_start_position_global).length_squared() < 4:
						title_btn_clicked.emit()
	)
	visibility_changed.connect(
		func():
			if is_visible_in_tree() and flicker:
				$Border.hey_i_am_here()
	)

	if flicker:
		$Border.hey_i_am_here()
		
	_pop_btn.pressed.connect(switch_to_os_window)
	
	if _container.get_child_count() > 0:
		_content = _container.get_child(0)
		
	if get_parent().has_method("get_enable_os_popup_btns"):
		_pop_btn.visible = get_parent().get_enable_os_popup_btns()

	_bookmark_btn.visible = !no_bookmark
	_bookmark_btn.icon = bookmark_filled_icon if _bookmarked else bookmark_icon

func init_os_window():
	_os_window = Window.new()
	var color_rect = ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_os_window.add_child(color_rect)
	get_tree().root.add_child(_os_window)
	#destructor
	tree_exiting.connect(
		func():
			_os_window.queue_free()
	)
	#switch back to embed window when os window close requested
	_os_window.close_requested.connect(
		func():
			_os_window.remove_child(_content)
			_os_window.hide()
			set_content(_content)
			show()
	)
	if get_parent().has_method("get_os_window_bg_color"):
		color_rect.color = get_parent().get_os_window_bg_color()

func switch_to_os_window():
	if _content == null:
		push_error("Error: No content. ")
		return
	if _os_window == null:
		init_os_window()
	_container.remove_child(_content)
	_os_window.add_child(_content)
	_os_window.size = size
	_os_window.title = _title_btn.text
	_os_window.position = Vector2(DisplayServer.window_get_position(0)) + position
	_content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_os_window.show()
	hide()

func show_window():
	if _os_window and _os_window.visible:
		return 
	show()

func hide_window():
	if _os_window and _os_window.visible:
		_os_window.close_requested.emit()
	hide()

func set_window_visibility(b:bool):
	if b: show_window()
	else: hide_window()

func set_window_title_text(text:String):
	if _os_window and _os_window.visible:
		_os_window.title = text
	else:
		_title_btn.text = text

func _input(e):
	#release focus when you click outside of the window
	if is_visible:
		if e is InputEventMouseButton and e.pressed:
			if !get_global_rect().has_point(get_global_mouse_position()):
				var f = get_viewport().gui_get_focus_owner()
				if f and is_ancestor_of(f):
					f.release_focus()
		if e is InputEventKey and e.keycode == KEY_ESCAPE and e.pressed and get_global_rect().has_point(get_global_mouse_position()):
			window_closed.emit()
			if queue_free_on_close:
				queue_free()
			else:
				hide()

func _process(_delta):
	if !no_move and _is_dragging:
		var tp = position + get_local_mouse_position() - _drag_start_position
		position = lerp(position, tp, 0.4)
	elif !no_resize and _is_resizing:
		var ts = size + _resize_btn.get_local_mouse_position() - _resize_start_position
		ts.x = min(ts.x, get_viewport_rect().size.x)
		ts.y = min(ts.y, get_viewport_rect().size.y)
		if !no_resize_x:
			size.x = lerp(size.x, ts.x, 0.4)
		if !no_resize_y:
			size.y = lerp(size.y, ts.y, 0.4)
	elif !no_snap:
		var window_rect = get_rect()
		var screen_rect = get_viewport_rect()
		var target_position = window_rect.position
		if window_rect.position.y < 0:
			target_position.y = 0
		if window_rect.end.y > screen_rect.end.y:
			target_position.y = screen_rect.end.y - window_rect.size.y
		if window_rect.end.y > screen_rect.end.y + window_rect.size.y / 2:
			target_position.y = screen_rect.end.y - 25
		if window_rect.position.x < 0:
			target_position.x = 0
		if window_rect.end.x > screen_rect.end.x:
			target_position.x = screen_rect.end.x - window_rect.size.x
		var current_position = window_rect.position
		current_position = lerp(current_position, target_position, 0.213)
		position = current_position

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()


func load_data(data:Dictionary):
	_bookmarked = true
	_bookmark_btn.icon = bookmark_filled_icon if _bookmarked else bookmark_icon
	_title_btn.text = data.get("title", "Window")
	size = data.get("size", Vector2(300, 300))
	position = data.get("position", Vector2(0, 0))

func save_data():
	if !_bookmarked: return
	var cfg:Dictionary = PankuConsole.Config.get_config()
	var bookmark_windows_data:Array = cfg.get(PankuConsole.Utils.CFG_BOOKMARK_WINDOWS, [])

	var data = {
		"title": _title_btn.text,
		"size": size,
		"position": position,
		"scene_file_path": get_tree().root.get_children()[-1].scene_file_path
	}
	if _content:
		if _content.has_meta("content_type"):
			data["content_type"] = _content.get_meta("content_type") as String
		if _content.has_meta("content_data"):
			data["content_data"] = _content.get_meta("content_data") as Dictionary

	bookmark_windows_data.append(data)
	cfg[PankuConsole.Utils.CFG_BOOKMARK_WINDOWS] = bookmark_windows_data
	PankuConsole.Config.set_config(cfg)
