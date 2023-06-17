class_name PankuModuleCheckLatestRelease extends PankuModule

signal check_lasted_release_requested()
signal check_lasted_release_responded(msg:Dictionary)

func send_request() -> Node:
	var node = preload("./network.gd").new()
	core.add_child(node)
	node.check_latest_release()
	node.response_received.connect(
		func(_v): node.queue_free()
	)
	return node

func check_update():
	send_request().response_received.connect(
		func(msg:Dictionary):
			check_lasted_release_responded.emit(msg)
	)

func check():
	send_request().response_received.connect(
		func(msg:Dictionary):
			if !msg["success"]:
				core.notify("[color=red][Error][/color] Failed! " + msg["msg"])
			else:
				core.notify("[color=green][info][/color] Latest: [%s] [url=%s]%s[/url]" % [msg["published_at"], msg["html_url"], msg["name"]])
	)

func init_module():
	# implement core functions
	check_lasted_release_requested.connect(check_update)
