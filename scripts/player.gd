class_name Player
extends CharacterBody2D

#preloads
var GM = GameManager
var PM = PlayerManager
var SM = StageManager
var EM = EnemyManager

#signals
#node addresses
@onready var player_sprite = $PlayerSprite
@onready var move_animation = $PlayerSprite/MoveAnimation
@onready var dodge_timer = $DodgeTimer
@onready var player_collision = $PlayerCollision
@onready var hit_box = $HitBox
@onready var bullet_sound = $BulletSound
@onready var damage_audio = $DamageAudio
@onready var heal_audio = $HealAudio
@onready var dodge_sound = $DodgeSound
@onready var junk_audio = $JunkCollectedAudio

@export_category("NAME")
@export var char_name: String
@export var char_sprite: Texture2D

@export_category("PREFABS")
@export var dodge_prefab: PackedScene
@export var player_death_prefab: PackedScene
@export var level_up_card: PackedScene
@export var damage_amount_card: PackedScene
@export var heal_amount_card: PackedScene

@export_category("PLAYER BASE STATS")
@export var player_base_max_health: float
@export var player_base_heal_mod:int
@export var player_base_speed: int
@export var player_base_max_rad: int
@export var player_base_rad_mod: float

@export_category("PLAYER WEAPON MODFIERS")
@export var player_base_shoot_cooldown: float
@export var player_base_weapon_damage: int
@export var player_base_weapon_bullet_speed: int
@export var player_base_weapon_pierce: int

@export_category("PLAYER MUTATION MODFIERS")
@export var player_base_max_stat_mutations_mod: int
@export var player_base_max_attack_mutations_mod: int
@export var player_base_mutation_damage_mod: float
@export var player_base_mutation_speed_mod:float
@export var player_base_mutation_area_mod: float
@export var player_base_mutation_cooldown_mod: float #in % higher is better
@export var player_base_mutation_projectiles_mod: float
@export var player_base_mutation_pierce_mod: float
@export var player_base_mutation_timer_mod: float

@export_category("PLAYER COMPANION MODIFIERS")
@export var player_base_companion_damage: int

@export_category("PLAYER DODGE")
@export var player_base_dodge_cooldown: float
@export var player_base_dodge_speed: float
@export var player_base_dodge_lenght: float

#variables for Player Stats
var player_hp: int
var player_max_hp: float
var player_heal_mod: int #in %, bigger is better
var player_speed: int
var player_xp: float
var player_max_xp: int
var player_level: int
var player_level_cap: int
var player_skip_count: int
var player_reroll_count: int
var player_rad: float
var player_max_rad: float
var player_rad_mod: float

#variables for the weapon
var weapon: Node2D
var player_weapon_damage: float
var player_main_shoot_cooldown: float #in % higher is better
var player_pierce: int
var player_weapon_bullet_speed: int
var shoot_cooldown_counter: float
var muzzle_position_global: Vector2 
var muzzle_position_local: Vector2
var turn_to: float
var mouse_inside_player_area: bool = false

#dodge cooldowns
var player_dodge_cooldown: float #in % higher is better
var player_dodge_speed: float
var player_dodge_lenght: float
var player_dodging: bool

var dodge_cooldown_counter: float

#variables for the companion
var companion: Node2D

#variables for bullets
var bullet: PackedScene

#variables for movement
var input_vector: Vector2 = Vector2(0,0)
var speed: float
var is_moving: bool
var action: String
var looking_side: String
var is_dead: bool

#mutation variables
var mutation_book: Array[Dictionary] = []
var player_stats_mutations: Array[Dictionary] = []
var mutation_scene: Area2D
var player_max_attack_mutations: int
var player_max_stat_mutations: int
var player_mutation_damage_mod: float
var player_mutation_speed_mod: float
var player_mutation_area_mod: float
var player_mutation_cooldown_mod: float #in %, bigger is better
var player_mutation_projectiles_mod: float
var player_mutation_pierce_mod: float
var player_mutation_timer_mod: float

#UI variables
var ui = GM.game_ui

#Junk variables
var junk_total: int = 0

#level variables
var xp_modifier: float = 1.0

#misc variable
var mouse_enable: bool

######################FUNCTIONS#######################
##NATIVE FUNCTIONS

func _ready():
	
	PM.set_player_final_stats()
	game_start()
	
func _process(delta):
	GM.player_position = position
	muzzle_position_global = weapon.muzzle_position_global
	muzzle_position_local = weapon.muzzle_position_local
		
	#handle XP
	process_level()
	process_rad()
	read_input(delta)
	cooldown_handler(delta)
	
func _physics_process(delta: float) -> void:
	if is_dead:return
	move_weapon()
	move_player()
	turn_player()
	move_weapon()
	
func _input(event):	
	#Enable/Disable Mouse
	if event is InputEventMouseMotion || event is InputEventKey:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_enable = true
	
	if event is InputEventJoypadMotion || event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		mouse_enable = false
		
func _unhandled_key_input(event):
	pass

###CUSTOM FUNCTIONS

#process functions:
func read_input(delta)->void:
	#Check input
	check_input()
	#Check for command Shoot
	shoot_weapon(delta)
	#check for command DODGE
	call_dodge()

func cooldown_handler(delta):
	dodge_cooldown_counter-=delta
	if dodge_cooldown_counter <=0.0: dodge_cooldown_counter = 0.0
	shoot_cooldown_counter-=delta
	if shoot_cooldown_counter <=0.0: shoot_cooldown_counter = 0.0

func game_start():
	
	GM.mouse_enable = true
	is_dead = false
	is_moving=false
	EM.player_is_dodging = false
	
func move_player()->void:
	
	var target_velocity = input_vector
	velocity = lerp(velocity, target_velocity, 1)
	velocity = velocity.normalized()*speed
	if velocity>Vector2(0,0) or velocity<Vector2(0,0):
		move_and_slide()
	
func check_input():
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	#Check if its moving
	if input_vector != Vector2(0,0):
		is_moving = true
	else:
		is_moving = false
	#Joystick Deadzone
	var deadzone = 0.15
	if abs(input_vector.x)< deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y)< deadzone:
		input_vector.y = 0.0
	
func turn_player():
	
	var angle = snappedf(turn_to, PI/4)/(PI/4)
	angle = wrapi(float(angle),0,8)
	
	if is_moving:
		action = "walk"
	else:
		action = "idle"
		
	if angle == 0 || angle ==1:		
		player_sprite.set_flip_h(false)
		looking_side="side"
	if angle == 4 || angle == 5:		
			player_sprite.set_flip_h(true)
			looking_side="side"	
	if angle == 6 || angle == 7:		
			player_sprite.set_flip_h(false)
			looking_side="up"
	if angle == 2 || angle == 3:		
		player_sprite.set_flip_h(false)		
		looking_side="down"
			
	move_animation.play(action+"_"+looking_side)
	
#Dodge Handlers
func call_dodge():
	if is_moving:
		dodge()
	if is_dodging():
		EM.player_is_dodging = true
		set_collision_mask_value(2, false)
		set_collision_mask_value(9, false)
		set_collision_mask_value(4, false)
		
		speed = player_dodge_speed 
	else: 
		speed = player_speed
	player_dodging = true if is_dodging() else false
	
	
func dodge():
	if Input.is_action_just_pressed("dodge") and dodge_cooldown_counter<=0:
		dodge_sound.play(0.1)
		dodge_cooldown_counter=player_dodge_cooldown
		
			
		var dodge_animation = dodge_prefab.instantiate()
		dodge_animation.position = position
		dodge_animation.flip_h = player_sprite.flip_h
		get_parent().add_child(dodge_animation)
		
		dodge_timer.start(player_dodge_lenght)
		dodge_timer.wait_time = player_dodge_lenght

func _on_dodge_timer_timeout():
	EM.player_is_dodging = false
	set_collision_mask_value(2, true)
	set_collision_mask_value(4, true)
	set_collision_mask_value(9, true)
			
func is_dodging():
	return !dodge_timer.is_stopped()

#WEAPON Handlers
func move_weapon():
	var offset_y_left: float
	var offset_y_right: float
	match weapon.name:
		"Pistol":
			offset_y_left = 0
			offset_y_right = 1.5
		"Shotgun":
			offset_y_left = 1.5
			offset_y_right = 3
	
	var RStick_input_vector = Input.get_vector("aim_left","aim_right","aim_up","aim_down")	
		
	if !mouse_enable:
	
		if RStick_input_vector:
			
			var muzzle_angle = RStick_input_vector.angle()
			weapon.path.progress_ratio = ((muzzle_angle/PI)+1)/2
			turn_to = muzzle_angle
					
			if RStick_input_vector.x<0:
				weapon.sprite.offset.y = offset_y_right
				weapon.sprite.flip_v=true
			else:
				weapon.sprite.offset.y = offset_y_left
				weapon.sprite.flip_v=false
			
	else:
		
		if !mouse_inside_player_area:
			var mouse_position = get_local_mouse_position()
			var angle: float = mouse_position.angle()/PI
			var final_angle = (angle+1)/2
			turn_to = mouse_position.angle()
			weapon.path.progress_ratio=final_angle
			
			if final_angle>0 && final_angle<0.25:
				weapon.sprite.offset.y =  offset_y_left
				weapon.sprite.flip_v=true
			if final_angle>=0.25 && final_angle<=0.75:
				weapon.sprite.offset.y =  offset_y_right
				weapon.sprite.flip_v=false
			if final_angle>0.75:
				weapon.sprite.offset.y =  offset_y_left
				weapon.sprite.flip_v=true
			
			weapon.sprite.look_at(get_global_mouse_position())

func _on_hit_box_mouse_entered():
	mouse_inside_player_area = true
	
func _on_hit_box_mouse_exited():
	mouse_inside_player_area=false
	
func shoot_weapon(delta):		
	if Input.is_action_pressed("shoot"):
		if !weapon.can_shoot: return
		bullet_sound.play()
		weapon.fire()
# Player Health Handlers

func take_damage(damage_received):
	if !player_dodging:
		
		show_damage_card(damage_received)
		player_hp -= damage_received
		damage_audio.play()
		
	if player_hp<=0:
		player_hp = 0
		
		player_die()
	
func show_damage_card(damage):
	var damage_card_instance = damage_amount_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(damage)
	add_child(damage_card_instance)
	damage_card_instance.find_child("AnimationPlayer").play("show_damage")
	
func heal(amount_healed,amount_rhealed, source_text):
	var final_heal: float = ((player_max_hp/100)*amount_healed)*player_heal_mod
	var final_rheal: float = ((player_max_rad/100)*amount_rhealed)*player_rad_mod
	
	player_hp += final_heal
	player_rad -= final_rheal
	
	if player_hp>player_max_hp:
		player_hp=player_max_hp
	
	if player_rad<0:
		player_rad = 0
	
	heal_audio.play()
	
	show_heal_card(final_heal,final_rheal,source_text)
	
func show_heal_card(heal,rheal,source_text):
	var damage_card_instance = heal_amount_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(source_text,": +",heal, " -", rheal, " rads")
	add_child(damage_card_instance)
	damage_card_instance.find_child("AnimationPlayer").play("show_damage")
	
func player_die():
	if is_dead:return
	GM.show_game_over()
	is_dead = true
	var death_instance = player_death_prefab.instantiate()
	death_instance.position = position
	player_sprite.visible=false
	weapon.visible=false
	get_parent().add_child(death_instance)
	GM.is_game_over = true
	GM.player_died = true

#level handlers

func gain_xp(xp_gain):
	player_xp += xp_gain*xp_modifier
	
func process_level():
	if player_level==player_level_cap: 
		ui.xp_bar.tint_progress = Color(0.169, 0.169, 0.169)
		return
	if player_xp >= player_max_xp:
		PM.level_up()
func process_rad():
	if player_rad >= player_max_rad:
		player_die()
	
func get_junk(junk_amount):
	
	junk_audio.play()
	junk_total += junk_amount
	
func gain_radiation(rad_gain):
	player_rad += rad_gain*player_rad_mod
