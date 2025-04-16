
extends Node

var GM = GameManager
var PM = PlayerManager
var EM = EnemyManager

#PLAYER STATS
@export_category("DIFFICULT SETTINGS")
@export var difficulty_level: int

@export_category("SPAWNER SETTINGS")

@export_category("LOOT SETTINGS")
@export var loot_chance_modifier: int = 1
