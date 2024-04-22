extends ModuleOptions

@export_group("variable_tracker")

@export var export_comment_use_last_as_current = (
	"Use last non singleton node as current scene. "
	+ "First node will be used if this option disabled."
)

@export var use_last_as_current: bool:
	get:
		return _module._reverse_root_nodes_order
	set(v):
		use_last_as_current = v
		_module._reverse_root_nodes_order = v

@export var export_comment_tracking_delay = "Current scene checking interval."
@export_range(0.1, 2.0, 0.1) var tracking_delay := 0.5:
	set(v):
		tracking_delay = v
		_module.change_tracking_delay(tracking_delay)
