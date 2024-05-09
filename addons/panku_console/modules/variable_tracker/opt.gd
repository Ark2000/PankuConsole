extends ModuleOptions

@export_group("variable_tracker")

@export var export_comment_use_last_as_current = (
	"Use last non singleton node as current scene. "
	+ "First node will be used if this option disabled."
)
@export var use_last_as_current: bool:
	get:
		return _module._reverse_root_nodes_order
	set(value):
		use_last_as_current = value
		_module._reverse_root_nodes_order = value

@export var export_comment_root_node_exceptions = (
	"Top level nodes which will be ignored by variable tracker. "
	+ "Regular expressions can be used e.g. '(SignalBus|Game*)'."
)
@export var root_node_exceptions: String:
	get:
		return _module._raw_exceptions_string
	set(value):
		root_node_exceptions = value
		_module._raw_exceptions_string = value
		_module.update_exceptions_regexp()

@export var export_comment_tracking_delay = "Current scene checking interval."
@export_range(0.1, 2.0, 0.1) var tracking_delay := 0.5:
	set(v):
		tracking_delay = v
		_module.change_tracking_delay(tracking_delay)
