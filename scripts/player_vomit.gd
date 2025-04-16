extends Area2D

var GM = GameManager

@onready var animation = $BulletSprite/AnimationPlayer

var vomit_speed: float
var vomit_damage: float

var direction : Vector2
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * vomit_speed * delta

func _on_body_entered(body):
	
	if body.name == "TileMap":
		direction = Vector2.ZERO
		animation.play("collide")
		
	if body.is_in_group("enemies"):
		set_physics_process(false)
		#animation.play("collide")
		body.enemy_recieve_damage(vomit_damage)
	else: return
