extends Node

var GM = GameManager
var SM = StageManager

@export var loot_table : Array[PackedScene]
@export var loot_chances: Array[float]

var loot_modifier = SM.loot_chance_modifier

func _on_enemy_drop_loot():
	get_loot()

func get_loot():
	var max_chance: float = 0.0
	for loot in loot_chances:
		max_chance += loot
	
	var dice = randf_range(1,100) 
	for i in loot_chances.size():
		if dice<=loot_chances[i]:
			create_loot(i)
			break
		
func create_loot(modifier):
	var random_pos = Vector2(GM.roll_float(-20,20),GM.roll_float(-20,20))
	var dropped_loot = loot_table[modifier].instantiate()
	dropped_loot.position = get_parent().position+random_pos
	get_tree().current_scene.add_child(dropped_loot)
	
	
