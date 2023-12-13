extends ModuleOptions

@export_group("variable_tracker")


@export var export_comment_tracking_delay = "Current scene checking interval."
@export_range(0.1, 2.0, 0.1) var tracking_delay := 0.5:
	set(v):
		tracking_delay = v
		_module.change_tracking_delay(tracking_delay)