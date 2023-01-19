extends Node
#Monitor built-in logs

signal error_msg_received(msg:String)
signal warning_msg_received(msg:String)
signal info_msg_received(msg:String)

const UPDATE_INTERVAL := 0.1
const ERROR_MSG_PREFIX := "USER ERROR: "
const WARNING_MSG_PREFIX := "USER WARNING: "
#Any logs with three spaces at the beginning will be ignored.
const IGNORE_PREFIX := "   " 

@export var timer:Timer

var godot_log:FileAccess

func _ready():
	var file_logging_enabled = ProjectSettings.get("debug/file_logging/enable_file_logging") or ProjectSettings.get("debug/file_logging/enable_file_logging.pc")
	if !file_logging_enabled:
		push_warning("You have to enable file logging in order to use engine log monitor!")
		return
	
	var log_path = ProjectSettings.get("debug/file_logging/log_path")
	godot_log = FileAccess.open(log_path, FileAccess.READ)

	timer.timeout.connect(_read_data)
	timer.wait_time = UPDATE_INTERVAL
	timer.one_shot = false
	timer.start()

func _read_data():
	while godot_log.get_position() < godot_log.get_length():
		var new_line = godot_log.get_line()
		if new_line.begins_with(IGNORE_PREFIX):
			continue
		if new_line.begins_with(ERROR_MSG_PREFIX):
			error_msg_received.emit(new_line.trim_prefix(ERROR_MSG_PREFIX))
		elif new_line.begins_with(WARNING_MSG_PREFIX):
			warning_msg_received.emit(new_line.trim_prefix(WARNING_MSG_PREFIX))
		else:
			info_msg_received.emit(new_line)
