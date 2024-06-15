class_name Item
extends Area2D

@onready var animation = $AnimationPlayer

@export var base_heal_amount: float = 30 #in %
@export var can_health: float = 8

var junk_dropped: int = 0



func _on_area_entered(area):
	
	if area is Bullet:
		
		var bullet : Bullet = area
		var this_can_health = can_health - bullet.bullet_damage	
		if this_can_health>=0:
			animation.stop()
			animation.play("hit")
		
		else:
			animation.play("explode")
			
	elif area.get_parent() is Player:
		var player: Player = area.get_parent()
		if player.player_max_health == player.player_health:
			return
		else:
			player.heal(base_heal_amount)
			queue_free()
		
