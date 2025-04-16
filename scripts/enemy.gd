class_name Enemy
extends CharacterBody2D

var GM = GameManager
var PM = PlayerManager
var EM = EnemyManager
var SM = StageManager

@onready var attack_hit_box = $AttackHitBox
@onready var enemy_hit_box = $EnemyHitBox
@onready var enemy_sprite = $AnimatedSprite2D
@onready var hp_bar = $HpBar

@export_category("SCENES")

@export var death_prefab: PackedScene
@export var damage_card: PackedScene

@export_category("ENEMY STATS")
@export var enemy_xp: int
@export var enemy_health: float
@export var enemy_damage: float
@export var enemy_speed: float
@export var enemy_cooldown: float
@export var spawner_power_cost: int
@export var loot_amount: int

##### SIGNALS #######
signal drop_loot
signal drop_radiation

#MISC VARIABLES
var is_turret: bool
var looking_side: String
var enemy_speed_multiplier: float
var speed : float

var player = PM.player

var attack_cooldown: float

func _ready():
	is_turret = false
	enemy_speed_multiplier = 1
	speed = enemy_speed*enemy_speed_multiplier
	attack_cooldown = 0
	hp_bar.max_value= enemy_health
	hp_bar.value=enemy_health
	if is_in_group("turrets"):
		is_turret=true
	set_process(false)
	set_physics_process(false)

func _process(delta):
	process_attack_cooldown(delta)
	deal_damage_to_player()
	check_player_dodge()
	
	if enemy_health<=0:enemy_die()

func _physics_process(delta):
	follow_player()
	turn_sprite()

func follow_player():
	if is_turret: return
	else:
		if !GM.player_died:
			
			var player_position = GM.player_position
			var distance = player_position - position
			var input_vector = distance.normalized()
			velocity = input_vector.normalized() * speed
			
			if velocity> Vector2(0,0) or velocity < Vector2(0,0):
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
		const vomit_prefab = preload("res://scenes/enemy_scenes/turret/vomit.tscn")
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

func enemy_recieve_damage(bullet_damage):

	var damage_card_instance = damage_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(bullet_damage)
	add_child(damage_card_instance)
	enemy_health-=bullet_damage
	hp_bar.value=enemy_health
	
func add_knockback(knockback):
	pass

func enemy_die():
	GM.enemies_killed+=1
	enemy_speed=0
	emit_signal("drop_loot")
	emit_signal("drop_radiation")
	if death_prefab:
		var death_animation = death_prefab.instantiate()
		death_animation.scale = scale
		death_animation.position = position
		get_parent().add_child(death_animation)
	queue_free()

func process_attack_cooldown(delta):
	attack_cooldown-=delta

func check_player_dodge():
	if EM.player_is_dodging:
		self.set_collision_mask_value(1, false)
	else:
		self.set_collision_mask_value(1, true)
