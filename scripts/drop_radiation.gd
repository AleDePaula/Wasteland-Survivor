extends Node
var GM = GameManager

@export var radiation_prefab: PackedScene

func _on_enemy_drop_radiation():
	drop_radiation(get_parent().enemy_xp)

func drop_radiation(modifier):
	var random_pos = Vector2(GM.roll_float(-5,5),GM.roll_float(-5,5))
	var dropped_radiation = radiation_prefab.instantiate()
	dropped_radiation.radiation_value = modifier
	dropped_radiation.position = get_parent().position+random_pos
	get_tree().current_scene.add_child(dropped_radiation)
