signal game_over

const MAP_SIZE = 24

const DIR_REV = {
	Vector2.LEFT: Vector2.RIGHT,
	Vector2.RIGHT: Vector2.LEFT,
	Vector2.UP: Vector2.DOWN,
	Vector2.DOWN: Vector2.UP,
}

var snake_dict:Dictionary
var snake_arr:Array
var apple:Vector2
var move_dir:Vector2

func _init() -> void:
	init()

func init() -> void:
	
	# init snake. 0:head, -1:tail
	snake_dict = {Vector2(9, 8):0, Vector2(8, 8):0}
	snake_arr = snake_dict.keys()
	
	# init apple
	apple = spawn_apple()
	
	move_dir = Vector2.RIGHT

func get_snake_length() -> int:
	return snake_arr.size()

func spawn_apple() -> Vector2:
	var x_range = range(MAP_SIZE)
	x_range.shuffle()
	var y_range = range(MAP_SIZE)
	y_range.shuffle()
	for y in y_range:
		for x in x_range:
			if !snake_dict.has(Vector2(x, y)):
				return Vector2(x, y)
	return Vector2(-1, -1)

func tick(input_dir:Vector2):
	
	# can't turn back
	if DIR_REV[input_dir] != move_dir:
			move_dir = input_dir

	# create new head
	var new_head:Vector2 = snake_arr[0] + move_dir
	new_head.x = wrapi(new_head.x, 0, MAP_SIZE)
	new_head.y = wrapi(new_head.y, 0, MAP_SIZE)
	
	# check if collide with self
	if snake_dict.has(new_head):
		# game over, restart
		game_over.emit()
		init()
		return

	# add new head
	snake_arr.push_front(new_head)
	snake_dict[new_head] = 0
	
	# remove tail if no apple
	if new_head != apple:
		snake_dict.erase(snake_arr.pop_back())
	else:
		apple = spawn_apple()
