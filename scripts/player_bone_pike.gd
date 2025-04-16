extends Area2D

var GM = GameManager

var spike_speed: float
var spike_damage: float

var direction : Vector2
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * spike_speed * delta

func _on_body_entered(body):
	
	if body.name == "TileMap":
		direction = Vector2.ZERO
		queue_free()
		#animation.play("collide")
		
	if body.is_in_group("enemies"):
		set_physics_process(false)
		#animation.play("collide")
		body.enemy_recieve_damage(spike_damage)
		queue_free()
	else: return
	
