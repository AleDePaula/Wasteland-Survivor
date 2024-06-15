extends Node

var GM = GameManager

@export var loot_table : Array[PackedScene]
@export var loot_chances: Array[float]

var loot_modifier = GM.loot_chance_modifier

func _on_enemy_drop_loot():
	get_loot()
			

func get_loot():
	var max_chance: float = 0.0
	for loot in loot_chances:
		max_chance += loot
	
	var dice = randf_range(1,100)
	
	for i in loot_chances.size()-1:
		if dice<=loot_chances[i]:
			create_loot(i)
			break
		
		
func create_loot(modifier):
	if modifier == 0:
		var dropped_loot = loot_table[0].instantiate()
		dropped_loot.position = get_parent().position
		get_tree().current_scene.add_child(dropped_loot)
	
	else:
		var dropped_loot = loot_table[1].instantiate()
		dropped_loot.position = get_parent().position
		dropped_loot.junk_dropped += modifier
		get_tree().current_scene.add_child(dropped_loot)
