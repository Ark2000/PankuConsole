class_name PankuModuleVariableTracker extends PankuModule
## Module to register and update some common environments.
##
## On module startup current scene root node registered as 'current' environment var,
## for more convenient access from interactive shell. Module constantly monitoring node
## tree afterwards and auto rebind 'current' environment in case of current scene changed.
## Also all user autoload singletons registered with its root node names.

const PROJECT_AUTOLOAD_PREFIX := "autoload/"
const CURRENT_SCENE_ENV := "current"
const SHELL_MODULE_NAME := "interactive_shell"
const DEFAULT_TRACKING_DELAY := 0.5

const CURRENT_REGISTERED_TIP := "[tip] Node '%s' registered as current scene, you can access it by [b]%s[/b]."
const CURRENT_REMOVED_TIP := "[tip] No current scene found, [b]%s[/b] keyword is no longer available."
const USER_AUTOLOADS_TIP := "[tip] Accessible user singleton modules: [b]%s[/b]"

var _raw_exceptions_string: String = ""
var _nodes_exception_regexp: RegEx

var _reverse_root_nodes_order: bool
var _current_scene_root:Node
var _user_singleton_files := []
var _tween_loop:Tween
var _loop_call_back:CallbackTweener


func init_module():
	get_module_opt().tracking_delay = load_module_data("tracking_delay", DEFAULT_TRACKING_DELAY)
	_reverse_root_nodes_order = load_module_data("use_last_as_current", true)
	_raw_exceptions_string = load_module_data("root_node_exceptions", _raw_exceptions_string)

	await core.get_tree().process_frame # not sure if it is necessary

	update_exceptions_regexp()
	_update_project_singleton_files()
	_setup_scene_root_tracker()
	_check_autoloads()


# Build root node exceptions regular expression
func update_exceptions_regexp() -> void:
	if _raw_exceptions_string.is_empty():
		_nodes_exception_regexp = RegEx.new() # not valid expression
		return

	_nodes_exception_regexp = RegEx.create_from_string(_raw_exceptions_string)

	if not _nodes_exception_regexp.is_valid():
		push_error("Can't parse '%s' expression for variable tracker" % _raw_exceptions_string)


# Parse project setting and collect and autoload files.
func _update_project_singleton_files() -> void:
	_user_singleton_files.clear()
	for property in ProjectSettings.get_property_list():
		if property.name.begins_with(PROJECT_AUTOLOAD_PREFIX):
			_user_singleton_files.append(ProjectSettings.get_setting(property.name).trim_prefix("*"))


# Check if given node is autoload singleton.
func _is_singleton(node: Node) -> bool:
	# Comparing scene file and script file with list of autoload files
	# from project settings. I'm not sure that approach hundred percent perfect,
	# but it works so far.
	if node.scene_file_path in _user_singleton_files:
		return true

	var script = node.get_script()
	if script and (script.get_path() in _user_singleton_files):
		return true

	return false


# Setup monitoring loop for current scene root node.
func _setup_scene_root_tracker() -> void:
	_check_current_scene()
	# The whole idea looping something in the background
	# while dev console is not even opened does not feel so right.
	# Have no idea how to make it more elegant way,
	# so lets make loop interval user controllable at least.
	var tracking_delay = get_module_opt().tracking_delay

	_tween_loop = core.create_tween()
	_loop_call_back = _tween_loop.set_loops().tween_callback(_check_current_scene).set_delay(tracking_delay)


## Set current scene root node monitoring interval.
func change_tracking_delay(delay: float) -> void:
	if _loop_call_back:
		_loop_call_back.set_delay(delay)


# Update current scene root node environment.
func _check_current_scene() -> void:
	var scene_root_found: Node = get_scene_root()

	if scene_root_found:
		if scene_root_found != _current_scene_root:
			core.gd_exprenv.register_env(CURRENT_SCENE_ENV, scene_root_found)
			_print_to_interactive_shell(CURRENT_REGISTERED_TIP % [scene_root_found.name, CURRENT_SCENE_ENV])

	else:
		if _current_scene_root:
			core.gd_exprenv.remove_env(CURRENT_SCENE_ENV)
			_print_to_interactive_shell(CURRENT_REMOVED_TIP % CURRENT_SCENE_ENV)

	_current_scene_root = scene_root_found


## Find the root node of current active scene.
func get_scene_root() -> Node:
	# Assuming current scene is the first node in tree that is not autoload singleton.
	for node in _get_valid_root_nodes():
		if not _is_singleton(node):
			return node

	return null


# Get list of tree root nodes filtered and sorted according module settings
func _get_valid_root_nodes() -> Array:
	var nodes: Array = core.get_tree().root.get_children().filter(_root_nodes_filter)

	if _reverse_root_nodes_order:
		nodes.reverse()

	return nodes


# Filter function for tree root nodes
func _root_nodes_filter(node: Node) -> bool:
	# skip panku plugin itself
	if node.name == core.SingletonName:
		return false

	# skip user defined exceptions
	if _nodes_exception_regexp.is_valid() and _nodes_exception_regexp.search(node.name):
		return false

	return true


# Find all autoload singletons and bind its to environment vars.
func _check_autoloads() -> void:
	var _user_singleton_names := []

	for node in _get_valid_root_nodes():
		if _is_singleton(node):
			# register user singleton
			_user_singleton_names.append(node.name)
			core.gd_exprenv.register_env(node.name, node)

	if not _user_singleton_names.is_empty():
		_print_to_interactive_shell(USER_AUTOLOADS_TIP % ",".join(_user_singleton_names))


# Print a tip to interactive shell module, modules load order does matter.
func _print_to_interactive_shell(message: String) -> void:
	if core.module_manager.has_module(SHELL_MODULE_NAME):
		var ishell = core.module_manager.get_module(SHELL_MODULE_NAME)
		ishell.interactive_shell.output(message)


func quit_module():
	_tween_loop.kill()
	super.quit_module()
