extends CanvasLayer

var GM = GameManager
var PM = PlayerManager

@onready var skip_button = $MenuPanel/SkipButton
@onready var reroll_button = $MenuPanel/RerollButton

var player = PM.player
var is_att_mut: bool

const level_up_button = preload("res://scenes/game_ui_scene/level_up_button.tscn")

func _ready():
	for i in PM.player_max_mutations_per_level:
		find_child("NeedResearch"+str(i+1)).text = "No mutation to put here!"
	if PM.player_max_skip_mutation==0:
		skip_button.visible=false
	if PM.player_max_reroll_mutation==0:
		reroll_button.visible=false
	if player.player_skip_count==0:
		skip_button.disabled = true
	if player.player_reroll_count==0:
		reroll_button.disabled = true

func call_buttons(levelups:Array):
	for i in levelups.size():
		
		var button_instance = level_up_button.instantiate()
		var marker = find_child("LevelUpButtonPosition"+str(i+1))
		button_instance.position = marker.position
		button_instance.set_button(levelups[i])
		find_child("NeedResearch"+str(i+1)).visible = false
		$MenuPanel.add_child(button_instance)
		
func _on_reroll_button_mouse_entered():
	reroll_button.grab_focus()

func _on_reroll_button_mouse_exited():
	reroll_button.release_focus()
	
func _on_reroll_button_pressed():
	player.player_reroll_count-=1
	PM.player_mutation_level_interval_counter-=1
	queue_free()
	PM.call_levelup_menu()

func _on_skip_button_mouse_entered():
	skip_button.grab_focus()

func _on_skip_button_mouse_exited():
	skip_button.release_focus()
		
func _on_skip_button_pressed():
	
	GM.is_game_over = false
	player.player_skip_count-=1
	GM.pause_unpause()
	if !is_att_mut:
		player.heal(20,10,"Level Skip")
		player.gain_xp(player.player_max_xp*0.20)
	queue_free()
