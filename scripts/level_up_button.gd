extends Panel

var GM = GameManager
var PM = PlayerManager

var player = PM.player

@onready var button = $LevelUpButton

var button_levelup: Dictionary

func _on_level_up_button_mouse_entered():
	button.grab_focus()

func _on_level_up_button_mouse_exited():
	button.release_focus()

func _on_level_up_button_pressed():
	GM.is_game_over = false
	PM.call(button_levelup["Function"], button_levelup)
	GM.pause_unpause()
	get_parent().get_parent().queue_free()
	
func set_button(levelup):
	button_levelup = levelup
	$LevelUpName.text = levelup["Name"]
	$LevelUpDescription.text = levelup["Description"]
	$SpriteContainer.texture = load(levelup["Sprite"])
