extends Area2D

var GM = GameManager

@onready var animation = $BulletSprite/AnimationPlayer

@export var vomit_speed: float
@export var vomit_damage: float

var direction : Vector2
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * vomit_speed * delta


func _on_body_entered(body):
	
	if body.name == "TileMap":
		direction = Vector2.ZERO
		animation.play("collide")
		
	if body.is_in_group("player"):
		set_physics_process(false)
		animation.play("collide")
		GM.player.take_damage(vomit_damage)
	else: return

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
