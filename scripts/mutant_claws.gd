extends Node2D

var PM = PlayerManager
var GM = GameManager
var EM = EnemyManager

@onready var claw_spawn_timer = $Claw_Spawn_Timer
@export var claw_prefab: PackedScene
@onready var claw_spawn = $Claw_Spawn

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
	
func _process(delta):
	if player.is_moving:
		claw_spawn_timer.wait_time = (spawn_time*player.player_mutation_speed_mod)*2 
	else:
		(spawn_time*player.player_mutation_speed_mod)/2

func _on_claw_spawn_timer_timeout():
	print("XABLAU!")
	#var claw_instance = claw_prefab.instantiate()
	#claw_instance.position = claw_spawn.position
	#add_child(claw_instance)
	
	
