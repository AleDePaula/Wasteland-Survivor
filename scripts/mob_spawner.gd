extends Node2D

var GM = GameManager
var EM = EnemyManager

@onready var spawn_timer = $SpawnTimer

@export_category("SCENES")
@export var spawn_animation: PackedScene

@export var creatures: Array[PackedScene]

@export_enum("Normal:1", "Hard:2","Hell:3") var spawner_base_difficulty: int = 1
@export var mobs_per_second: float
@export var spawner_power: int
@export var max_mobs: int 
@export var max_bosses: int
@export var max_turrets: int
@export_category("ADD SPAWN AREA! SPAWNER SIZE")
@export var max_spawn_x: float
@export var max_spawn_y: float

var mob_counter: int
var boss_counter: int
var turret_counter: int

var final_mobs_per_minute: float
var final_spawner_power: int
var final_max_mobs: int
var final_max_bosses: int
var final_max_turrets: int

var spawner_difficulty: int = 1 

var spawn_area : Node2D

var countdown_difficulty: int = 0

func _ready():	
	spawn_area = find_child("SpawnerArea").get_child(0)

func _process(delta):
	set_difficulty()
	pass
	
func _on_spawn_timer_timeout():
	countdown_difficulty+=1
	
	if !GM.player_died:
	
		var nodes_in_scene = get_tree().current_scene.get_children()
		
		boss_counter = 0
		turret_counter = 0
		mob_counter = 0
		if !final_spawner_power<=0:
			if boss_counter==final_max_bosses and turret_counter==final_max_turrets and mob_counter==final_max_mobs:
				return
			else:
				for node in nodes_in_scene:
					if node.is_in_group("mobs"):
						mob_counter+=1
					if node.is_in_group("turrets"):
						turret_counter+=1
					if node.is_in_group("bosses"):
						boss_counter+=1	
				choose_spawn_mob()	
	
func choose_spawn_mob():
	
	var pick_spawn = randi_range(0,creatures.size()-1)
	var spawn_instance = creatures[pick_spawn].instantiate()
	spawn_instance.position = Vector2(randf_range(0,max_spawn_x), randf_range(0,max_spawn_y))
	var has_point = PhysicsPointQueryParameters2D.new()
	
	has_point.collide_with_areas = true
	has_point.collide_with_bodies = false
	has_point.position = spawn_instance.position
	has_point.collision_mask = -2147483648
	var result = get_world_2d().direct_space_state.intersect_point(has_point)
	if result.size()>0:
		if spawn_instance.is_in_group("mobs") and mob_counter<final_max_mobs:
			spawn_mob(spawn_instance)
		
		elif spawn_instance.is_in_group("turrets") and turret_counter<final_max_turrets:
			spawn_mob(spawn_instance)
			
		elif spawn_instance.is_in_group("bosses") and boss_counter<final_max_bosses:
			spawn_mob(spawn_instance)
			
		else:
			spawn_instance.queue_free()
	else: choose_spawn_mob()
	
func spawn_mob(mob_prefab):
	
	EM.enemy = mob_prefab
	final_spawner_power-=mob_prefab.spawner_power_cost	
	var set_spawn_animation = spawn_animation.instantiate()
	mob_prefab.add_child(set_spawn_animation)
	get_tree().current_scene.add_child(mob_prefab, true)
	
func set_difficulty():
	final_mobs_per_minute = clamp((1/(mobs_per_second*(spawner_difficulty * spawner_base_difficulty))),0.2,2)
	final_spawner_power = spawner_power*(spawner_difficulty * spawner_base_difficulty)
	final_max_mobs = max_mobs*(spawner_difficulty * spawner_base_difficulty)
	final_max_bosses = max_bosses+(spawner_difficulty * spawner_base_difficulty)
	final_max_turrets = max_turrets+(spawner_difficulty * spawner_base_difficulty)
	spawn_timer.wait_time=final_mobs_per_minute
