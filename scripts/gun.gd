class_name Gun
extends Node2D

var GM = GameManager
var PM = PlayerManager

@onready var animation = $MuzzlePath/PathFollow2D/GunSprite/Muzzle/AnimationPlayer
@onready var sprite = $MuzzlePath/PathFollow2D/GunSprite
@onready var path = $MuzzlePath/PathFollow2D
@onready var muzzle =$MuzzlePath/PathFollow2D/GunSprite/Muzzle
@onready var timer = $Timer

@export var gun_name: String
@export var bullet_speed: float
@export var gun_shoot_cooldown: float
@export var gun_damage_mod: float

var player:Node2D
var can_shoot: bool = false
var mouse_enable: bool = true
var shoot_counter: float = 0
var muzzle_position_global: Vector2
var muzzle_position_local: Vector2
var bullet: PackedScene

func _ready():
	player = PM.player
	bullet = player.bullet
	can_shoot = true
	timer.wait_time = gun_shoot_cooldown

func _on_timer_timeout():
	can_shoot = true

func fire():
	animation.play("shoot")
	can_shoot = false
	timer.start()
	muzzle_position_global = muzzle.global_position
	var direction = (muzzle_position_global - global_position).normalized()
	var bullet_instance = player.bullet.instantiate()
	bullet_instance.rotation = direction.angle()
	bullet_instance.bullet_damage *= player.player_weapon_damage*gun_damage_mod
	bullet_instance.bullet_pierce += player.player_pierce
	bullet_instance.bullet_speed *= player.player_weapon_bullet_speed
	bullet_instance.position = muzzle_position_global
	bullet_instance.direction = direction
	get_tree().current_scene.add_child(bullet_instance)
