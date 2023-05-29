extends CanvasLayer

const logitem2_proto := preload("./log_item.tscn")

const MAX_LOGS = 10

var prev_log = ""

@export var area_indicator:Control
@export var container:VBoxContainer

func _ready():
	area_indicator.queue_free()

func add_log(bbcode:String, line_color:=Color(0.0, 0.75, 0.0)):
	#see the new log if can be combined with previous one
	if prev_log == bbcode and container.get_child_count() > 0:
		var prev_node = container.get_child(container.get_child_count() - 1)
		prev_node.amount += 1
		prev_node.amount_label.text = "x" + str(prev_node.amount)
		prev_node.amount_panel.show()
		prev_node.tween3.stop(); prev_node.tween3.play()
	#create new log node
	else:
		if container.get_child_count() >= MAX_LOGS:
			container.get_child(0).fade_out()
		if get_tree():
			var new_node = logitem2_proto.instantiate()
			new_node.content_label.text = bbcode
			new_node.amount_panel.hide()
			new_node.get_node("ColorRect").color = line_color
			await get_tree().process_frame
			container.add_child(new_node)

	prev_log = bbcode
