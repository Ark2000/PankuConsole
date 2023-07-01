extends Control
const BUTTON_PREFIX = "export_button_"
const COMMENT_PREFIX = "export_comment_"
const TEXT_LABEL_MIN_X = 120

@export var container:VBoxContainer

var objects := []
var rows_need_update:Array = []
var row_objects:Array[Object] = []

func _ready() -> void:
	init()

func create_rows_from_object(index:int):
	var obj:Object = objects[index]
	var row_types := []
	var rows := []

	if obj == null:
		return


	if !is_instance_valid(obj):
		return

	var script = obj.get_script()
	if script == null:
		return

	var data = script.get_script_property_list()
	for d in data:
		if d.name.begins_with("_"): continue
		if d.name.begins_with("readonly"):
			row_types.append("read_only")
			rows.append(create_ui_row_read_only(d))
			continue
		if d.usage == (PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE):
			if d.name.begins_with(BUTTON_PREFIX) and d.type == TYPE_STRING:
				row_types.append("func_button")
				rows.append(create_ui_row_func_button(d, obj))
			elif d.name.begins_with(COMMENT_PREFIX) and d.type == TYPE_STRING:
				row_types.append("comment")
				rows.append(create_ui_row_comment(obj.get(d.name)))
			elif d.type == TYPE_INT and d.hint == PROPERTY_HINT_NONE:
				row_types.append("int")
				rows.append(create_ui_row_int(d))
			elif d.type == TYPE_FLOAT and d.hint == PROPERTY_HINT_NONE:
				row_types.append("float")
				rows.append(create_ui_row_float(d))
			elif d.type in [TYPE_FLOAT, TYPE_INT] and d.hint == PROPERTY_HINT_RANGE:
				row_types.append("range_number")
				rows.append(create_ui_row_range_number(d))
			elif d.type == TYPE_VECTOR2:
				row_types.append("vec2")
				rows.append(create_ui_row_vec2(d))
			elif d.type == TYPE_BOOL:
				row_types.append("bool")
				rows.append(create_ui_row_bool(d))
			elif d.type == TYPE_STRING:
				row_types.append("string")
				rows.append(create_ui_row_string(d))
			elif d.type == TYPE_COLOR:
				row_types.append("color")
				rows.append(create_ui_row_color(d))
			elif d.type == TYPE_INT and d.hint == PROPERTY_HINT_ENUM:
				row_types.append("enum")
				rows.append(create_ui_row_enum(d))
			else:
				row_types.append("read_only")
				rows.append(create_ui_row_read_only(d))
		elif d.usage == PROPERTY_USAGE_GROUP:
			row_types.append("group_button")
			rows.append(create_ui_row_group_button(d, []))

	var current_group_button = null
	var control_group = []
	for i in range(rows.size()):
		var row_type:String = row_types[i]
		var row = rows[i]
		if row_type == "group_button":
			if current_group_button != null:
				current_group_button.control_group = control_group
			control_group = []
			current_group_button = row
		else:
			if current_group_button != null:
				control_group.append(row)
		if not row_type in ["group_button", "func_button", "comment"]:
			rows_need_update.append(row)
			row_objects.append(obj)
	if control_group.size() > 0:
		current_group_button.control_group = control_group

	for row in rows:
		container.add_child(row)

func init():
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	for i in range(objects.size()):
		create_rows_from_object(i)

	init_data()

	create_tween().set_loops().tween_callback(update_rows).set_delay(0.1)

func is_empty() -> bool:
	return container.get_child_count() == 0

func update_rows():
	for i in range(rows_need_update.size()):
		var row = rows_need_update[i]
		var obj = row_objects[i]
		var prop_name = row.name_label.text

		if !row.visible: continue
		if row.is_active(): continue
		
		row.update_ui(obj.get(prop_name))

func init_data():
	for i in range(rows_need_update.size()):
		var row = rows_need_update[i]
		var obj = row_objects[i]
		var prop_name = row.name_label.text

		row.ui_val_changed.connect(
			func(val):
				if !is_instance_valid(obj):
					return
				if prop_name in obj:
					obj.set(prop_name, val)
		)

func init_ui_row(ui_row:Control, property:Dictionary) -> Control:
	ui_row.name_label.text = property.name
	ui_row.name_label.custom_minimum_size.x = TEXT_LABEL_MIN_X
	return ui_row

func create_ui_row_float(property:Dictionary) -> Control:
	var ui_row = preload("./row_float.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_int(property:Dictionary) -> Control:
	var ui_row = preload("./row_int.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_range_number(property:Dictionary) -> Control:
	var ui_row = preload("./row_range_number.tscn").instantiate()
	ui_row.setup(property.type, property.hint_string.split(",", false))
	return init_ui_row(ui_row, property)

func create_ui_row_vec2(property:Dictionary) -> Control:
	var ui_row = preload("./row_vec_2.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_bool(property:Dictionary) -> Control:
	var ui_row = preload("./row_bool.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_string(property:Dictionary) -> Control:
	var ui_row = preload("./row_string.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_color(property:Dictionary) -> Control:
	var ui_row = preload("./row_color.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_enum(property:Dictionary) -> Control:
	var ui_row = preload("./row_enum.tscn").instantiate()
	ui_row.setup(property.hint_string.split(",", false))
	return init_ui_row(ui_row, property)

func create_ui_row_read_only(property:Dictionary) -> Control:
	var ui_row = preload("./row_read_only.tscn").instantiate()
	return init_ui_row(ui_row, property)

func create_ui_row_comment(comment:String) -> Control:
	var ui_row = preload("./row_comment.tscn").instantiate()
	ui_row.label.text = comment
	return ui_row

func create_ui_row_func_button(property:Dictionary, object:Object) -> Control:
	var ui_row:Button = preload("./row_button.tscn").instantiate()
	ui_row.text = object.get(property.name)
	var func_name:String = property.name.trim_prefix(BUTTON_PREFIX)
	if func_name in object:
		ui_row.pressed.connect(Callable(object, func_name))
	return ui_row

func create_ui_row_group_button(property:Dictionary, group:Array) -> Control:
	var ui_row:Button = preload("./row_group_button.tscn").instantiate()
	ui_row.text = property.name
	ui_row.control_group = group
	return ui_row
