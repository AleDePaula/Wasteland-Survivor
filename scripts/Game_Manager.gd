extends Node

var PM = PlayerManager
var SM = StageManager
var EM = EnemyManager

#STAGE BUILDER VAR
var root_scene : Node
var new_stage: Node
var camera: Camera2D

#PLAYER MODIFIERS
var player: Player
var player_magic_modifier: float = 1


const LevelUpDict = preload("res://scripts/Dictionaries/level_up_dict.gd")
const level_up_menu = preload("res://scenes/game_ui_scene/level_up_menu.tscn")

var level_up_full_dict = LevelUpDict.new()

#WEAPON MODIFIERS
var gun: Gun

#SCORE
var enemies_killed: int = 0
var junk_collected: int = 0

var is_game_over: bool = true
var player_died: bool = false
var is_paused: bool = false

const UI_prefab : String = "res://scenes/game_ui_scene/game_ui.tscn"

var mouse_enable: bool
var mouse_global: Vector2
var player_position: Vector2
var muzzle_position: Vector2

var crosshair: Resource = load("res://assets/crosshair/green crosshair.png")

var game_ui: Control

func _input(event):
	if is_game_over == false:
		if event.is_action_pressed("pause_menu"):
			var pause_scene = preload("res://scenes/game_ui_scene/pause_menu.tscn")
			var pause_instance = pause_scene.instantiate()
			pause_unpause()
			if is_paused:
				get_tree().current_scene.add_child(pause_instance, true)
			else:
				get_tree().current_scene.get_node("PauseMenu").queue_free()
			

func _process(delta):
	if !player: return
	else: camera.position = player.position
	
func load_staged_scenes():
	
	add_ui_to_scene()
	PM.add_player_to_scene()
	add_camera_to_scene()
	change_mouse_pointer()

func add_ui_to_scene():
	var UI_instance = preload(UI_prefab).instantiate()
	game_ui = UI_instance
	root_scene.add_child(UI_instance)
	
func add_camera_to_scene():
	
	var new_camera = Camera2D.new()
	camera = new_camera
	camera.zoom = Vector2(3,3)
	camera.position = player.position
	camera.position_smoothing_enabled = true
	
	camera.limit_top = root_scene.find_child("MaxCameraTop").position.y
	camera.limit_bottom = root_scene.find_child("MaxCameraBottom").position.y
	camera.limit_left = root_scene.find_child("MaxCameraLeft").position.x
	camera.limit_right = root_scene.find_child("MaxCameraRight").position.x
	root_scene.add_child(camera, true)

func change_mouse_pointer():
	Input.set_custom_mouse_cursor(crosshair)
	
func load_pause_menu(is_paused):
	if is_paused:
		var pause_scene = preload("res://scenes/game_ui_scene/pause_menu.tscn")
		var pause_instance = pause_scene.instantiate()
		root_scene.add_child(pause_instance, true)
		
func show_game_over():
	print(player.junk_total)
	#var junk_final = PM.junk_collected
	game_ui.time_timer.stop()
	var game_over_scene = preload("res://scenes/game_ui_scene/game_over.tscn")
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.find_child("EnemiesKilledCounter").text = str(enemies_killed)
	game_over_instance.find_child("JunkCollectedCounter").text = str(player.junk_total)
	game_over_instance.find_child("TimeSurvivedCounter").text = game_ui.time_label.text
	root_scene.add_child(game_over_instance,true)
	
func pause_unpause():
	if !is_game_over:
			is_paused = !is_paused
	if is_paused:
		get_tree().paused = is_paused
	else:
		get_tree().paused = is_paused
		
func roll_int(min, max)->int:
	return randi_range(min, max)
func roll_float(min, max)->float:
	return randi_range(min, max)
		
	
