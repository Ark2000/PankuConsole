extends VBoxContainer

const MonitorGroup:GDScript = preload("./monitor_group_ui.gd")
const group_prefab:PackedScene = preload("./monitor_group_ui.tscn")

@onready var groups_container:Control = $Groups
@onready var add_group_button:Button = $AddGroupButton

func _ready():
	add_group_button.pressed.connect(add_group)

func get_expressions_by_group() -> Array:
	var result := []
	for child in groups_container.get_children():
		var group:MonitorGroup = child
		result.append(group.get_expressions())
	return result

func set_results_by_group(results:Array):
	if results.size() > groups_container.get_child_count():
		push_error("unexpected parameters.")
		return
	for i in range(results.size()):
		groups_container.get_child(i).set_results(results[i])

func add_group() -> MonitorGroup:
	var group_ui:Node = group_prefab.instantiate()
	groups_container.add_child(group_ui)
	group_ui.group_move_up.connect(
		func():
			groups_container.move_child(group_ui, group_ui.get_index() - 1)
	)
	group_ui.group_move_down.connect(
		func():
			groups_container.move_child(group_ui, group_ui.get_index() + 1)
	)
	return group_ui

func get_persistent_data() -> Array:
	var data := []
	for child in groups_container.get_children():
		data.append(child.get_persistent_data())
	return data

func load_persistent_data(data:Array):
	for child in groups_container.get_children():
		child.queue_free()
	for group_data in data:
		var group_ui = group_prefab.instantiate()
		groups_container.add_child(group_ui)
		group_ui.load_persistent_data(group_data)
