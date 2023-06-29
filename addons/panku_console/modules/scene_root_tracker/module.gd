class_name PankuModuleSceneRootTracker extends PankuModule

# The current scene root node, which will be updated automatically when the scene changes.
var _current_scene_root:Node
var _tween_loop:Tween

func init_module():
	setup_scene_root_tracker()

	# print a tip to interacvite_shell module
	# modules load order matters
	var tip:String = "\n[tip] you can always access current scene by [b]current[/b]"
	if core.module_manager.has_module("interactive_shell"):
		var ishell = core.module_manager.get_module("interactive_shell")
		ishell.interactive_shell.output(tip)

# always register the current scene root as `current`
func setup_scene_root_tracker():
	_current_scene_root = get_scene_root()
	core.gd_exprenv.register_env("current", _current_scene_root)
	_tween_loop = core.create_tween()
	_tween_loop.set_loops().tween_callback(
		func(): 
			var r = get_scene_root()
			if r != _current_scene_root:
				_current_scene_root = r
				core.gd_exprenv.register_env("current", _current_scene_root)
	).set_delay(0.1)

func get_scene_root() -> Node:
	return core.get_tree().root.get_child(core.get_tree().root.get_child_count() - 1)
