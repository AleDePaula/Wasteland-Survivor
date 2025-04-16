extends Area2D

var PM = PlayerManager
var GM = GameManager
var EM = EnemyManager

@onready var stomp_animation = $StompAnimation
@onready var stomp_audio = $StompAudio
@onready var stomp_timer = $StompTimer

@export var stomp_prefab: PackedScene

@export var base_area: float
@export var base_damage: float
@export var base_damage_interval: float #in seconds
@export var base_speed: float
@export var base_projectile: int
@export var base_knockback: float

var player: Player
var steps_taken: int

func _ready():
	player = PM.player
	stomp_timer.wait_time = base_damage_interval
	stomp_timer.start()
	stomp_timer.paused = false

func _process(delta):
	
	check_steps()
	
func deal_damage():
	var enemies_in_range = get_overlapping_bodies()
	for enemy in enemies_in_range:
		enemy.enemy_recieve_damage(base_damage*player.player_mutation_damage_mod)
		enemy.add_knockback(base_knockback)
	
	stomp_audio.play()
	stomp_animation.play("stomp_animation")
	
func add_step():
	steps_taken +=1

func check_steps():
	if player.is_moving:
		stomp_timer.paused = false
	else:
		stomp_timer.paused = true
		
func _on_stomp_timer_timeout():
	stomp_timer.wait_time = base_damage_interval
	stomp_timer.start()
	deal_damage()
