class_name LynxWindow
extends ColorRect

signal title_clicked_left
signal title_clicked_right
signal close_window

@onready var title_btn:Button = $Body/Title/TitleButton
@onready var title_label:Label = $Body/Title/TitleButton/TitleLabel
@onready var resize_btn:Button = $ResizeButton
@onready var title = $Body/Title
@onready var exit_btn:Button = $Body/Title/ExitButton
@onready var border = $Border
@onready var shadow = $Shadow
@onready var content = $Body/Content
@onready var tsp_group = [title_btn, exit_btn, content]

@export var no_resize := false
@export var no_resize_x := false
@export var no_resize_y := false
@export var no_move := false
@export var no_shadow := false:
	set(v):
		if !is_inside_tree():
			await self.ready
		no_shadow = v
		shadow.visible = !v
@export var no_snap := false
@export var no_title := false:
	set(v):
		if !is_inside_tree():
			await self.ready
		no_title = v
		title.visible = !v
@export var no_border := false
@export var transparency := 1.0:
	set(v):
		if !is_inside_tree():
			await self.ready
			await get_tree().process_frame
		transparency = v
		for c in tsp_group:
			c.self_modulate.a = v

var _is_dragging := false
var _drag_start_position:Vector2
var _drag_start_position_global:Vector2
var _is_resizing := false
var _resize_start_position:Vector2

func _ready():
	title_btn.button_down.connect(
		func():
			_is_dragging = true
			_drag_start_position = get_local_mouse_position()
			_drag_start_position_global = get_global_mouse_position()
	)
	title_btn.button_up.connect(
		func():
			_is_dragging = false
	)
	resize_btn.button_down.connect(
		func():
			_is_resizing = true
			_resize_start_position = resize_btn.get_local_mouse_position()
	)
	resize_btn.button_up.connect(
		func():
			_is_resizing = false
	)
	exit_btn.pressed.connect(
		func():
			hide()
			close_window.emit()
	)
	
	title_btn.gui_input.connect(
		func(e):
			if e is InputEventMouseButton and !e.pressed:
				if e.button_index == MOUSE_BUTTON_LEFT:
					if (get_global_mouse_position() - _drag_start_position_global).length_squared() < 4:
						title_clicked_left.emit()
				elif e.button_index == MOUSE_BUTTON_RIGHT:
					if (get_global_mouse_position() - _drag_start_position_global).length_squared() < 4:
						title_clicked_right.emit()
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
			hide()

func _process(delta):
	if !no_move and _is_dragging:
		var tp = position + get_local_mouse_position() - _drag_start_position
		position = lerp(position, tp, 0.4)
	elif !no_resize and _is_resizing:
		var ts = size + resize_btn.get_local_mouse_position() - _resize_start_position
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
