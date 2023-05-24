extends Control

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

const MAX_LOGS = 128

@export var tag_prefab:PackedScene
@export var search_box:LineEdit
@export var search_btn:Button
@export var pin_btn:Button
@export var cls_btn:Button
@export var tags_container2:ScrollContainer
@export var tags_container:HBoxContainer
@export var rlabel:RichTextLabel

var current_filter:String = ""
var logs:Array = []

#level: #1.info 2.warning 3.error
func add_log(message:String, level:int):
	#add prefix
	if level == 2:
		message = "[warning] " + message
	elif level == 3:
		message = "[error] " + message
	
	
	#update tags
	for tag in tags_container.get_children():
		tag.check(message)
	
	if logs.size() > 0:
		var last_log = logs.back()
		if (last_log["message"] == message) and (Time.get_unix_time_from_system() - last_log["timestamp"] < 1.0):
			last_log["count"] += 1
			last_log["timestamp"] = Time.get_unix_time_from_system()
			update_view()
			return

	logs.push_back({
		"message": message,
		"level": level,
		"timestamp": Time.get_unix_time_from_system(),
		"count": 1
	})
	
	#TODO: support more logs
	if logs.size() >= MAX_LOGS:
		logs = logs.slice(int(MAX_LOGS / 2))

	update_view()

func search(filter_string:String):
	current_filter = filter_string
	search_box.text = current_filter
	update_view()

func clear_all():
	logs.clear()
	update_view()

func add_tag(filter_string:String):
	if filter_string.trim_prefix(" ").trim_suffix(" ").is_empty():
		return
	var tag = tag_prefab.instantiate()
	tag.tag_btn.text = filter_string
	tag.tag_text = filter_string
	tag.tag_btn.pressed.connect(
		func():
			search(filter_string)
	)
	tag.rm_btn.pressed.connect(
		func():
			if tags_container.get_child_count() == 1:
				tags_container2.hide()
			tag.queue_free()
	)
	#special treatment
	if filter_string == "[warning]":
		tag.self_modulate = Color("#f5c518")
		tag.tag_btn.self_modulate = Color("#0a1014")
		tag.rm_btn.self_modulate = Color("#0a1014")
	elif filter_string == "[error]":
		tag.self_modulate = Color("#d91f11")
	
	tags_container.add_child(tag)
	tags_container2.show()

func update_view():
	#TODO: optimization
	var result:PackedStringArray = PackedStringArray()

	for log in logs:
		if !current_filter.is_empty() and !log["message"].contains(current_filter):
			continue
		var s = ""
		if log["level"] == 1:
			s = log["message"]
		elif log["level"] == 2:
			s = "[color=#e1ed96]%s[/color]" % log["message"]
		elif log["level"] == 3:
			s = "[color=#dd7085]%s[/color]" % log["message"]
		if log["count"] > 1:
			s = "[b](%d)[/b]%s" % [log["count"], s]
		result.append(s)

	var content:String = "\n".join(result)
	#sync content
	rlabel.text = content
	console.output_overlay.text = content

#the only persistent data here are tags.
func load_data():
	var cfg = PankuConsole.Config.get_config()
	var tags:PackedStringArray = cfg.get(PankuConsole.Utils.CFG_LOGGER_TAGS, PackedStringArray(["[warning]", "[error]"]))
	for item in tags:
		var text:String = item
		add_tag(text)

func save_data():
	var cfg = PankuConsole.Config.get_config()
	var tags := PackedStringArray()
	for tag in tags_container.get_children():
		tags.push_back(tag.tag_text)
	cfg[PankuConsole.Utils.CFG_LOGGER_TAGS] = tags
	PankuConsole.Config.set_config(cfg)

func _ready():
	#load tags
	load_data()
	
	#receive system logs
	console.godot_log_monitor.info_msg_received.connect(
		func(msg:String):
			add_log(msg, 1)
	)
	console.godot_log_monitor.warning_msg_received.connect(
		func(msg:String):
			add_log(msg, 2)
	)
	console.godot_log_monitor.error_msg_received.connect(
		func(msg:String):
			add_log(msg, 3)
	)

	#ui callbacks
	search_btn.pressed.connect(
		func():
			search(search_box.text)
	)
	search_box.text_submitted.connect(
		func(text:String):
			search(search_box.text)
	)
	pin_btn.pressed.connect(
		func():
			add_tag(search_box.text)
			search_box.clear()
	)
	cls_btn.pressed.connect(clear_all)

	clear_all()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()
