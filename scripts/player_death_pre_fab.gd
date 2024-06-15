extends Node2D

var GM = GameManager

func _on_animated_sprite_2d_animation_finished():
	GM.player.queue_free()
