class_name Enemy
extends CharacterBody2D

var GM = GameManager
@onready var attack_hit_box = $AttackHitBox
@onready var enemy_hit_box = $EnemyHitBox
@onready var enemy_sprite = $AnimatedSprite2D

@export_category("SCENES")
@export var spawn_animation: PackedScene
@export var death_prefab: PackedScene
@export var damage_card: PackedScene

@export_category("ENEMY STATS")
@export var enemy_xp: int
@export var enemy_health: float
@export var enemy_damage: float
@export var enemy_speed: float
@export var enemy_cooldown: float
@export var spawner_power_cost: int

##### SIGNALS #######
signal drop_loot

var is_turret: bool
var looking_side: String
var enemy_speed_multiplier: float
var speed : float

var attack_cooldown: float
func _ready():
	is_turret = false
	enemy_speed_multiplier = 1
	speed = enemy_speed*enemy_speed_multiplier
	attack_cooldown = 0
	if is_in_group("turrets"):
		is_turret=true
	set_process(false)
	set_physics_process(false)	

func _process(delta):
	process_attack_cooldown(delta)
	deal_damage_to_player()
	if enemy_health<=0:
		enemy_die()	
	if GM.player_died:
		speed = 0

func _physics_process(delta):
	follow_player()
	turn_sprite()	

func follow_player():
	if is_turret: return
	else:
		var player_position = GM.player_position
		var distance = player_position - position
		var input_vector = distance.normalized()
		velocity = input_vector.normalized() * speed * 10
		move_and_slide()

func turn_sprite():
	var player_position = GM.player_position
	var distance = player_position - position
	
	var angle = snappedf(distance.angle(), PI/4)/(PI/4)
	angle = wrapi(float(angle),0,8)
		
	if angle == 0 || angle ==1:
		enemy_sprite.set_flip_h(true)
		looking_side="side"
	if angle == 4 || angle == 5:
		enemy_sprite.set_flip_h(false)
		looking_side="side"	
	if angle == 6 || angle == 7:
		enemy_sprite.set_flip_h(false)
		looking_side="up"
	if angle == 2 || angle == 3:
		enemy_sprite.set_flip_h(false)
		looking_side="down"
	
	enemy_sprite.play("walk_"+looking_side)
	
func deal_damage_to_player():
	if !is_turret:
		var player_body = attack_hit_box.get_overlapping_bodies()
		for target in player_body:
			var player: Player = target
			if attack_cooldown<=0:
				player.take_damage(enemy_damage)
				attack_cooldown = enemy_cooldown
	else:
		var turret_range = attack_hit_box.get_overlapping_bodies()
		const vomit_prefab = preload("res://scenes/vomit.tscn")
		for player_body in turret_range:
			if player_body is Player:
				if attack_cooldown<=0:
					attack_cooldown=enemy_cooldown
					var direction = (player_body.position - global_position).normalized()
					var vomit_instance = vomit_prefab.instantiate()
					vomit_instance.vomit_damage = enemy_damage
					vomit_instance.position = position
					vomit_instance.rotation = direction.angle()
					vomit_instance.direction = direction
					get_tree().current_scene.add_child(vomit_instance)

func _on_enemy_hit_box_area_entered(area):	
	if area is Bullet:
		var bullet : Bullet = area
		enemy_recieve_damage(bullet.bullet_damage)
		
		if bullet.bullet_pierce<=0:
			bullet.set_physics_process(false)
			bullet.animation.play("collide")
		else:
			bullet.bullet_pierce-=1
			
func enemy_recieve_damage(bullet_damage):
	
	var damage_card_instance = damage_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(bullet_damage)
	add_child(damage_card_instance)
	damage_card_instance.find_child("AnimationPlayer").play("show_damage")
	enemy_health-=bullet_damage

func enemy_die():
	GM.enemies_killed+=1
	enemy_speed=0
	GM.player.gain_xp(enemy_xp)
	emit_signal("drop_loot")
	if death_prefab:
		var death_animation = death_prefab.instantiate()
		death_animation.scale = scale
		death_animation.position = position
		get_parent().add_child(death_animation)
	queue_free()

func process_attack_cooldown(delta):
	attack_cooldown-=delta
