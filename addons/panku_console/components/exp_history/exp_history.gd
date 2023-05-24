extends Control

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

const exp_item_prefab = preload("res://addons/panku_console/components/exp_history/exp_history_item.tscn")

@export var item_container:VBoxContainer
@export var copy_button:Button
@export var monitor_button:Button
@export var favorite_button:Button
@export var delete_button:Button
@export var reverse_select_button:Button
@export var prev_page_button:Button
@export var next_page_button:Button
@export var first_page_button:Button
@export var last_page_button:Button
@export var page_ledit:LineEdit
@export var page_label:Label
@export var timer:Timer

var current_page := 1
var all_pages := 1
var items_per_page := 5
#[checked:bool, fav:bool, exp:String]
var item_data := []

func _ready():
	load_data()
	copy_button.pressed.connect(copy_selected)
	monitor_button.pressed.connect(monitor_selected)
	favorite_button.pressed.connect(star_selected)
	delete_button.pressed.connect(remove_selected)
	reverse_select_button.pressed.connect(invert_selected)
	prev_page_button.pressed.connect(
		func():
			current_page -= 1
			reload()
	)
	next_page_button.pressed.connect(
		func():
			current_page += 1
			reload()
	)
	first_page_button.pressed.connect(
		func():
			current_page = 1;
			reload()
	)
	last_page_button.pressed.connect(
		func():
			current_page = 99999999;
			reload()
	)
	page_ledit.text_submitted.connect(
		func(_new_text:String):
			current_page = page_ledit.text.to_int()
			reload()
	)
	page_ledit.focus_exited.connect(
		func():
			current_page = page_ledit.text.to_int()
			reload()
	)
	timer.timeout.connect(
		func():
			if item_container.get_child_count() < 1: return
			var item_height = item_container.get_child(0).size.y
			var item_gap = item_container.get("theme_override_constants/separation")
			var container_height = item_container.get_parent().size.y
			var _items_per_page = floor((container_height + item_gap) / (item_height + item_gap))
			_items_per_page = max(5, _items_per_page)
			if _items_per_page != items_per_page:
				items_per_page = _items_per_page
				reload()
	)
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()

	visibility_changed.connect(
		func():
			if is_visible_in_tree(): reload()
	)

func reload():
	#calculate pages
	all_pages = max(1, ceil(1.0 * item_data.size() / items_per_page))
	current_page = clamp(current_page, 1, all_pages)
	page_label.text = " / %d" % all_pages
	page_ledit.text = str(current_page)
	
	#remove existing list items
	var start_idx := (current_page - 1) * items_per_page
	var end_idx := min(start_idx + items_per_page, item_data.size())
	for c in item_container.get_children():
		c.queue_free()
	
	#add new list items
	for i in range(start_idx, end_idx):
		var list_item = exp_item_prefab.instantiate()
		list_item.checkbox.button_pressed = item_data[i][0]
		list_item.fav_icon.visible = item_data[i][1]
		list_item.line_edit.text = item_data[i][2]
		list_item.checkbox.toggled.connect(
			func(val:bool): item_data[i][0] = val
		)
		list_item.line_edit.text_changed.connect(
			func(val:String): item_data[i][2] = val
		)
		item_container.add_child(list_item)

func copy_selected():
	var result = combine_selected()
	if result != "":
		DisplayServer.clipboard_set(result)
		console.notify("Combined expression has beed added to clipboard!")
	clear_selected()

func monitor_selected():
	var result = combine_selected()
	if result != "":
		console.add_monitor_window(result, 0.1).centered()
	clear_selected()

func combine_selected() -> String:
	var selected_exp = []
	var combined_exp = ""
	for d in item_data:
		if !d[0]: continue
		selected_exp.append(d[2])
		if selected_exp.size() > 8:
			console.notify("Maximum 8 items!")
			return ""
	if selected_exp.size() == 0:
		console.notify("Nothing to copy!")
		return ""
	elif selected_exp.size() == 1:
		combined_exp = selected_exp[0]
	else:
		for i in range(selected_exp.size()):
			selected_exp[i] = "'%s: ' + str(%s)" % [selected_exp[i], selected_exp[i]]
		combined_exp = " + '\\n' + ".join(PackedStringArray(selected_exp))
	return combined_exp

func clear_selected():
	for d in item_data:
		d[0] = false
	reload()

func invert_selected():
	for d in item_data:
		d[0] = !d[0]
	reload()

func star_selected():
	var flag := true
	for d in item_data:
		if !d[0]: continue
		d[1] = !d[1]
		d[0] = false
		flag = false
	if flag:
		console.notify("No selected items!")
		return

	#sort favorite
	var fav_id := 0
	var fav_items := []
	var items := []
	for d in item_data:
		if d[1]: fav_items.append(d)
		else: items.append(d)
	item_data = fav_items + items
	reload()

func remove_selected():
	var result = []
	for d in item_data:
		if d[0]: continue
		result.append(d)
	if item_data.size() == result.size():
		console.notify("No selected items!")
		return
	console.notify("Removed %d items." % (item_data.size() - result.size()))
	item_data = result
	reload()

func load_data():
	#get saved data from cfg
	var cfg = console.Config.get_config()
	item_data = cfg.get(console.Utils.CFG_EXP_HISTORY, [])

func save_data():
	var cfg = console.Config.get_config()
	cfg[PankuConsole.Utils.CFG_EXP_HISTORY] = item_data
	console.Config.set_config(cfg)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()

func add_history(exp:String):
	#ignore consecutive same
	if item_data.size() > 0 and exp == item_data.back()[2]:
		return
	item_data.append([false, false, exp])
	if is_visible_in_tree(): reload()
