extends VBoxContainer

signal group_move_up
signal group_move_down

const exp_item_ui_prefab:PackedScene = preload("./expression_item.tscn")
const play_icon:Texture2D = preload("res://addons/panku_console/res/icons2/play-1001-svgrepo-com.svg")
const pause_icon:Texture2D = preload("res://addons/panku_console/res/icons2/pause-1010-svgrepo-com.svg")
const expand_icon:Texture2D = preload("res://addons/panku_console/res/icons2/chevron_right.svg")
const collapse_icon:Texture2D = preload("res://addons/panku_console/res/icons2/expand_more.svg")

@onready var group_toggle_button:Button = $GroupManager/ToggleButton
@onready var rename_line_edit:LineEdit = $GroupManager/RenameLineEdit
@onready var state_control_button:Button = $GroupManager/StateControlButton
@onready var rename_button:Button = $GroupManager/RenameButton
@onready var confirm_rename_button:Button = $GroupManager/ConfirmRenameButton
@onready var cancel_rename_button:Button = $GroupManager/CancelRenameButton
@onready var move_up_button:Button = $GroupManager/MoveUpButton
@onready var move_down_button:Button = $GroupManager/MoveDownButton

@onready var exp_body_container:Control = $PanelContainer
@onready var exp_container:Control = $PanelContainer/VBoxContainer/ExpressionContainer
@onready var add_exp_button:Button = $PanelContainer/VBoxContainer/AddNewExpressionButton
@onready var remove_this_group_button:Button = $GroupManager/RemoveButton

@onready var normal_ui_group:Array = [
	group_toggle_button, 
	state_control_button,
	rename_button
]

@onready var edit_ui_group:Array = [
	rename_line_edit,
	confirm_rename_button,
	cancel_rename_button,
	move_up_button,
	move_down_button,
	remove_this_group_button
]

func _ready():
	edit_ui_group.map(func(item): item.hide())
	normal_ui_group.map(func(item): item.show())
	exp_body_container.hide()

	group_toggle_button.toggle_mode = true
	group_toggle_button.button_pressed = false
	group_toggle_button.toggled.connect(
		func(button_pressed:bool):
			exp_body_container.visible = button_pressed
			group_toggle_button.icon = collapse_icon if button_pressed else expand_icon
	)

	add_exp_button.pressed.connect(
		func():
			var exp_item = exp_item_ui_prefab.instantiate()
			exp_container.add_child(exp_item)
	)
	
	state_control_button.toggle_mode = true
	state_control_button.button_pressed = false
	state_control_button.toggled.connect(
		func(button_pressed:bool):
			state_control_button.icon = pause_icon if button_pressed else play_icon
	)

	rename_button.pressed.connect(
		func():
			edit_ui_group.map(func(item): item.show())
			normal_ui_group.map(func(item): item.hide())
			rename_line_edit.text = group_toggle_button.text
	)
	
	cancel_rename_button.pressed.connect(
		func():
			edit_ui_group.map(func(item): item.hide())
			normal_ui_group.map(func(item): item.show())
	)
	
	confirm_rename_button.pressed.connect(
		func():
			edit_ui_group.map(func(item): item.hide())
			normal_ui_group.map(func(item): item.show())
			group_toggle_button.text = rename_line_edit.text
	)
	
	move_up_button.pressed.connect(
		func():
			group_move_up.emit()
	)
	
	move_down_button.pressed.connect(
		func():
			group_move_down.emit()
	)
	
	remove_this_group_button.pressed.connect(queue_free)
	
	load_persistent_data({
		"group_name": "Unnamed Group",
		"expressions": []
	})

func get_expressions(show_hidden := false) -> Array:
	# optimization?
	var exps = []
	if state_control_button.button_pressed or show_hidden:
		for child in exp_container.get_children():
			exps.append(child.get_expr())
	return exps

func set_results(results:Array):
	if results.size() > exp_container.get_child_count():
		push_error("unexpected parameters.")
		return
	for i in range(results.size()):
		var result:String = results[i]
		exp_container.get_child(i).set_result(result)

func get_persistent_data() -> Dictionary:
	return {
		"group_name": group_toggle_button.text,
		"expressions": get_expressions(true)
	}

func load_persistent_data(data:Dictionary):
	group_toggle_button.text = data["group_name"]
	for child in exp_container.get_children():
		child.queue_free()
	for exp in data["expressions"]:
		var exp_item = exp_item_ui_prefab.instantiate()
		exp_container.add_child(exp_item)
		exp_item.set_expr(exp)
