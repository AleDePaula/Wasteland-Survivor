class_name Weapon
extends Node2D

var GM = GameManager

@onready var animation = $MuzzlePath/PathFollow2D/Sprite2D/Muzzle/AnimationPlayer
@onready var sprite = $MuzzlePath/PathFollow2D/Sprite2D
@onready var path = $MuzzlePath/PathFollow2D
@onready var muzzle = $MuzzlePath/PathFollow2D/Sprite2D/Muzzle

@export var bullet_prefab: PackedScene
@export var bullet_speed: float = 0
@export var shoot_cooldown: float = 0.5

var mouse_enable: bool = true
var shoot_counter: float = 0
var muzzle_position_global: Vector2
var muzzle_position_local: Vector2

func _ready():
	GM.weapon = self

func _process(delta):
	muzzle_position_global = muzzle.global_position
