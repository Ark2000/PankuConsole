extends Control

const CELL_SIZE = 12
const COLOR_EMPTY = Color(0.0, 0.0, 0.0, 0.0)
const COLOR_APPLE = Color8(255, 112, 133)
const COLOR_SNAKE = preload("./snake_gradient.tres")

@export var tex_rect:TextureRect

const KEY_SCHEME = {
	KEY_UP: Vector2.UP,
	KEY_DOWN: Vector2.DOWN,
	KEY_LEFT: Vector2.LEFT,
	KEY_RIGHT: Vector2.RIGHT,
}

var snake_game := preload("./snake.gd").new()
var cached_input := Vector2.RIGHT
var delay := 0.5
var img_buffer:Image

func _ready():
	img_buffer = Image.create(
		CELL_SIZE * snake_game.MAP_SIZE,
		CELL_SIZE * snake_game.MAP_SIZE, 
		false, Image.FORMAT_RGBA8)
	draw()

func draw():
	# draw background
	img_buffer.fill(COLOR_EMPTY)

	# draw snake
	var gradient = GradientTexture1D.new()
	for i in range(snake_game.snake_arr.size()):
		var s = snake_game.snake_arr[i]
		img_buffer.fill_rect(
			Rect2i(s * CELL_SIZE, Vector2.ONE * CELL_SIZE),
			COLOR_SNAKE.sample(1.0 * i / snake_game.snake_arr.size())
		)
	
	# draw apple
	img_buffer.fill_rect(
		Rect2i(snake_game.apple * CELL_SIZE, Vector2.ONE * CELL_SIZE),
		COLOR_APPLE
	)

	# update texture
	tex_rect.texture = ImageTexture.create_from_image(img_buffer)

func _input(event:InputEvent):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed:
			if KEY_SCHEME.has(key_event.keycode):
				cached_input = KEY_SCHEME[key_event.keycode]
				# if key is pressed, update immediately
				delay = 0.0

func _physics_process(delta):
	delay -= delta
	if delay <= 0.0:
		snake_game.tick(cached_input)
		draw()
		# speed up as snake grows
		delay = 2.0 / min(20, snake_game.get_snake_length() / 3.0 + 3)
