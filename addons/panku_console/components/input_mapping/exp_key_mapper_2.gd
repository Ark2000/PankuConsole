extends Control

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

const exp_key_item := preload("res://addons/panku_console/components/input_mapping/exp_key_item.tscn")

@export var add_btn:Button
@export var container:VBoxContainer

var mapping_data = []

func _ready():
	load_data()

	#when clicking the button, add a new exp key mapping item
	add_btn.pressed.connect(
		func():
			var default_exp = ""
			var default_event = null
			add_item(default_exp, default_event)
			mapping_data.push_back([default_exp, default_event])
	)
	
#handle input here.
func _unhandled_input(e):
	if e is InputEventKey:
		for i in range(len(mapping_data)):
			var key_mapping = mapping_data[i]
			var exp:String = key_mapping[0]
			var event:InputEventKey = key_mapping[1]
			if !event: continue
			if e.keycode == event.keycode and e.pressed and !e.echo:
				#execute the exp
				var result = console.execute(exp)
				if result.failed:
					console.notify("[color=red]%s[/color]" % result.result)
				else:
					#ignore null result
					if result.result:
						console.notify(str(result.result))

func _notification(what):
	#save data on quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()

func add_item(exp:String, event:InputEventKey):
	var item = exp_key_item.instantiate()
	container.add_child(item)
	container.move_child(item, container.get_child_count() - 2)
	item.exp_edit.text = exp
	item.remap_button.key_event = event
	
	item.exp_edit_submitted.connect(
		func(new_exp:String):
			mapping_data[item.get_index()][0] = new_exp
	)
	item.remap_button.key_event_changed.connect(
		func(new_event:InputEventKey):
			mapping_data[item.get_index()][1] = new_event
	)
	item.tree_exiting.connect(
		func():
			mapping_data.remove_at(item.get_index())
	)

func load_data():
	#get saved data from cfg
	var cfg = console.Config.get_config()
	mapping_data = cfg.get(PankuConsole.Utils.CFG_EXP_MAPPING_DATA, [])
	
	#load data
	for i in range(len(mapping_data)):
		var key_mapping = mapping_data[i]
		var exp:String = key_mapping[0]
		var event:InputEventKey = key_mapping[1]
		add_item(exp, event)

func save_data():
	var cfg = console.Config.get_config()
	cfg[PankuConsole.Utils.CFG_EXP_MAPPING_DATA] = mapping_data
	console.Config.set_config(cfg)
