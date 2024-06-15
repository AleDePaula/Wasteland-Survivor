extends Control

var GM = GameManager

@onready var time_timer = $TimeTimer
@onready var time_label = $CanvasLayer/TimePanel/TimeLabel
@onready var junk_label = $CanvasLayer/JunkPanel/JunkLabel
var time_elapsed_in_seconds=0

func _ready():
	time_timer.wait_time=1
	junk_label.text = str(0)

func _on_time_timer_timeout():
	time_elapsed_in_seconds+=1
	var seconds: int = time_elapsed_in_seconds %60
	var minutes: int = time_elapsed_in_seconds/60
	
	time_label.text = "%02d:%02d"%[minutes,seconds]
	
	

	
	
	
	
