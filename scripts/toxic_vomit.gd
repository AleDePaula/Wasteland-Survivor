extends Node2D

var GM = GameManager
var PM = PlayerManager

var player = PM.player

@onready var shoot_timer = $ShootTimer
@onready var vomit_path = $ProjectilePath/PathFollow2D
@onready var vomit_spawn = $ProjectilePath/PathFollow2D/VomitSpawnPoint

@export var vomit_prefab: PackedScene

@export var base_area: float
@export var base_damage: float
@export var base_damage_interval: float #in seconds
@export var base_speed: float
@export var base_projectile: int

var final_projectile: int 

func _ready():
	shoot_timer.wait_time = base_damage_interval-((base_damage_interval * player.player_mutation_cooldown_mod)/100)
	shoot_timer.start()
	
func _on_damage_timer_timeout():
	shoot_timer.wait_time = base_damage_interval-((base_damage_interval * player.player_mutation_cooldown_mod)/100)
	final_projectile = base_projectile + player.player_mutation_projectiles_mod
	
	for vomit in final_projectile:
		var spawn_position = randf()
		var vomit_instance = vomit_prefab.instantiate()
		
		vomit_path.progress_ratio = spawn_position
		vomit_instance.position = vomit_spawn.global_position
		vomit_instance.direction = (vomit_spawn.global_position - global_position).normalized()
		vomit_instance.rotation = vomit_instance.direction.angle()
		vomit_instance.vomit_speed = base_speed*player.player_mutation_speed_mod
		vomit_instance.vomit_damage = base_damage*player.player_mutation_damage_mod
		
		get_tree().current_scene.add_child(vomit_instance, true)
