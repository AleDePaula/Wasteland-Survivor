class_name Player
extends CharacterBody2D

#preloads
var GM = GameManager

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

@export_category("PREFABS")
@export var bullet_prefab: PackedScene
@export var weapon_prefab: PackedScene
@export var dodge_prefab: PackedScene
@export var player_death_prefab: PackedScene
@export var level_up_card: PackedScene
@export var damage_amount_card: PackedScene
@export var heal_amount_card: PackedScene

@export_category("PLAYER STATS")
@export var player_max_health: float
@export var player_health: float
@export var player_heal_modifier:int
@export var player_max_xp: int
@export var player_xp: int
@export var player_level: int
@export var player_level_cap: int
@export var player_speed: float
@export var player_damage_modifier: float
@export var player_shoot_cooldown: float
@export var player_pierce: int
@export var player_dodge_cooldown: float
@export var player_dodge_speed: float
@export var player_dodge_lenght: float
@export var player_max_magic_possesed: int
@export var player_magic_modifier: float = 1

#variables for movement
var input_vector: Vector2 = Vector2(0,0)
var speed: float
var is_moving: bool
var action: String
var looking_side: String
var is_dead: bool

#weapon
var shoot_cooldown_counter: float = 0
var weapon_instance: Node2D
var muzzle_position_global: Vector2 
var muzzle_position_local: Vector2
var turn_to: float
var mouse_inside_player_area: bool = false

#dodge cooldowns
var player_dodging: bool
var dodge_cooldown_counter: float

#UI variables
var hp_bar = GM.game_ui.find_child("HPBar")
var xp_bar = GM.game_ui.find_child("XPBar")
var dodge_bar = GM.game_ui.find_child("DodgeBar")
var level_label = GM.game_ui.find_child("LevelShowLabel")
var junk_label = GM.game_ui.find_child("JunkLabel")
var HPcounter = GM.game_ui.find_child("HPLabel")
var XPcounter = GM.game_ui.find_child("XPLabel")
#Junk variables
var junk_total: int = 0

#magic variables
var spellbook: Array
var spell_scene: Area2D
var rotten_aura: String = "res://scenes/rotten_aura.tscn"

#level variables
var level_upgrades: Array = [
	"speed_up","dodge_up","damage_up","shoot_up",
	"hp_up", "heal_up","pierce_up", "rotten_aura_area_up",
	"rotten_aura_dam_up"]
var level_up_arguments: Array
var xp_modifier: float = 1.0

#misc variable
var mouse_enable: bool

######################FUNCTIONS#######################
##NATIVE FUNCTIONS

func _ready():
	game_start()
	
func _process(delta):
	GM.player_position = position
	GM.player_magic_modifier = player_magic_modifier
	muzzle_position_global = weapon_instance.muzzle_position_global
	muzzle_position_local = weapon_instance.muzzle_position_local	
	
	dodge_bar.value = clamp(dodge_cooldown_counter,0,2)*-1
	
	#handle XP
	process_level()
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
	shoot_cooldown_counter-=delta

func game_start():
	
	GM.player = self
	mouse_enable = true
	is_dead = false
	speed = player_speed
	is_moving=false
	level_label.text = "Level:%3d"%[player_level]
	
	junk_label.text = str(junk_total)
	
	weapon_instance = weapon_prefab.instantiate()
	add_child(weapon_instance)
	
	init_health_bar()
	init_dodge_bar()
	init_xp_bar()
	
	HPcounter.text = str(player_health,"/",player_max_health)
	XPcounter.text = str(player_xp,"/",player_max_xp)
	
func move_player()->void:
	var target_velocity = input_vector
	
	velocity = lerp(velocity, target_velocity, 1)
	velocity = velocity.normalized()*speed*10
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
	if dodge_cooldown_counter<=0&&is_moving:
		dodge()
	speed = player_dodge_speed if is_dodging() else player_speed
	player_dodging = true if is_dodging() else false
func init_dodge_bar():
	dodge_bar.min_value = player_dodge_cooldown*-1
	dodge_bar.value = clamp(dodge_cooldown_counter,0,2)*-1
	
func dodge():
	if Input.is_action_just_pressed("dodge"):
		dodge_sound.play(0.1)
		dodge_cooldown_counter=player_dodge_cooldown
		dodge_bar.value = clamp(dodge_cooldown_counter,0,2)
		
		var dodge_animation = dodge_prefab.instantiate()
		dodge_animation.position = position
		dodge_animation.flip_h = player_sprite.flip_h
		get_parent().add_child(dodge_animation)
		
		dodge_timer.start(player_dodge_lenght)
		dodge_timer.wait_time = player_dodge_lenght

func is_dodging():
	return !dodge_timer.is_stopped()
	
#WEAPON Handlers
func shoot_weapon(delta):		
	if Input.is_action_pressed("shoot"):
		if shoot_cooldown_counter>0: return
		weapon_instance.animation.play("shoot")
		shoot_cooldown_counter=player_shoot_cooldown
		fire()
		
func move_weapon():
	
	var RStick_input_vector = Input.get_vector("aim_left","aim_right","aim_up","aim_down")	
		
	if !mouse_enable:
	
		if RStick_input_vector:
			
			var muzzle_angle = RStick_input_vector.angle()
			weapon_instance.path.progress_ratio = ((muzzle_angle/PI)+1)/2
			turn_to = muzzle_angle
					
			if RStick_input_vector.x<0:
				weapon_instance.muzzle.position.y = 1
				weapon_instance.sprite.flip_v=true
			else:
				weapon_instance.muzzle.position.y = -1
				weapon_instance.sprite.flip_v=false	
			
	else:
		if !mouse_inside_player_area:
			var mouse_position = get_local_mouse_position()
			var angle: float = mouse_position.angle()/PI
			var final_angle = (angle+1)/2
			turn_to = mouse_position.angle()
			weapon_instance.path.progress_ratio=final_angle
				
			if final_angle>0 && final_angle<0.25:
				weapon_instance.muzzle.position.y = 1
				weapon_instance.sprite.flip_v=true
			if final_angle>=0.25 && final_angle<=0.75:
				weapon_instance.muzzle.position.y = -1
				weapon_instance.sprite.flip_v=false
			if final_angle>0.75:
				weapon_instance.muzzle.position.y = 1
				weapon_instance.sprite.flip_v=true
			
			weapon_instance.sprite.look_at(get_global_mouse_position())

func _on_hit_box_mouse_entered():
	mouse_inside_player_area = true
	
func _on_hit_box_mouse_exited():
	mouse_inside_player_area=false
	
func fire():
		var direction = (weapon_instance.muzzle_position_global - global_position).normalized()
		bullet_sound.play()
		var bullet_instance = bullet_prefab.instantiate()
		bullet_instance.bullet_damage*= player_damage_modifier
		bullet_instance.bullet_pierce += player_pierce
		bullet_instance.position = weapon_instance.muzzle_position_global
		bullet_instance.rotation = direction.angle()
		bullet_instance.direction = direction
		get_tree().current_scene.add_child(bullet_instance)
		
# Player Health Handlers
func init_health_bar():
	player_health = player_max_health
	hp_bar.max_value = player_max_health
	hp_bar.value = player_health
	
func take_damage(damage_received):
	if !player_dodging:
		
		show_damage_card(damage_received)
		player_health -= damage_received
		
	if player_health<=0:
		player_health = 0
		player_die()

	damage_audio.play()
	hp_bar.value = player_health
	HPcounter.text = str(player_health,"/",player_max_health)
	
func show_damage_card(damage):
	var damage_card_instance = damage_amount_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(damage)
	add_child(damage_card_instance)
	damage_card_instance.find_child("AnimationPlayer").play("show_damage")
	
func heal(amount_healed):
	var final_heal = ((player_max_health/100)*amount_healed)*player_heal_modifier
	player_health += final_heal
	if player_health>player_max_health:
		player_health=player_max_health
	
	heal_audio.play()
	
	hp_bar.value = player_health
	HPcounter.text = str(player_health,"/",player_max_health)
	show_heal_card(final_heal)
	
func show_heal_card(heal):
	var damage_card_instance = heal_amount_card.instantiate()
	var damage_card_label = damage_card_instance.find_child("DamageText")
	damage_card_label.text = str(heal)
	add_child(damage_card_instance)
	damage_card_instance.find_child("AnimationPlayer").play("show_damage")

func player_die():	
	if is_dead:return
	is_dead = true
	player_sprite.visible=false
	weapon_instance.visible=false
	var death_instance = player_death_prefab.instantiate()
	death_instance.position = position
	get_parent().add_child(death_instance)
	GM.is_game_over = true
	GM.player_died = true
	
#Magic Handlers
func add_magic_to_spellbook(new_magic):
	spellbook.push_back(new_magic)	
	load_magic(spellbook.back())
	
func load_magic(magic):
	var magic_prefab : PackedScene = load(magic)
	var magic_instance = magic_prefab.instantiate()
	spell_scene=magic_instance
	add_child(magic_instance, true)
	
#level handlers
func init_xp_bar():
	xp_bar.max_value = player_max_xp
	xp_bar.value = player_xp

func process_level():
	if player_level==player_level_cap: 
		xp_bar.tint_progress = Color(0.169, 0.169, 0.169)
		return
	
	xp_bar.value = player_xp
	
	if player_xp >= player_max_xp:
		level_up()
		var level_card_instance = level_up_card.instantiate()
		var level_card_label = level_card_instance.find_child("LevelText")
		level_card_label.text = "LEVEL UP"
		add_child(level_card_instance)
		level_card_instance.find_child("AnimationPlayer").play("show_levelup")
	
func gain_xp(xp_gain):
	player_xp += xp_gain*xp_modifier
	XPcounter.text = str(player_xp,"/",player_max_xp)
	
			
func level_up():
	player_level+=1
	var new_level_xp = player_level*10
	player_max_xp = new_level_xp
	player_xp= new_level_xp-player_xp
	xp_bar.max_value = player_max_xp
	xp_bar.value = player_xp
	level_label.text = "Level:%2d"%[player_level]
	HPcounter.text = str(player_health,"/",player_max_health)
	XPcounter.text = str(player_xp,"/",player_max_xp)
	
	call(level_upgrades[randi_range(0,8)])
	if player_level==7:
		add_magic_to_spellbook(rotten_aura)
		show_stat_up_card("ROTTEN AURA")
	
func speed_up():
	player_speed+=1	
	show_stat_up_card("SPEED++")
	
func damage_up():
	player_damage_modifier +=0.2
	show_stat_up_card("DAMAGE++")
	
func dodge_up():
	player_dodge_cooldown -= 0.3
	dodge_bar.min_value = player_dodge_cooldown*-1
	show_stat_up_card("DODGE TIME--")
	
func hp_up():
	player_max_health += 20
	hp_bar.max_value = player_max_health
	HPcounter.text = str(player_health,"/",player_max_health)
	show_stat_up_card("HP UP++")
	
func heal_up():
	player_heal_modifier += 0.2
	show_stat_up_card("COKE HEAL++")
	
func shoot_up():
	player_shoot_cooldown -= 0.1
	show_stat_up_card("SHOOT SPEED++")
	
func pierce_up():
	player_pierce += 1
	show_stat_up_card("BULLETS PIERCE++")

func rotten_aura_area_up():
	var aura = spell_scene
	if is_instance_valid(aura):
		aura.scale+=Vector2(0.2,0.2)
		show_stat_up_card("AURA SIZE++")
	else:
		call(level_upgrades[randi_range(0,6)])
		
func rotten_aura_dam_up():
	var aura = spell_scene
	if is_instance_valid(aura):
		aura.base_area_damage+=1
		show_stat_up_card("AURA DAM++")
	else:
		call(level_upgrades[randi_range(0,6)])
		
func blank_stat_up():
	pass
	
func show_stat_up_card(statup):
	var level_card_instance = level_up_card.instantiate()
	var level_card_label = level_card_instance.find_child("LevelText")
	level_card_label.text = statup
	add_child(level_card_instance)
	level_card_instance.find_child("AnimationPlayer").play("show_stats")
	
func get_junk(junk_amount):
	
	junk_audio.play()
	junk_total += junk_amount
	GM.junk_collected = junk_total
	junk_label.text = str(junk_total)
