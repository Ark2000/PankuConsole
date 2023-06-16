class_name PankuModuleCheckLatestRelease extends PankuModule
func get_module_name(): return "CheckLatestRelease"

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

func init_module():

	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.gd_exprenv.register_env("check_latest_release", env)

	# implement core functions
	check_lasted_release_requested.connect(check_update)
