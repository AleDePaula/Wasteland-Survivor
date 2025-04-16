class_name Loot
extends Area2D

@export var junk_value: int

var GM = GameManager
var PM = PlayerManager

func _on_area_entered(area):
	
	if area.get_parent() is Player:
		
		var player: Player = area.get_parent()
		player.get_junk(junk_value)
		queue_free()
