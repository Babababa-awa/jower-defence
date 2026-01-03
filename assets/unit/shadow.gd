@tool
extends Sprite2D
class_name Shadow

@export_enum("Round", "Rough", "Snow") var shadow_type:int:
	set(i):
		shadow_type = i
		_setup()
		
var shadow_img: Texture = preload("res://assets/unit/unit-shadow.png")
func _setup() -> void:
	texture = shadow_img
	hframes = 3
	frame = shadow_type
	if shadow_type < 2:
		modulate.a = 0.8
		
	offset.y = 9
	z_index = -1

func _ready() -> void:
	_setup()
	
