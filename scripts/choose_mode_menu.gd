extends Node
var GM = GameManager
var PM = PlayerManager
var SM = StageManager
var EM = EnemyManager

@onready var story_mode_button = $StoryModeButton
@onready var infinite_wasteland_button = $InfiniteWastelandButton
@onready var exit_button = $ExitButton

@onready var audio = $AudioStreamPlayer

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
			infinite_wasteland_button.grab_focus()

func _ready():
	GM.is_game_over = true

func _on_infinite_wasteland_button_pressed():
	GM.is_game_over=false
	GM.player_died = false
	get_tree().change_scene_to_file("res://scenes/infinite_apocalypse_menu.tscn")
	
func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_infinite_wasteland_button_mouse_entered():	
	infinite_wasteland_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()

func _on_infinite_wasteland_button_mouse_exited():
	infinite_wasteland_button.self_modulate = Color(1,1,1)

func _on_infinite_wasteland_button_focus_exited():
	infinite_wasteland_button.self_modulate = Color(1,1,1)
	
func _on_infinite_wasteland_button_focus_entered():
	infinite_wasteland_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()
	
func _on_exit_button_mouse_entered():
	exit_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()

func _on_exit_button_mouse_exited():
	exit_button.self_modulate = Color(1,1,1)

func _on_exit_button_focus_entered():
	exit_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()
	
func _on_exit_button_focus_exited():
	exit_button.self_modulate = Color(1,1,1)



	
