extends Node
var GM = GameManager

@onready var play_button = $ButtonPanel/PlayButton
@onready var exit_button = $ButtonPanel/ExitButton
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
			play_button.grab_focus()
		

func _ready():
	GM.is_game_over=true	

func _on_play_button_pressed():
	GM.is_game_over=false
	get_tree().change_scene_to_file("res://scenes/stages/infinite_apocalipse/infinite_apocalipse.tscn")
	
func _on_exit_button_pressed():
	get_tree().quit()

func _on_play_button_mouse_entered():	
	play_button.self_modulate = Color(0.235, 0.235, 0.235)
	audio.play()

func _on_play_button_mouse_exited():
	play_button.self_modulate = Color(1,1,1)

func _on_play_button_focus_exited():
	play_button.self_modulate = Color(1,1,1)
	
func _on_play_button_focus_entered():
	play_button.self_modulate = Color(0.235, 0.235, 0.235)
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


