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

var godot_log: FileAccess
var godot_log_path: String


func _ready():
	if not _is_log_enabled():
		push_warning("You have to enable file logging in order to use engine log monitor!")
		return

	godot_log_path = ProjectSettings.get("debug/file_logging/log_path")
	if not FileAccess.file_exists(godot_log_path):
		push_warning("Log file not fount by path " + godot_log_path)
		return

	_start_watching()


func _start_watching() -> void:
	godot_log = FileAccess.open(godot_log_path, FileAccess.READ)
	create_tween().set_loops().tween_callback(_read_data).set_delay(UPDATE_INTERVAL)


func _is_log_enabled() -> bool:

	if ProjectSettings.get("debug/file_logging/enable_file_logging"):
		return true

	# this feels so weird and wrong
	# what about other platforms?
	if OS.has_feature("pc") and ProjectSettings.get("debug/file_logging/enable_file_logging.pc"):
		return true

	return false


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
