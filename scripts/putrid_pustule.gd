extends Node2D

var PM = PlayerManager
var GM = GameManager
var EM = EnemyManager

@onready var pustule_spawn_timer = $PustuleSpawnTimer
@export var putrid_pustule_prefab: PackedScene

@export var base_area: float
@export var base_damage: float
@export var base_damage_interval: float #in seconds
@export var base_speed: float
@export var base_projectile: int
@export var base_knockback: float
@export var base_timer: float

@export var spawn_time: float

var player: Player

func _ready():
	player = PM.player
	pustule_spawn_timer.wait_time = spawn_time*player.player_mutation_speed_mod

func _on_pustule_spawn_timer_timeout():
	var pustule_instance = putrid_pustule_prefab.instantiate()
	pustule_instance.position = player.global_position
	pustule_instance.final_timer = base_timer*player.player_mutation_timer_mod
	pustule_instance.final_damage_interval = base_damage_interval*player.player_mutation_speed_mod
	pustule_instance.final_damage = base_damage*player.player_mutation_damage_mod
	pustule_instance.final_knockback = base_knockback
	pustule_instance.final_area = base_area*player.player_mutation_area_mod
	get_tree().current_scene.add_child(pustule_instance)
	pustule_spawn_timer.wait_time = spawn_time*player.player_mutation_speed_mod 
	pustule_spawn_timer.start()
