extends ColorRect

#Do not connect the button node directly, use these signals to detect click event.
signal title_btn_clicked
signal window_closed

@export var _window_title_container:HBoxContainer
@export var _title_btn:Button
@export var _close_btn:Button
@export var _options_btn:Button
@export var _resize_btn:Button
@export var _shadow_focus:Panel
@export var _shadow:NinePatchRect
@export var _content:Panel

@export var no_resize := false
@export var no_resize_x := false
@export var no_resize_y := false
@export var no_move := false
@export var no_snap := false
@export var no_title := false:
	set(v):
		no_title = v
		_window_title_container.visible = !v
		
@export var queue_free_on_close := true

var _is_dragging := false
var _drag_start_position:Vector2
var _drag_start_position_global:Vector2
var _is_resizing := false
var _resize_start_position:Vector2

func centered():
	var window_rect = get_rect()
	var screen_rect = get_viewport_rect()
	position = (screen_rect.size - window_rect.size) / 2

func get_content():
	if _content.get_child_count() > 0:
		return _content.get_child(0)
	return null

func set_content(node:Control):
	assert(_content.get_child_count() == 0)
	assert(node.get_parent() == null)
	_content.add_child(node)
	
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
	
	_title_btn.gui_input.connect(
		func(e):
			if e is InputEventMouseButton and !e.pressed:
				if e.button_index != MOUSE_BUTTON_NONE:
					if (get_global_mouse_position() - _drag_start_position_global).length_squared() < 4:
						title_btn_clicked.emit()
	)

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
