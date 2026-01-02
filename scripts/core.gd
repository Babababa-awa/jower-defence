extends Retrograde

func _init() -> void:
	TILE_SIZE = 64
	PHYSICS_TILE_SIZE = 64
	FIELD_TILE_SIZE = 32

	ENABLE_MOUSE_CAPTURE = false
	MOUSE_CURSOR_SIZE = 32

	LOCALES = ["en"]
	START_LEVEL = &"level_1"
	MENU_LEVEL = &"menu"
	ENABLE_GAME_DIFFICULTY = true
	ENABLE_LEVEL_SELECT = true
	ENABLE_PLAY_AGAIN = true
	
	LEVEL_CAMERA_ZOOM = 0.8
	MENU_CAMERA_ZOOM = 0.8

enum WeaponModifier {
	NONE,
	SPEED,
	SPREAD,
	CLUSTER,
}

enum AttackModifier {
	NONE,
	SLOW,
	STUN,
	POISON,
}

enum DamageModifier {
	NONE,
	HEAVY,
	PIERCING,
	EXPLOSIVE
}

enum DamageEffect {
	NONE,
	WEAK,
	STRONG,
}
