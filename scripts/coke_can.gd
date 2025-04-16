class_name Item
extends Area2D

@onready var animation = $AnimationPlayer
@onready var max_health_text = $MaxHealthText

@export var item_name: String
@export var base_heal_amount: float #in %
@export var base_rheal_amount: float #in %
@export var item_health: float = 8

var junk_dropped: int = 0

func _ready():
	max_health_text.visible=false

func _on_area_entered(area):
	if item_name == "Coke Can" and area is Bullet:
		var bullet : Bullet = area
		var this_can_health = item_health - bullet.bullet_damage	
		if this_can_health>=0:
			animation.stop()
			animation.play("hit")
		else:
			animation.play("explode")
			
	elif area.get_parent() is Player:
		var player: Player = area.get_parent()
		if player.player_max_hp == player.player_hp and player.player_rad<=0 :
			max_health_text.visible=true
			
			return
		else:
			player.heal(base_heal_amount, base_rheal_amount, item_name)
			queue_free()
			
func _on_area_exited(area):
	if area.get_parent() is Player:
		max_health_text.visible=false
