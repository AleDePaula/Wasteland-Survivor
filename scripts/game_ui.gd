extends Control

var GM = GameManager
var PM = PlayerManager

@onready var time_timer = $TimeTimer
@onready var time_label = $CanvasLayer/TimePanel/TimeLabel
@onready var junk_label = $CanvasLayer/JunkPanel/JunkLabel
@onready var level_label = $CanvasLayer/LevelPanel/LevelShowLabel
@onready var hp_bar = $CanvasLayer/HPXPPanel/HPBar
@onready var hp_label = $CanvasLayer/HPXPPanel/HPLabel
@onready var xp_bar = $CanvasLayer/HPXPPanel/XPBar
@onready var xp_label = $CanvasLayer/HPXPPanel/XPLabel
@onready var dodge_bar = $CanvasLayer/HPXPPanel/DodgeBar
@onready var rad_bar = $CanvasLayer/RadPanel/RadBar

var time_elapsed_in_seconds=0

var player: Player

func _ready():
	player = PM.player
	time_timer.wait_time=1
	junk_label.text = str(0)
	
	refresh_ui("level")
	refresh_ui("HP")
	refresh_ui("XP")
	refresh_ui("rad")

func _process(delta):
	refresh_ui("HP")
	refresh_ui("XP")
	refresh_ui("level")
	refresh_ui("dodgebar")
	refresh_ui("Junk")
	refresh_ui("rad")

func _on_time_timer_timeout():
	time_elapsed_in_seconds+=1
	var seconds: int = time_elapsed_in_seconds %60
	var minutes: int = time_elapsed_in_seconds/60
	
	time_label.text = "%02d:%02d"%[minutes,seconds]

func refresh_ui(stat):
	if !GM.is_game_over:
		match stat:
			"dodgebar":
				dodge_bar.max_value = player.player_dodge_cooldown
				dodge_bar.value = player.dodge_cooldown_counter
			"junk":
				junk_label.text = str(player.junk_total)
			"HP":
				hp_bar.max_value = player.player_max_hp
				hp_bar.value = player.player_hp
				hp_label.text = str(player.player_hp,"/",player.player_max_hp)
			"XP":
				xp_bar.max_value = player.player_max_xp
				xp_bar.value = player.player_xp
				xp_label.text = str(player.player_xp,"/",player.player_max_xp)
			"level":
				level_label.text = "Level: %03d"% [player.player_level]
			"rad":
				rad_bar.max_value = player.player_max_rad
				rad_bar.value = player.player_rad
