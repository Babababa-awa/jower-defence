extends BaseUnit
class_name TowerDefenceTowerUnit

var is_placing: bool = false
var is_tower_command: bool = false

var has_weapon_modifier_speed: bool = false
var has_weapon_modifier_spread: bool = false
var has_weapon_modifier_cluster: bool = false
var equiped_weapon_modifier: Core.WeaponModifier = Core.WeaponModifier.NONE:
	set(value):
		equiped_weapon_modifier = value
		if get_node_or_null("%Weapon") != null:
			%Weapon.weapon_modifier = value
		if get_node_or_null("%Weapon2") != null:
			%Weapon2.weapon_modifier = value

var has_attack_modifier_speed: bool = false
var has_attack_modifier_slow: bool = false
var has_attack_modifier_stun: bool = false
var has_attack_modifier_poison: bool = false
var equiped_attack_modifier: Core.AttackModifier = Core.AttackModifier.NONE:
	set(value):
		equiped_attack_modifier = value
		if get_node_or_null("%Weapon") != null:
			%Weapon.attack_modifier = value
		if get_node_or_null("%Weapon2") != null:
			%Weapon2.attack_modifier = value
			
var has_damage_modifier_heavy: bool = false
var has_damage_modifier_piercing: bool = false
var has_damage_modifier_explosive: bool = false
var equiped_damage_modifier: Core.DamageModifier = Core.DamageModifier.NONE:
	set(value):
		equiped_damage_modifier = value
		if get_node_or_null("%Weapon") != null:
			%Weapon.damage_modifier = value
		if get_node_or_null("%Weapon2") != null:
			%Weapon2.damage_modifier = value

func _init(alias_: StringName) -> void:
	super._init(alias_, Core.UnitType.FRIEND)
	
	alignment = Core.Alignment.CENTER_CENTER

func _ready() -> void:
	super._ready()
	
	var tower_area_: Area2D = get_node_or_null("%Area2DTower")
	if tower_area_ != null:
		tower_area_.mouse_entered.connect(_on_mouse_entered)
		tower_area_.mouse_exited.connect(_on_mouse_exited)
		tower_area_.input_event.connect(_on_input_event)
		
	
	if get_node_or_null("%TargetLine2D") != null:
		%TargetLine2D.target_complete.connect(_on_target_complete)
		%TargetLine2D.target_error.connect(_on_target_error)
	elif get_node_or_null("%TargetCone2D") != null:
		%TargetCone2D.target_complete.connect(_on_target_complete)
		%TargetCone2D.target_error.connect(_on_target_error)

	Core.game.tower_command_changed.connect(_on_tower_command_changed)
	
func _on_target_complete(points_: PackedVector2Array) -> void:
	set_weapon_target(points_)
	Core.game.clear_mouse_action(&"set_tower_target", true)

func _on_target_error(_reason_: StringName, _error_: Core.Error) -> void:
	Core.game.clear_mouse_action(&"set_tower_target", true)
	
func _on_tower_command_changed(tower_: TowerDefenceTowerUnit) -> void:
	if tower_ == self:
		is_tower_command = true
		%PlaceAnimation.play(&"select")
		%PlaceAnimation.visible = true
	else:
		is_tower_command = false
		%PlaceAnimation.visible = false

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		is_placing = false
		is_tower_command = false
		
		if get_node_or_null("%TargetLine2D") != null:
			%TargetLine2D.is_targeting = false
			
		if get_node_or_null("%Shadow") != null:
			%Shadow.visible = false

		has_weapon_modifier_speed = false
		has_weapon_modifier_spread = false
		has_weapon_modifier_cluster = false
		equiped_weapon_modifier = Core.WeaponModifier.NONE

		has_attack_modifier_speed = false
		has_attack_modifier_slow = false
		has_attack_modifier_stun = false
		has_attack_modifier_poison = false
		equiped_attack_modifier = Core.AttackModifier.NONE

		has_damage_modifier_heavy = false
		has_damage_modifier_piercing = false
		has_damage_modifier_explosive = false
		equiped_damage_modifier = Core.DamageModifier.NONE
	
func _on_mouse_entered() -> void:
	if not Core.game.is_tower_command_visible():
		%PlaceAnimation.play(&"select")
		%PlaceAnimation.visible = true

func _on_mouse_exited() -> void:
	if not is_tower_command:
		%PlaceAnimation.visible = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Core.game.has_mouse_action():
		return
		
	if (event is InputEventMouseButton and 
		event.pressed
	):
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if is_tower_command:
				Core.game.hide_tower_command()
			else:
				Core.game.show_tower_command(self)
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			Core.game.hide_tower_command()

func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
	
	if not is_running():
		return
		
	if is_placing:
		var position_: Vector2 = get_global_mouse_position() + (Vector2(Core.TILE_SIZE, Core.TILE_SIZE) / 2)
		var coords_: Vector2i = ((position_ / Core.TILE_SIZE).floor() * Core.TILE_SIZE)
		global_position = coords_
		
		if Core.level.can_place_tower_at_coords(coords_):
			%PlaceAnimation.play(&"success")
		else:
			%PlaceAnimation.play(&"error")
		
func start_place() -> void:
	is_placing = true
	%PlaceAnimation.visible = true
	%PlaceAnimation.play(&"error")

func stop_place() -> void:
	is_placing = false
	%PlaceAnimation.visible = false
	if get_node_or_null("%Shadow") != null:
		%Shadow.visible = true

func set_target() -> void:
	if not Core.game.can_mouse_action(&"set_tower_target"):
		return
	
	Core.game.hide_tower_command()
	Core.game.set_mouse_action(&"set_tower_target")
	
	if get_node_or_null("%TargetLine2D"):
		%TargetLine2D.is_targeting = true
	elif get_node_or_null("%TargetCone2D"):
		%TargetCone2D.is_targeting = true

func set_weapon_target(points_: PackedVector2Array) -> void:
	pass
	
func _update_weapon() -> void:
	pass
