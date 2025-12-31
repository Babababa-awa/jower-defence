@tool
extends Sprite2D
class_name TowerSprite

@export var level: int = 0:
	set(val):
		if set_anim(val):
			level = val
@export var shooting: bool = false:
	set(val):
		shooting = val
		set_anim()

var json: Object
var frames: Array[float]

class Anim:
	var start: int
	var end: int
	signal finished #emited when looped or when cancelled
	func _init(start_: int, end_: int) -> void:
		self.start = start_
		self.end = end_

var idle_anims: Array[Anim]
var shoot_anims: Array[Anim]
var current_anim:Anim

func shoot_once() -> void:
	current_anim = shoot_anims[level]
	current_anim.finished.connect(set_anim, CONNECT_ONE_SHOT)
	
func set_anim(_level: int = level, _shooting: bool = shooting) -> bool:
	var a: Array[Anim] = shoot_anims if _shooting else idle_anims
	if not a or _level < 0 or a.size() <= _level:
		return false
	current_anim = a[_level]
	frame = current_anim.start
	accum=0.0
	return true

func on_texture_changed() -> void:
	idle_anims.clear()
	shoot_anims.clear()
	if not texture:
		current_anim = null
		return

	assert(texture.resource_path.ends_with(".png"))
	json = load(texture.resource_path.trim_suffix("png") + "json")
	hframes = json.data.frames.size()
	frames.resize(hframes)
	for fr: Dictionary in json.data.frames.values():
		var i:int = fr.frame.x / fr.sourceSize.w
		frames[i] = float(fr.duration) / 1000.0

	for tag: Dictionary in json.data.meta.frameTags:
		var a: Anim = Anim.new(tag.from, tag.to)
		var label: String = tag.name.to_lower()
		if label.begins_with("idle"):
			idle_anims.append(a)
		elif label.begins_with("shoot"):
			shoot_anims.append(a)
		else:
			print("warn: %s: Can't recognize tag name: " % self, label)
	if not set_anim():
		print("warn: %s: Failed to set animation")
		current_anim = null

func current_frame_duration() -> float:
	return frames[frame]

func _ready() -> void:
	texture_changed.connect(on_texture_changed)
	on_texture_changed()

var accum: float = 0.0
func _process(delta:float) -> void:
	if not current_anim:
		return
	accum += delta
	while accum > current_frame_duration():
		accum -= current_frame_duration()
		if frame < current_anim.end:
			frame += 1
		else:
			current_anim.finished.emit()
			frame = current_anim.start
