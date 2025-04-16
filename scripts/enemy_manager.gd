extends Node
var GM = GameManager
var PM = PlayerManager
var SM = StageManager

@export_category("ENEMIES BASE STATS")
@export var enemies_max_health_modifier: float
@export var enemies_heal_modifier:int
@export var enemies_max_xp: int
@export var enemies_max_radiation: int
@export var enemies_radiation_modfier: int

@export var enemies_speed_modifier: float

var enemy: Node2D
var player_is_dodging: bool
