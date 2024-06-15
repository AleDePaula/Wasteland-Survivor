class_name Bullet
extends Area2D

@onready var animation = $BulletSprite/AnimationPlayer

@export var bullet_speed: float = 500
@export var bullet_damage: float = 2
@export var bullet_pierce: int = 0

var direction : Vector2
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * bullet_speed * delta


func _on_body_entered(body):
	
	if body.name == "TileMap":
		direction = Vector2.ZERO
		animation.play("collide")
		
