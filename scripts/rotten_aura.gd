extends Area2D

var GM = GameManager
var PM = PlayerManager

var player = PM.player

@onready var damage_timer = $DamageTimer

@export var damage_animation_prefab: PackedScene
@export var base_area: float
@export var base_area_damage: float
@export var base_damage_interval: float #in seconds

var final_area: float
var final_area_damage: float
var final_damage_interval: float

func _ready():
	set_mutation_stats()
	damage_timer.wait_time = final_damage_interval
	damage_timer.start()
	
func _on_damage_timer_timeout():
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		
		var target : Enemy = body
		target.enemy_recieve_damage(final_area_damage)
		var animation = damage_animation_prefab.instantiate()
		target.add_child(animation)

func set_mutation_stats():
	final_area = base_area*player.player_mutation_damage_mod
	final_area_damage = base_area_damage*player.player_mutation_damage_mod
	final_damage_interval = base_damage_interval-((base_damage_interval * player.player_mutation_cooldown_mod)/100)
