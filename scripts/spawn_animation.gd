extends AnimatedSprite2D

func _on_animation_finished():
	
	get_parent().set_process(true)
	get_parent().set_physics_process(true)
	queue_free()
