extends CanvasLayer
@onready var main_menu_button = $MenuPanel/MainMenuButton
@onready var button_sound = $ButtonSound

var GM = GameManager


	
func _input(event):	
	#Enable/Disable Mouse
	if event is InputEventMouseMotion or event is InputEventKey:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	if event is InputEventJoypadMotion or event is InputEventJoypadMotion:
		main_menu_button.grab_focus()
func _on_main_menu_button_mouse_entered():
	main_menu_button.self_modulate = Color(0.235, 0.235, 0.235)
	button_sound.play()

func _on_main_menu_button_mouse_exited():
	main_menu_button.self_modulate = Color(1, 1, 1)
	
func _on_main_menu_button_pressed():
	pass # Replace with function body.
	GM.is_game_over=true
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_main_menu_button_focus_entered():
	main_menu_button.self_modulate = Color(0.235, 0.235, 0.235)
