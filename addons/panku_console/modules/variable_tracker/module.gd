class_name PankuModuleVariableTracker extends PankuModule

# The current scene root node, which will be updated automatically when the scene changes.
# current scene node was determined by node tree index at the beginning.
var _current_scene_root:Node
var _current_scene_index := 0
var _tween_loop:Tween


func init_module():
	_current_scene_index = core.get_tree().root.get_child_count() - 1
	await core.get_tree().process_frame
	setup_scene_root_tracker()
	setup_autoload_tracker()
	print_to_interactive_shell_window()

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
	var r := core.get_tree().root
	if r.get_child_count() > _current_scene_index:
		return r.get_child(_current_scene_index)
	else:
		return null

func setup_autoload_tracker():
	# read root children, the last child is considered as scene node while others are autoloads.
	var root:Node = core.get_tree().root
	for i in range(root.get_child_count() - 1):
		if root.get_child(i).name == core.SingletonName:
			# skip the plugin singleton
			continue
		# register user singletons
		var user_singleton:Node = root.get_child(i)
		core.gd_exprenv.register_env(user_singleton.name, user_singleton)

func print_to_interactive_shell_window():
	# print a tip to interacvite_shell module
	# modules load order matters
	var tip:String = "\n[tip] you can always access current scene by [b]current[/b]"
	if core.module_manager.has_module("interactive_shell"):
		var ishell = core.module_manager.get_module("interactive_shell")
		ishell.interactive_shell.output(tip)
