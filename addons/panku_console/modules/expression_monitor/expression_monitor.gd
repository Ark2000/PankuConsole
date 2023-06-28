extends Control
var _module:PankuModule

const _item_prefab:PackedScene = preload("./expression_item.tscn")

@export var _container:Control
@export var _trect:TextureRect
@export var _add_btn:Button

var _exprs := []
var _results := []
var _texture:ImageTexture

func update_results():
	for i in range(_exprs.size()):
		var expr:String = _exprs[i]
		if expr == "":
			continue
		var result = _module.core.gd_exprenv.execute(expr)["result"]
		if result is Texture2D:
			_texture = ImageTexture.create_from_image(result.get_image())
		_results[i] = str(result)

func update_ui():
	for i in range(_container.get_child_count() - 1):
		var child:Control = _container.get_child(i)
		child.set_result(_results[i])
	if _texture:
		_trect.set_texture(_texture)

func add_item_ui():
	var item = _item_prefab.instantiate()
	item.expr_changed.connect(
		func(new_expr:String):
			var idx = item.get_index()
			_exprs[idx] = new_expr
	)
	item.removing.connect(
		func():
			var idx = item.get_index()
			_exprs.remove_at(idx)
			_results.remove_at(idx)
	)
	_container.add_child(item)
	_add_btn.move_to_front()
	return item

func get_data():
	return _exprs

# called after _ready()
func set_data(exprs):
	_exprs = exprs
	_results = []
	for i in range(_exprs.size()):
		_results.append("")

func _ready():
	_add_btn.pressed.connect(
		func():
			add_item_ui()
			_exprs.append("")
			_results.append("")
	)
	for i in range(_container.get_child_count() - 1):
		var child:Control = _container.get_child(i)
		child.queue_free()
	if _exprs.size() > 0:
		for i in range(_exprs.size()):
			add_item_ui().set_expr(_exprs[i])

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 10 != 1:
		return
	if !is_visible_in_tree():
		return
	update_results()
	update_ui()
