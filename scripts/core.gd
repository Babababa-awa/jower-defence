extends Retrograde

func _init() -> void:
	TILE_SIZE = 64
	PHYSICS_TILE_SIZE = 64
	FIELD_TILE_SIZE = 32

	ENABLE_MOUSE_CAPTURE = true
	MOUSE_CURSOR_SIZE = 32

	START_LEVEL = &"level_1"
	MENU_LEVEL = &"menu"
	ENABLE_GAME_DIFFICULTY = true
	ENABLE_LEVEL_SELECT = true
	ENABLE_PLAY_AGAIN = true

enum WeaponModifier {
	NONE,
	SPEED,
	SPREAD,
	CLUSTER,
}

enum ProjectileModifier {
	NONE,
	SPIRAL,
	WAVE,
	DAMAGE,
	PIERCING,
	EXPLOSIVE
}
