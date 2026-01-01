extends TowerDefenceTowerUnit

var target_set: bool = false

var has_bat: bool = false
var has_large_bat: bool = false
var equiped_weapon: StringName = &"tail"

func _init() -> void:
	super._init(&"nitya")

func set_weapon_target(points_: PackedVector2Array) -> void:
	target_set = true
