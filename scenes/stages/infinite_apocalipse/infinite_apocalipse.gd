extends Node2D

var GM = GameManager

@onready var mob_spawner = $MobSpawner

var difficulty: int = 1


func _process(delta):
	change_difficulty()
	
func change_difficulty():
	if mob_spawner.countdown_difficulty>=300:
		print("Aumentou dificuldade")
		mob_spawner.countdown_difficulty=0
		difficulty+=1
		mob_spawner.spawner_difficulty = difficulty
		GM.player.xp_modifier+=0.2
