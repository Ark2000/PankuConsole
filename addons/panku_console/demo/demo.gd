extends Node2D

#Properties with an underscore will be ignored by hint system.
@onready var _noise_texture:NoiseTexture2D = $CanvasLayer/TextureRect.texture
@onready var _noise:FastNoiseLite = _noise_texture.noise
@onready var _label:Label = $PanelContainer/Label
@onready var _color:ColorRect = $CanvasLayer/ColorRect

@export var title:String = "Simple Noise Terrain":
	set(v):
		title = v
		_label.text = v

@export var seed:int = 0:
	set(v):
		seed = v
		_noise.seed = v

@export var offset:Vector2 = Vector2():
	set(v):
		offset = v
		_noise.offset.x = v.x
		_noise.offset.y = v.y

@export_enum("Simplex", "Simplex Smooth", "Cellular", "Perlin", "Value Cubic", "Value") var noise_type:int = 0:
	set(v):
		noise_type = v
		_noise.noise_type = v

@export_range(0.001, 0.02, 0.0001) var frequency:float = 0.007:
	set(v):
		frequency = v
		_noise.frequency = v

@export var invert:bool = false:
	set(v):
		invert = v
		_noise_texture.invert = v
		
@export var tone:Color = Color.TRANSPARENT:
	set(v):
		tone = v
		_color.color = v

func _ready():
	#That's the way you add some stuff to the console plugin.
	Console.register_env("demo", self)
