extends CanvasLayer

const logitem2_proto := preload("./log_item.tscn")

const MAX_LOGS = 10

var prev_log = ""

@export var named_container:VBoxContainer
@export var unnamed_container:VBoxContainer

# logs whose id >= 0
var named_logs := {}

func add_log(bbcode:String, id:=-1):
	# logs whose id>=0 will be fixed to the bottom of the log list
	# useful for loop print
	# you can use `get_instance_id()` as logs's unique id
	if id >= 0:
		if !named_logs.has(id):
			var new_node = logitem2_proto.instantiate()
			new_node.amount_panel.hide()
			new_node.life = 1.0
			new_node.get_node("ColorRect").color = Color("#23aaf277")
			named_container.add_child(new_node)
			named_container.move_child(new_node, 0)
			named_logs[id] = new_node
			new_node.tree_exiting.connect(
				func():
					named_logs.erase(id)
			)
		var log_node = named_logs[id]
		named_logs[id].content_label.text = bbcode
		log_node.tween3.stop(); log_node.tween3.play()
		return

	#see the new log if can be combined with previous one
	if prev_log == bbcode and unnamed_container.get_child_count() > 0:
		var prev_node = unnamed_container.get_child(unnamed_container.get_child_count() - 1)
		prev_node.amount += 1
		prev_node.amount_label.text = "x" + str(prev_node.amount)
		prev_node.amount_panel.show()
		prev_node.tween3.stop(); prev_node.tween3.play()
	#create new log node
	else:
		if unnamed_container.get_child_count() >= MAX_LOGS:
			unnamed_container.get_child(0).fade_out()
		if get_tree():
			var new_node = logitem2_proto.instantiate()
			new_node.content_label.text = bbcode
			new_node.amount_panel.hide()
			new_node.get_node("ColorRect").color = Color(0.0, 0.75, 0.0, 0.5)
			await get_tree().process_frame
			unnamed_container.add_child(new_node)

	prev_log = bbcode
