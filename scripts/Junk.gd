extends Node2D

var GM = GameManager

@onready var sprite = $Sprite2D


@export var drop_rate : Vector2 = Vector2(11,90)

var junk_sprite: Array = [preload("res://assets/junk/Zombie-Tileset---_0192_Capa-193.png"),
preload("res://assets/junk/Zombie-Tileset---_0327_Capa-328.png"),
preload("res://assets/junk/Zombie-Tileset---_0354_Capa-355.png"),
preload("res://assets/junk/Zombie-Tileset---_0355_Capa-356.png")]

var junk_dropped: int = 0

func _ready():
	
	sprite.set_texture(junk_sprite[junk_dropped])	
	
func _on_area_entered(area):
	
	if area.get_parent() is Player:
		
		var player: Player = area.get_parent()
		player.get_junk(junk_dropped)
		queue_free()
		
