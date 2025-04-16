extends Area2D

var radiation_value: int
@onready var rad_sprite = $RadiationSprite

func _ready():
	create_rad()

func _on_body_entered(body):
	body.gain_xp(radiation_value)
	body.gain_radiation(radiation_value)
	queue_free()
	
func create_rad():
	if radiation_value >=1 and radiation_value<=4:
		rad_sprite.frame_coords=Vector2(22,1)
		match radiation_value:
			1:self_modulate=Color(0.349, 0.663, 0.443)
			2:self_modulate=Color(0.256, 0.511, 0.334)
			3:self_modulate=Color(0.256, 0.511, 0.334)
			4:self_modulate=Color(0.135, 0.296, 0.185)
	elif radiation_value >=5 and radiation_value<=8:
		rad_sprite.frame_coords=Vector2(21,1)
		match radiation_value:
			5:self_modulate=Color(0.349, 0.663, 0.443)
			6:self_modulate=Color(0.256, 0.511, 0.334)
			7:self_modulate=Color(0.256, 0.511, 0.334)
			8:self_modulate=Color(0.135, 0.296, 0.185)
	elif radiation_value >=9 and radiation_value<=12:
		rad_sprite.frame_coords=Vector2(20,1)
		match radiation_value:
			9:self_modulate=Color(0.349, 0.663, 0.443)
			10:self_modulate=Color(0.256, 0.511, 0.334)
			11:self_modulate=Color(0.256, 0.511, 0.334)
			12:self_modulate=Color(0.135, 0.296, 0.185)
