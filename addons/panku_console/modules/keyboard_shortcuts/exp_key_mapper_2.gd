extends Control

signal key_binding_added(key: InputEventKey, expression: String)
signal key_binding_changed(key: InputEventKey, expression: String)

var console:PankuConsole

const exp_key_item := preload("./exp_key_item.tscn")

@export var add_btn:Button
@export var container:VBoxContainer

var mapping_data = []

func _ready():
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
				var result = console.gd_exprenv.execute(exp)
				if result.failed:
					console.notify("[color=red]%s[/color]" % result.result)
				else:
					#ignore null result
					if result.result:
						console.notify(str(result.result))

func add_item(exp:String, event:InputEventKey):
	var item = exp_key_item.instantiate()
	container.add_child(item)
	container.move_child(item, container.get_child_count() - 2)
	item.exp_edit.text = exp
	item.remap_button.key_event = event
	
	item.exp_edit_submitted.connect(
		func(new_exp:String):
			mapping_data[item.get_index()][0] = new_exp
			if(key_binding_added.get_connections().size() > 0):
				key_binding_added.emit(event, new_exp)
	)
	item.remap_button.key_event_changed.connect(
		func(new_event:InputEventKey):
			mapping_data[item.get_index()][1] = new_event
			if(key_binding_changed.get_connections().size() > 0):
				key_binding_changed.emit(new_event, mapping_data[item.get_index()][0])
	)
	item.tree_exiting.connect(
		func():
			mapping_data.remove_at(item.get_index())
	)

func get_data() -> Array:
	return mapping_data

func load_data(data:Array):
	mapping_data = data

	#load data
	for i in range(len(mapping_data)):
		var key_mapping = mapping_data[i]
		var exp:String = key_mapping[0]
		var event:InputEventKey = key_mapping[1]
		add_item(exp, event)
