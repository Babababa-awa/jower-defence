extends BaseNode2D

var tower: TowerDefenceTowerUnit = null:
	set(value):
		tower = value
		_update()
		
func _ready() -> void:
	super._ready()
	
	%GunUpgrades.closed.connect(_close_command_box)
	%LaserUpgrades.closed.connect(_close_command_box)
	%WeaponModifiers.closed.connect(_close_command_box)
	%ProjectileModifiers.closed.connect(_close_command_box)
	%DamageModifiers.closed.connect(_close_command_box)
		
func _update() -> void:
	%Menu.show()
	%GunUpgrades.hide()
	%LaserUpgrades.hide()
	%WeaponModifiers.hide()
	%ProjectileModifiers.hide()
	%DamageModifiers.hide()

func _close_command_box(command_box_: CommandBox) -> void:
	_update()

func _on_area_2d_upgrade_mouse_entered() -> void:
	Core.game.set_mouse_action(&"button_hover")
	%AnimatedSprite2DUpgrade.play(&"hover")

func _on_area_2d_upgrade_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"button_hover", true)
	%AnimatedSprite2DUpgrade.play(&"default")

func _on_area_2d_weapon_modifier_mouse_entered() -> void:
	Core.game.set_mouse_action(&"button_hover")
	%AnimatedSprite2DWeaponModifier.play(&"hover")

func _on_area_2d_weapon_modifier_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"button_hover", true)
	%AnimatedSprite2DWeaponModifier.play(&"default")

func _on_area_2d_projectile_modifier_mouse_entered() -> void:
	Core.game.set_mouse_action(&"button_hover")
	%AnimatedSprite2DProjectileModifier.play(&"hover")

func _on_area_2d_projectile_modifier_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"button_hover", true)
	%AnimatedSprite2DProjectileModifier.play(&"default")

func _on_area_2d_target_mouse_entered() -> void:
	Core.game.set_mouse_action(&"button_hover")
	%AnimatedSprite2DTarget.play(&"hover")

func _on_area_2d_target_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"button_hover", true)
	%AnimatedSprite2DTarget.play(&"default")

func _on_area_2d_damage_modifier_mouse_entered() -> void:
	Core.game.set_mouse_action(&"button_hover")
	%AnimatedSprite2DDamageModifier.play(&"hover")
	
func _on_area_2d_damage_modifier_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"button_hover", true)
	%AnimatedSprite2DDamageModifier.play(&"default")

func _on_area_2d_upgrade_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if tower == null:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.game.clear_mouse_action(&"button_hover", true)
		
		%Menu.hide()
		
		if tower.alias == &"pippa":
			_show_gun_upgrades()
		elif tower.alias == &"jelly":
			_show_laser_upgrades()

func _show_gun_upgrades() -> void:
	if tower.equiped_weapon == &"pistol":
		%TowerCommandButtonPistol.icon = &"check"
	else:
		%TowerCommandButtonPistol.icon = &""
	
	if tower.equiped_weapon == &"semi_automatic":
		%TowerCommandButtonSemiAutomatic.icon = &"check"
	elif not tower.has_semi_automatic:
		%TowerCommandButtonSemiAutomatic.icon = &"money"
	else:
		%TowerCommandButtonSemiAutomatic.icon = &""
	
	if tower.equiped_weapon == &"machine_gun":
		%TowerCommandButtonMachineGun.icon = &"check"
	elif not tower.has_machine_gun:
		%TowerCommandButtonMachineGun.icon = &"money"
	else:
		%TowerCommandButtonMachineGun.icon = &""
	
	if tower.has_semi_automatic:
		%TowerCommandButtonMachineGun.show()
	else:
		%TowerCommandButtonMachineGun.hide()
	
	if %GunUpgrades.visible:
		%GunUpgrades.refresh()
	else:
		%GunUpgrades.show()
		
func _show_laser_upgrades() -> void:
	if tower.equiped_weapon == &"laser_shot":
		%TowerCommandButtonLaserShot.icon = &"check"
	else:
		%TowerCommandButtonLaserShot.icon = &""
	
	if tower.equiped_weapon == &"laser_beam":
		%TowerCommandButtonLaserBeam.icon = &"check"
	elif not tower.has_laser_beam:
		%TowerCommandButtonLaserBeam.icon = &"money"
	else:
		%TowerCommandButtonLaserBeam.icon = &""
	
	if tower.equiped_weapon == &"jorb":
		%TowerCommandButtonJorb.icon = &"check"
	elif not tower.has_jorb:
		%TowerCommandButtonJorb.icon = &"money"
	else:
		%TowerCommandButtonJorb.icon = &""
	
	if tower.has_laser_beam:
		%TowerCommandButtonJorb.show()
	else:
		%TowerCommandButtonJorb.hide()
	
	if %LaserUpgrades.visible:
		%LaserUpgrades.refresh()
	else:
		%LaserUpgrades.show()

func _on_area_2d_weapon_modifier_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if tower == null:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.game.clear_mouse_action(&"button_hover", true)
		
		%Menu.hide()
		
		_show_weapon_modifiers()
		
func _show_weapon_modifiers() -> void:
	if tower.equiped_weapon_modifier == Core.WeaponModifier.SPEED:
		%TowerCommandButtonWeaponSpeed.icon = &"check"
	elif not tower.has_weapon_modifier_speed:
		%TowerCommandButtonWeaponSpeed.icon = &"money"
	else:
		%TowerCommandButtonWeaponSpeed.icon = &""
	
	if tower.equiped_weapon_modifier == Core.WeaponModifier.SPREAD:
		%TowerCommandButtonWeaponSpread.icon = &"check"
	elif not tower.has_weapon_modifier_spread:
		%TowerCommandButtonWeaponSpread.icon = &"money"
	else:
		%TowerCommandButtonWeaponSpread.icon = &""
	
	if tower.equiped_weapon_modifier == Core.WeaponModifier.CLUSTER:
		%TowerCommandButtonWeaponCluster.icon = &"check"
	elif not tower.has_weapon_modifier_cluster:
		%TowerCommandButtonWeaponCluster.icon = &"money"
	else:
		%TowerCommandButtonWeaponCluster.icon = &""
	
	if %WeaponModifiers.visible:
		%WeaponModifiers.refresh()
	else:
		%WeaponModifiers.show()

func _on_area_2d_projectile_modifier_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if tower == null:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.game.clear_mouse_action(&"button_hover", true)
		
		%Menu.hide()
		
		_show_projectile_modifiers()

func _show_projectile_modifiers() -> void:
	if tower.equiped_projectile_modifier == Core.ProjectileModifier.SPEED:
		%TowerCommandButtonProjectileSpeed.icon = &"check"
	elif not tower.has_projectile_modifier_speed:
		%TowerCommandButtonProjectileSpeed.icon = &"money"
	else:
		%TowerCommandButtonProjectileSpeed.icon = &""
	
	if tower.equiped_projectile_modifier == Core.ProjectileModifier.WAVE:
		%TowerCommandButtonProjectileWave.icon = &"check"
	elif not tower.has_projectile_modifier_wave:
		%TowerCommandButtonProjectileWave.icon = &"money"
	else:
		%TowerCommandButtonProjectileWave.icon = &""
	
	if tower.equiped_projectile_modifier == Core.ProjectileModifier.SPIRAL:
		%TowerCommandButtonProjectileSpiral.icon = &"check"
	elif not tower.has_projectile_modifier_spiral:
		%TowerCommandButtonProjectileSpiral.icon = &"money"
	else:
		%TowerCommandButtonProjectileSpiral.icon = &""
	
	if %ProjectileModifiers.visible:
		%ProjectileModifiers.refresh()
	else:
		%ProjectileModifiers.show()

func _on_area_2d_damage_modifier_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if tower == null:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.game.clear_mouse_action(&"button_hover", true)
		
		%Menu.hide()
		
		_show_damage_modifiers()

func _show_damage_modifiers() -> void:
	if tower.equiped_damage_modifier == Core.DamageModifier.HEAVY:
		%TowerCommandButtonDamageHeavy.icon = &"check"
	elif not tower.has_damage_modifier_heavy:
		%TowerCommandButtonDamageHeavy.icon = &"money"
	else:
		%TowerCommandButtonDamageHeavy.icon = &""
	
	if tower.equiped_damage_modifier == Core.DamageModifier.PIERCING:
		%TowerCommandButtonDamagePiercing.icon = &"check"
	elif not tower.has_damage_modifier_piercing:
		%TowerCommandButtonDamagePiercing.icon = &"money"
	else:
		%TowerCommandButtonDamagePiercing.icon = &""
	
	if tower.equiped_damage_modifier == Core.DamageModifier.EXPLOSIVE:
		%TowerCommandButtonDamageExplosive.icon = &"check"
	elif not tower.has_damage_modifier_explosive:
		%TowerCommandButtonDamageExplosive.icon = &"money"
	else:
		%TowerCommandButtonDamageExplosive.icon = &""
	
	if %DamageModifiers.visible:
		%DamageModifiers.refresh()
	else:
		%DamageModifiers.show()
		
func _on_area_2d_target_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if tower == null:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.game.clear_mouse_action(&"button_hover", true)
		tower.set_target()

func _on_tower_command_button_pistol_pressed() -> void:
	if tower == null:
		return

	if tower.equiped_weapon == &"pistol":
		%GunUpgrades.hide()
		%Menu.show()
	else:
		tower.equiped_weapon = &"pistol"
		_show_gun_upgrades() # Rrefresh

func _on_tower_command_button_semi_automatic_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_semi_automatic:
		if tower.equiped_weapon == &"semi_automatic":
			%GunUpgrades.hide()
			%Menu.show()
		else:
			tower.equiped_weapon = &"semi_automatic"
			_show_gun_upgrades() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonSemiAutomatic.price:
		tower.has_semi_automatic = true
		Core.level.remove_money(%TowerCommandButtonSemiAutomatic.price)
		_show_gun_upgrades() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_machine_gun_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_machine_gun:
		if tower.equiped_weapon == &"machine_gun":
			%GunUpgrades.hide()
			%Menu.show()
		else:
			tower.equiped_weapon = &"machine_gun"
			_show_gun_upgrades() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonMachineGun.price:
		tower.has_machine_gun = true
		Core.level.remove_money(%TowerCommandButtonMachineGun.price)
		_show_gun_upgrades() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_laser_pressed() -> void:
	if tower == null:
		return

	if tower.equiped_weapon == &"laser_shot":
		%LaserUpgrades.hide()
		%Menu.show()
	else:
		tower.equiped_weapon = &"laser_shot"
		_show_laser_upgrades() # Rrefresh

func _on_tower_command_button_beam_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_laser_beam:
		if tower.equiped_weapon == &"laser_beam":
			%LaserUpgrades.hide()
			%Menu.show()
		else:
			tower.equiped_weapon = &"laser_beam"
			_show_laser_upgrades() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonLaserBeam.price:
		tower.has_laser_beam = true
		Core.level.remove_money(%TowerCommandButtonLaserBeam.price)
		_show_laser_upgrades() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_jorb_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_jorb:
		if tower.equiped_weapon == &"jorb":
			%LaserUpgrades.hide()
			%Menu.show()
		else:
			tower.equiped_weapon = &"jorb"
			_show_laser_upgrades() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonJorb.price:
		tower.has_jorb = true
		Core.level.remove_money(%TowerCommandButtonJorb.price)
		_show_laser_upgrades() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_weapon_speed_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_weapon_modifier_speed:
		if tower.equiped_weapon_modifier == Core.WeaponModifier.SPEED:
			%WeaponModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_weapon_modifier = Core.WeaponModifier.SPEED
			_show_weapon_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonWeaponSpeed.price:
		tower.has_weapon_modifier_speed = true
		Core.level.remove_money(%TowerCommandButtonWeaponSpeed.price)
		_show_weapon_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_weapon_spread_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_weapon_modifier_spread:
		if tower.equiped_weapon_modifier == Core.WeaponModifier.SPREAD:
			%WeaponModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_weapon_modifier = Core.WeaponModifier.SPREAD
			_show_weapon_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonWeaponSpread.price:
		tower.has_weapon_modifier_spread = true
		Core.level.remove_money(%TowerCommandButtonWeaponSpread.price)
		_show_weapon_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_weapon_cluster_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_weapon_modifier_cluster:
		if tower.equiped_weapon_modifier == Core.WeaponModifier.CLUSTER:
			%WeaponModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_weapon_modifier = Core.WeaponModifier.CLUSTER
			_show_weapon_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonWeaponCluster.price:
		tower.has_weapon_modifier_cluster = true
		Core.level.remove_money(%TowerCommandButtonWeaponCluster.price)
		_show_weapon_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_projectile_speed_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_projectile_modifier_speed:
		if tower.equiped_projectile_modifier == Core.ProjectileModifier.SPEED:
			%ProjectileModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_projectile_modifier = Core.ProjectileModifier.SPEED
			_show_projectile_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonProjectileSpeed.price:
		tower.has_projectile_modifier_speed = true
		Core.level.remove_money(%TowerCommandButtonProjectileSpeed.price)
		_show_projectile_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_projectile_wave_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_projectile_modifier_wave:
		if tower.equiped_projectile_modifier == Core.ProjectileModifier.WAVE:
			%ProjectileModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_projectile_modifier = Core.ProjectileModifier.WAVE
			_show_projectile_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonProjectileWave.price:
		tower.has_projectile_modifier_wave = true
		Core.level.remove_money(%TowerCommandButtonProjectileWave.price)
		_show_projectile_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_projectile_spiral_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_projectile_modifier_spiral:
		if tower.equiped_projectile_modifier == Core.ProjectileModifier.SPIRAL:
			%ProjectileModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_projectile_modifier = Core.ProjectileModifier.SPIRAL
			_show_projectile_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonProjectileSpiral.price:
		tower.has_projectile_modifier_spiral = true
		Core.level.remove_money(%TowerCommandButtonProjectileSpiral.price)
		_show_projectile_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_damage_heavy_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_damage_modifier_heavy:
		if tower.equiped_damage_modifier == Core.DamageModifier.HEAVY:
			%DamageModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_damage_modifier = Core.DamageModifier.HEAVY
			_show_damage_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonDamageHeavy.price:
		tower.has_damage_modifier_heavy = true
		Core.level.remove_money(%TowerCommandButtonDamageHeavy.price)
		_show_damage_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_damage_piercing_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_damage_modifier_piercing:
		if tower.equiped_damage_modifier == Core.DamageModifier.PIERCING:
			%DamageModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_damage_modifier = Core.DamageModifier.PIERCING
			_show_damage_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonDamagePiercing.price:
		tower.has_damage_modifier_piercing = true
		Core.level.remove_money(%TowerCommandButtonDamagePiercing.price)
		_show_damage_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass

func _on_tower_command_button_damage_explosive_pressed() -> void:
	if tower == null:
		return
		
	if tower.has_damage_modifier_explosive:
		if tower.equiped_damage_modifier == Core.DamageModifier.EXPLOSIVE:
			%DamageModifiers.hide()
			%Menu.show()
		else:
			tower.equiped_damage_modifier = Core.DamageModifier.EXPLOSIVE
			_show_damage_modifiers() # Rrefresh
	elif Core.level.current_money >= %TowerCommandButtonDamageExplosive.price:
		tower.has_damage_modifier_explosive = true
		Core.level.remove_money(%TowerCommandButtonDamageExplosive.price)
		_show_damage_modifiers() # Rrefresh
	else:
		# TODO: Play failure sfx
		pass
