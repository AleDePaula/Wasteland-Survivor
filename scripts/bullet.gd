class_name Bullet
extends Area2D

@onready var animation = $BulletSprite/AnimationPlayer

@export var bullet_speed: float
@export var bullet_damage: float
@export var bullet_pierce: int

var direction : Vector2

func _physics_process(delta):
	
	if direction != Vector2.ZERO:
		position += direction * bullet_speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.enemy_recieve_damage(bullet_damage)
		if bullet_pierce<=0:
			set_physics_process(false)
			animation.play("collide")
		else:
			bullet_pierce-=1
			
	if body.name == "TileMap":
		direction = Vector2.ZERO
		animation.play("collide")
