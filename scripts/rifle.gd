extends Gun

@export var bullet_spread: float

func fire():
	animation.play("shoot")
	can_shoot = false
	timer.start()
	muzzle_position_global = muzzle.global_position
	var bullet_direction_mod = GM.roll_float(-bullet_spread, bullet_spread)
	var direction = ((muzzle_position_global - global_position)+Vector2(bullet_direction_mod/10,bullet_direction_mod/10)).normalized()
	var bullet_instance = player.bullet.instantiate()
	bullet_instance.rotation = direction.angle()	
	bullet_instance.bullet_damage *= player.player_weapon_damage*gun_damage_mod
	bullet_instance.bullet_pierce += player.player_pierce
	bullet_instance.bullet_speed *= player.player_weapon_bullet_speed
	bullet_instance.position = muzzle_position_global
	bullet_instance.direction = direction+Vector2(bullet_direction_mod/10,bullet_direction_mod/10)
	get_tree().current_scene.add_child(bullet_instance)
