extends "res://addons/panku_console/components/lynx_window2/lynx_window.gd"

const BUTTON_PREFIX = "export_button_"

const row_edit_int = preload("res://addons/panku_console/components/export_panel/rows/row_edit_int.tscn")
const row_edit_float = preload("res://addons/panku_console/components/export_panel/rows/row_edit_float.tscn")
const row_edit_float_range = preload("res://addons/panku_console/components/export_panel/rows/row_edit_float_range.tscn")
const row_edit_bool = preload("res://addons/panku_console/components/export_panel/rows/row_edit_bool.tscn")
const row_edit_str = preload("res://addons/panku_console/components/export_panel/rows/row_edit_str.tscn")
const row_edit_color = preload("res://addons/panku_console/components/export_panel/rows/row_edit_color.tscn")
const row_edit_enum = preload("res://addons/panku_console/components/export_panel/rows/row_edit_enum.tscn")
const row_placeholder = preload("res://addons/panku_console/components/export_panel/rows/row_placeholder.tscn")
const row_edit_vec2 = preload("res://addons/panku_console/components/export_panel/rows/row_edit_vector_2.tscn")
const row_button = preload("res://addons/panku_console/components/export_panel/rows/button.tscn")

@onready var container := $Body/Content/VBoxContainer
@onready var helpbtn := $Body/Title/Button
@onready var help := $Body/Content/Hint

func _ready():
	super._ready()
	helpbtn.pressed.connect(
		func():
			help.visible = !help.visible
	)
	close_window.connect(
		func():
			queue_free()
	)

func setup(obj:Object, data:Array):
	var value_rows := {}
	for i in range(data.size()):
		var row = null
		var is_button := false
		#button
		if data[i].name.begins_with(BUTTON_PREFIX) and data[i].type == TYPE_STRING:
			var func_name:String = data[i].name.trim_prefix(BUTTON_PREFIX)
			if func_name in obj:
				row = row_button.instantiate()
				row.set_meta("obj_", obj)
				row.set_meta("func_", func_name)
				row.set_meta("text_", obj.get(data[i].name))
				row.set_meta("is_button", true)
				is_button = true
			else:
				push_error("CAN NOT FIND " + func_name)
		elif data[i].type == TYPE_INT and data[i].hint == PROPERTY_HINT_NONE:
			row = row_edit_int.instantiate()
		elif data[i].type == TYPE_VECTOR2:
			row = row_edit_vec2.instantiate()
		elif data[i].type == TYPE_FLOAT and data[i].hint == PROPERTY_HINT_NONE:
			row = row_edit_float.instantiate()
		elif (data[i].type in [TYPE_FLOAT, TYPE_INT]) and data[i].hint == PROPERTY_HINT_RANGE:
			row = row_edit_float_range.instantiate()
			var params = data[i].hint_string.split(",", false)
			if params.size() >= 2:
				row.slider.min_value = params[0].to_float()
				row.slider.max_value = params[1].to_float()
			if params.size() >= 3:
				row.slider.step = params[2].to_float()
			else:
				if data[i].type == TYPE_FLOAT:
					row.slider.step = 0.01
				elif data[i].type == TYPE_INT:
					row.slider.step = 1
		elif data[i].type == TYPE_BOOL:
			row = row_edit_bool.instantiate()
		elif data[i].type == TYPE_STRING:
			row = row_edit_str.instantiate()
		elif data[i].type == TYPE_COLOR:
			row = row_edit_color.instantiate()
		elif data[i].type == TYPE_INT and data[i].hint == PROPERTY_HINT_ENUM:
			row = row_edit_enum.instantiate()
			var params = data[i].hint_string.split(",", false)
			for p in params:
				row.option_button.add_item(p)
		#unsupported export property
		else:
			row = row_placeholder.instantiate()
		if row:
			if !is_button:
				row.title = data[i].name
				var val = obj.get(row.title)
				if val : row.value = val
				row.value_changed_by_user.connect(
					func():
						obj.set(row.title, row.value)
				)
				value_rows[row] = data[i].name
			container.add_child(row)
			row.show()
	
	var timer:Timer = get_node("Timer")
	timer.timeout.connect(
		#sync values
		func():
			for r in value_rows:
				var s:Signal = r.value_changed_by_user
				var c = s.get_connections()[0].callable
				s.disconnect(c)
				var val = obj.get(r.title)
				if val:
					r.value = val
				s.connect(c)
	)
	timer.start()

func set_p(v:Vector2):
	set_position(v)
	return self

func set_s(v:Vector2):
	set_size(v)
	return self

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var cfg = PankuConsole.Config.get_config()
		var obj_name = get_meta("obj_name")
		if obj_name:
			var exp = "widgets.export_panel(%s).set_p(Vector2(%d,%d)).set_s(Vector2(%d,%d))"%[obj_name,position.x,position.y,size.x,size.y]
			if !cfg.has("init_exp"):
				cfg["init_exp"] = []
			cfg["init_exp"].push_back(exp)
		PankuConsole.Config.set_config(cfg)
