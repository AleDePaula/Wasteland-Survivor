extends Area2D

var GM = GameManager
@onready var damage_timer = $DamageTimer

@export var damage_animation_prefab: PackedScene
@export var base_area_damage: float = 1
@export var base_damage_interval: float = 2

var final_area_damage = base_area_damage * GM.player.player_damage_modifier

func _ready():
	damage_timer.wait_time = base_damage_interval
	damage_timer.start()
	
func _on_damage_timer_timeout():
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		
		var target : Enemy = body		
		target.enemy_recieve_damage(final_area_damage)
		var animation = damage_animation_prefab.instantiate()
		target.add_child(animation)
