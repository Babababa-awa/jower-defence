extends Node2D
class_name CommandButton

signal pressed()

@export var icon: StringName = &"money":
	set(value):
		icon = value
		if is_node_ready():
			_update()
			
@export var price: int = 0:
	set(value):
		price = value
		%UILabelPrice.text = str(value)
		if is_node_ready():
			_update()
			
@export var label: String:
	get():
		return %UILabelPrice.text
	set(value):
		%UILabelName.text = value
		if is_node_ready():
			_update()

func _ready() -> void:
	_update()

func _update() -> void:
	var offset_x: float = 32.0
	
	if icon == &"money":
		%AnimatedSprite2DIcon.play(&"money")
		%AnimatedSprite2DIcon.visible = true
	elif icon == &"check":
		%AnimatedSprite2DIcon.play(&"check")
		%AnimatedSprite2DIcon.visible = true
	else:
		%AnimatedSprite2DIcon.visible = false
		
	if icon != &"money":
		%UILabelPrice.visible = false
	else:
		%UILabelPrice.visible = true
		%UILabelPrice.position.x = offset_x
		%UILabelPrice.position.y = (48.0 - %UILabelPrice.size.y) / 2
		offset_x += %UILabelPrice.size.x + 4
	
	%UILabelName.position.x = offset_x
	%UILabelName.position.y = (48.0 - %UILabelName.size.y) / 2
	


func _on_area_2d_button_mouse_entered() -> void:
	%AnimatedSprite2DButton.play(&"hover")

func _on_area_2d_button_mouse_exited() -> void:
	%AnimatedSprite2DButton.play(&"default")

func _on_area_2d_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		pressed.emit()
