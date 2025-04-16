extends Node2D

var GM = GameManager
var PM = PlayerManager

var player = PM.player

@onready var shoot_timer = $ShootTimer
@onready var range_box = $RangeBox
@onready var ray_cast_2d = $RayCast2D

@export var spike_prefab: PackedScene

@export var base_area: float
@export var base_damage: float
@export var base_damage_interval: float #in seconds
@export var base_speed: float
@export var base_projectile: int

var final_projectile: int 

func _ready():
	shoot_timer.wait_time = base_damage_interval-((base_damage_interval * player.player_mutation_cooldown_mod)/100)
	shoot_timer.start()

func find_closest_enemy():
	var enemies = range_box.get_overlapping_bodies()
	enemies.sort_custom(sort_closest)
	return enemies.front()
	
func sort_closest(a, b):
	return a.position.distance_to(player.position) < b.position.distance_to(player.position)
	
func _on_damage_timer_timeout():
	var closer_enemy = find_closest_enemy()
	
	shoot_timer.wait_time = base_damage_interval-((base_damage_interval * player.player_mutation_cooldown_mod)/100)
	final_projectile = base_projectile + player.player_mutation_projectiles_mod
	if closer_enemy != null:
		var spike_instance = spike_prefab.instantiate()
		spike_instance.position = player.global_position
		spike_instance.direction = (closer_enemy.position - global_position).normalized()
		spike_instance.rotation = spike_instance.direction.angle()
		spike_instance.spike_speed = base_speed*player.player_mutation_speed_mod
		spike_instance.spike_damage = base_damage*player.player_mutation_damage_mod
		get_tree().current_scene.add_child(spike_instance, true)
		closer_enemy = null
