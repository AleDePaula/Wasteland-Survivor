extends Gun
@export var bullet_spread_count: float
const spread = deg_to_rad(15)
var max_spread = deg_to_rad(30)

func fire():
	animation.play("shoot")
	can_shoot = false
	timer.start()
	muzzle_position_global = muzzle.global_position
	for angle in bullet_spread_count:
		var angle_offset = lerp(-max_spread, max_spread , float(angle)/bullet_spread_count)
		var bullet_instance = player.bullet.instantiate()
		var direction = (muzzle_position_global - global_position).normalized()
		bullet_instance.position = muzzle_position_global
		bullet_instance.direction = direction.rotated(angle_offset)
		bullet_instance.rotation = direction.angle()+angle_offset
		bullet_instance.bullet_damage *= player.player_weapon_damage*gun_damage_mod
		bullet_instance.bullet_pierce += player.player_pierce
		bullet_instance.bullet_speed *= player.player_weapon_bullet_speed
		get_tree().current_scene.add_child(bullet_instance)
