extends Node
class_name VFX

class Subframes:
	var start: int
	var end: int
	var rate: int
	var label: StringName
	func _init(start, end, rate, label):
		self.start = start
		self.end = end
		self.rate = rate
		self.label = label

static var pool: Pool = Pool.new(preload("res://vfx/v_effect.tscn"),16)
static var json:Object = preload("res://vfx/vfx.json")
static var effects: Dictionary
static func gen_effects_table() -> Dictionary:
	var _effects:Dictionary

	var r = RegEx.new()
	r.compile("[^0-9]+")
	for tag in json.data.meta.frameTags:
		var k = r.search(tag.name).get_string()
		var v = Subframes.new(
			int(tag.from),
			int(tag.to),
			tag.data if tag.has("data") else 20,
			tag.name
		)
		if k != tag.name: # contains numbers and is therefore part of a group
			if _effects.has(k):
				assert(_effects[k] is Array)
				_effects[k].append(v)
			else:
				_effects[k] = [v]
		else:
			_effects[tag.name] = v
	return _effects

static func acquire(at:Node2D, offset: Vector2=Vector2.ZERO) -> VFXSprite:
	var vs: VFXSprite = pool.next(at)
	assert(vs)
	assert(at and is_instance_valid(at))
	Core.game.add_level_child(vs)
	vs.global_position = at.global_position + offset
	return vs

static func get_animation(id: StringName) -> Subframes:
	if not effects:
		effects = gen_effects_table()
	var anim:Variant = effects[id]
	if anim is Array:
		anim = anim.pick_random()
	return anim

static func play(id: StringName, at:Node2D, offset: Vector2=Vector2.ZERO) -> VFXSprite:
	var vs:VFXSprite = acquire(at, offset)
	vs.play(get_animation(id))
	return vs


func play_looping(id: StringName, at:Node2D, offset: Vector2=Vector2.ZERO) -> VFXSprite:
	var vs:VFXSprite = acquire(at, offset)
	vs.play(get_animation(id), -1)
	return vs
