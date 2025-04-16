extends Area2D

var PM = PlayerManager
var GM = GameManager
var EM = EnemyManager

@onready var pustule_sprite = $PustuleSprite
@onready var pustule_size_timer = $PustuleSizeTimer
@onready var pustule_damage_timer = $PustuleDamageTimer
@onready var pustule_spawn_timer = $PustuleSpawnTimer

var player: Player
var final_timer: float
var final_damage_interval: float
var final_damage: float
var final_knockback: float
var final_area: float


func _ready():
	player = PM.player
	pustule_spawn_timer.wait_time = final_timer
	pustule_damage_timer.wait_time = final_damage_interval
	pustule_damage_timer.start()

func _process(delta):
	if !pustule_size_timer.is_stopped():
		set_pustule_size()
		
func set_pustule_size():
	pustule_sprite.scale = Vector2(pustule_size_timer.wait_time-pustule_size_timer.time_left, pustule_size_timer.wait_time-pustule_size_timer.time_left)
	if pustule_sprite.scale < Vector2(final_area*0.1,final_area*0.1):
		pustule_sprite.scale = Vector2(final_area*0.1, final_area*0.1)
		
func _on_pustule_spawn_timer_timeout():
	queue_free()

func _on_pustule_damage_timer_timeout():
	deal_damage()
	pustule_damage_timer.wait_time = final_damage_interval
	pustule_damage_timer.start()

func deal_damage():
	var enemies_in_range = get_overlapping_bodies()
	if !get_overlapping_areas().is_empty():
		for enemy in enemies_in_range:
			enemy.enemy_recieve_damage(final_damage)
			enemy.add_knockback(final_knockback)

func _on_pustule_size_timer_timeout():
	pustule_spawn_timer.start()
