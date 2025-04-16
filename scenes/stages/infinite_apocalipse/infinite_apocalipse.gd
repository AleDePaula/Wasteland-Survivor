extends Node2D

var GM = GameManager
var PM = PlayerManager
var SM = StageManager
var EM = EnemyManager

@onready var mob_spawner = $MobSpawner
@onready var mob_spawner_timer = $MobSpawner/MobSpawnerTimer

var difficulty: int = 1

func _ready():
	mob_spawner_timer.wait_time = 300
	mob_spawner_timer.start()

func _on_mob_spawner_timer_timeout():
	print("Aumentou a dificuldade")
	mob_spawner.countdown_difficulty=0
	difficulty+=1
	mob_spawner.spawner_difficulty = difficulty
	GM.player.xp_modifier+=0.2
		
func _on_tree_entered():
	GM.root_scene = GM.get_tree().current_scene
	GM.add_ui_to_scene()
	PM.add_player_to_scene()
	GM.add_camera_to_scene()
