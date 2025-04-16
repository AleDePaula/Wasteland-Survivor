extends Node
var GM = GameManager
var PM = PlayerManager
var SM = StageManager
var EM = EnemyManager

@onready var play_button = $PlayButton
@onready var exit_button = $ExitButton
@onready var audio = $AudioStreamPlayer
@onready var weapon_list = $WeaponList
@onready var companion_list = $CompanionList
@onready var player_list = $PlayerList

var mouse_enable: bool
var joy_enable:bool = false

func _input(event):
	
	if event is InputEventMouseMotion or event is InputEventKey:
		joy_enable=false
		return
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		if joy_enable:return
		else:
			joy_enable=true
			play_button.grab_focus()		


func _process(delta):
	if player_list.is_anything_selected() and weapon_list.is_anything_selected():
		
		play_button.disabled = false
	else:
		play_button.disabled = true
		
func _ready():
	GM.is_game_over = true
	construct_player_list()
	construct_weapon_list()
	
func construct_player_list():
	for i in PM.player_scenes:
		var player_instance = i.instantiate()
		player_list.add_item(player_instance.char_name,player_instance.char_sprite)
		player_instance.queue_free()
		
func construct_weapon_list():
	for i in PM.main_weapons:
		var weapon_instance = i.instantiate()
		weapon_list.add_item(weapon_instance.gun_name,weapon_instance.find_child("GunSprite").texture)
		weapon_instance.queue_free()

func _on_play_button_pressed():
	
	PM.selected_player = player_list.get_selected_items()[0]
	PM.selected_weapon = weapon_list.get_selected_items()[0]
	GM.is_game_over=false
	GM.player_died = false
	get_tree().change_scene_to_file("res://scenes/stages/infinite_apocalipse/infinite_apocalipse.tscn")
	
func _on_play_button_mouse_entered():	
	if play_button.disabled == false:
		play_button.self_modulate = Color(0.235, 0.235, 0.235)
		audio.play()
		
func _on_play_button_mouse_exited():
	if play_button.disabled == false:
		play_button.self_modulate = Color(1,1,1)
		
func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/choose_mode_menu.tscn")
	
func _on_exit_button_mouse_entered():
	exit_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()

func _on_exit_button_mouse_exited():
	exit_button.self_modulate = Color(1,1,1)
