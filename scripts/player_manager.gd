extends Node

var GM = GameManager
var SM = StageManager
var EM = EnemyManager

@export_category("PLAYER SCENE")
@export var player_scenes: Array[PackedScene]

@export_category("PLAYER WEAPONS")

@export var main_weapons: Array[PackedScene]
@export var companions: Array[PackedScene]
@export var bullets: Array[PackedScene]
@export var mutations: Array[PackedScene]

@export_category("STARTING LEVEL OPTIONS")
@export var starting_xp: int
@export var xp_pool: int
@export var starting_level: int
@export var level_cap: int

@export_category("PLAYER STATS MODIFIERS")
@export var player_max_health_mod: float
@export var player_heal_mod_mod:int
@export var player_speed_mod: int
@export var player_dodge_speed_mod: int
@export var player_dodge_cooldown_mod: int #in %, bigger is better
@export var player_dodge_lenght_mod: int 
@export var player_damage_mod: int
@export var player_max_stat_mutations: int
@export var player_max_attack_mutations: int
@export var player_max_stat_mutations_per_level: int
@export var player_max_skip_mutation: int
@export var player_max_reroll_mutation: int
@export var player_mutation_level_interval: int
var player_mutation_level_interval_counter: int
var next_level_attack_mutation: int
@export var player_max_rad_mod: int
@export var player_rad_mod: float

@export_category("PLAYER WEAPON MODIFIERS")
@export var player_main_damage_modifier: float
@export var player_main_shoot_cooldown: float #in %, bigger is better
@export var player_main_pierce: int
@export var player_main_bullet_speed: int
@export var player_companion_damage_modifier: float
@export var player_companion_cooldown_modifier: float #in %, bigger is better
@export var player_companion_area_modifier: float

@export_category("PLAYER MUTATION MODIFIERS")
@export var player_max_mutations_per_level: int
@export var player_mutation_damage_mod: float
@export var player_mutation_speed_mod: float
@export var player_mutation_area_mod: float
@export var player_mutation_cooldown_mod: float #in %, bigger is better
@export var player_mutation_projectiles_mod: float
@export var player_mutation_pierce_mod: float
@export var player_mutation_timer_mod: float

var is_player_dead: bool = false

var player = Player
var weapon: Node2D

var selected_player: int
var selected_weapon: int

func add_player_to_scene():
	
	var player_instance = player_scenes[selected_player].instantiate()	
	player_instance.position = GM.root_scene.find_child("PlayerStart").position
	GM.root_scene.add_child(player_instance)
	
	GM.player = player_instance
	player = GM.player
	
	set_player()

func set_player():
	add_weapon_to_player()
	set_bullet()
	set_player_final_stats()
	GM.game_ui.player = player
	player.player_xp = starting_xp
	player.player_max_xp = xp_pool
	player.player_level = starting_level
	player.player_level_cap = level_cap
	
func add_weapon_to_player():
	var weapon_instance = main_weapons[selected_weapon].instantiate()
	player.weapon = weapon_instance
	weapon = weapon_instance
	weapon.gun_shoot_cooldown = (weapon.gun_shoot_cooldown-(player_companion_cooldown_modifier+player.player_base_shoot_cooldown))/10
	player.add_child(weapon_instance)

func set_bullet():
	player.bullet = bullets[0]
	
func set_player_final_stats():
	#player Stats
	player.player_max_hp = player.player_base_max_health*player_max_health_mod
	player.player_hp = player.player_max_hp
	player.player_heal_mod = player.player_base_heal_mod*player_heal_mod_mod
	player.player_speed = player.player_base_speed*player_speed_mod
	player.player_max_rad = player.player_base_max_rad*player_max_rad_mod
	player.player_rad_mod = player.player_base_rad_mod*player_rad_mod
	
	#weapon
	player.player_weapon_damage = player.player_base_weapon_damage*player_main_shoot_cooldown
	player.player_weapon_bullet_speed = player.player_base_weapon_bullet_speed*(weapon.bullet_speed*player_main_bullet_speed)
	player.player_pierce += (player.player_base_weapon_pierce+player_main_pierce)
	
	#companion
	#mutation
	
	player.player_skip_count = player_max_skip_mutation
	player.player_reroll_count = player_max_reroll_mutation
	player.player_max_stat_mutations = player.player_base_max_stat_mutations_mod + player_max_stat_mutations
	player.player_max_attack_mutations = player.player_base_max_attack_mutations_mod + player_max_attack_mutations
	player.player_mutation_damage_mod = player.player_base_mutation_damage_mod * player_mutation_damage_mod
	player.player_mutation_speed_mod = player.player_base_mutation_speed_mod * player_mutation_speed_mod
	player.player_mutation_area_mod = player.player_base_mutation_area_mod * player_mutation_area_mod
	player.player_mutation_cooldown_mod = player.player_base_mutation_cooldown_mod - player_mutation_cooldown_mod
	player.player_mutation_projectiles_mod = player.player_base_mutation_projectiles_mod + player_mutation_projectiles_mod
	player.player_mutation_pierce_mod = player.player_base_mutation_pierce_mod + player_mutation_pierce_mod
	player.player_mutation_timer_mod = player.player_base_mutation_timer_mod * player_mutation_timer_mod
	
	next_level_attack_mutation = player_mutation_level_interval
		
	
	#dodge
	player.player_dodge_cooldown = (player.player_base_dodge_cooldown*player_dodge_cooldown_mod)/10
	player.player_dodge_speed = player.player_base_dodge_speed*player_dodge_speed_mod
	player.player_dodge_lenght = (player.player_base_dodge_lenght*player_dodge_lenght_mod)/10
	

func level_up():
	player.player_level+=1
	var new_level_xp = player.player_level*10
	player.player_xp = player.player_xp - player.player_max_xp
	player.player_max_xp = new_level_xp	
	
	call_levelup_menu()
	
func call_levelup_menu():
	var level_up_menu_instance = GM.level_up_menu.instantiate()
	var level_up_dict: Array 
	var player_owned_mutations: Array
	var this_levelups: Array = []
	var max_mutations: int
	var maxed_mutations: int
	var max_mut_per_level: int
	
	if player_max_mutations_per_level>4:
		player_max_mutations_per_level = 4
		
	if next_level_attack_mutation <= player.player_level:
		next_level_attack_mutation += player_mutation_level_interval
		max_mutations = player_max_attack_mutations
		level_up_dict = GM.level_up_full_dict.attack_mutations.duplicate(true)
		player_owned_mutations = player.mutation_book.duplicate(true)
		max_mut_per_level = player_max_mutations_per_level
		next_level_attack_mutation=player.player_level+player_mutation_level_interval
		
	else:
		max_mutations = player_max_stat_mutations
		level_up_dict = GM.level_up_full_dict.stat_mutations.duplicate(true)
		player_owned_mutations = player.player_stats_mutations.duplicate(true)
		max_mut_per_level = player_max_mutations_per_level
	
	var filtered_maxedout_mutations = player_owned_mutations.duplicate(true)
	var filtered_level_up_dict = level_up_dict.duplicate(true)
	var filtered_player_owned_mutations = player_owned_mutations.duplicate(true)
	
	filtered_maxedout_mutations = filtered_maxedout_mutations.filter(func(mutation): return mutation["Level"]>=mutation["Max Level"]) #maxed mutations
	filtered_maxedout_mutations = filtered_maxedout_mutations.map(func(mutation): 
		mutation["Level"]=1 
		return mutation) #Deixa todos os leveis = 1 para comparar
	filtered_level_up_dict = filtered_level_up_dict.filter(func(mutation): return !filtered_maxedout_mutations.has(mutation)) #level up dict without mutations
	filtered_player_owned_mutations = filtered_player_owned_mutations.filter(func(mutation): return mutation["Level"]<mutation["Max Level"]) #sem max level
	##Verificar se os books estão cheios:
	
	if max_mutations <= player_owned_mutations.size():
		if filtered_maxedout_mutations.size() == max_mutations:
			
			player.heal(20,"Max Level Ups")
			return
		
		else: 
			if filtered_player_owned_mutations.size()<=max_mut_per_level:
				for i in filtered_player_owned_mutations:
					this_levelups.push_back(i)
			else:
				if max_mut_per_level>=filtered_player_owned_mutations.size():
					max_mut_per_level = filtered_player_owned_mutations.size()
				
				while this_levelups.size() < max_mut_per_level:
					this_levelups.push_back(create_buttons(filtered_player_owned_mutations, this_levelups, max_mutations))
				
	else:
		if max_mut_per_level>=filtered_level_up_dict.size():
			max_mut_per_level = filtered_level_up_dict.size()
		
		while this_levelups.size() < max_mut_per_level:
			this_levelups.push_back(create_buttons(filtered_level_up_dict, this_levelups, max_mutations))
	
	GM.pause_unpause()
	GM.is_game_over = true
	level_up_menu_instance.call_buttons(this_levelups)
	get_tree().current_scene.add_child(level_up_menu_instance)
	
func create_buttons(level_up_dict, this_levelups, max_mutations):
	var filtered_level_up_dict:Array
	var rolled_levelup:Dictionary
	
	if this_levelups.size()==0:
		rolled_levelup = level_up_dict[GM.roll_int(0, level_up_dict.size()-1)]
	else:
		filtered_level_up_dict = level_up_dict.filter(func(mutation): return !this_levelups.has(mutation))
		rolled_levelup = filtered_level_up_dict[GM.roll_int(0, filtered_level_up_dict.size()-1)]
	
	return rolled_levelup

func add_stat(levelup):
	player_mutation_level_interval_counter+=1
	var player_mutations = player.player_stats_mutations
	var player_mutation_index: int = 0
	for i in player_mutations.size():
		
		if player_mutations[i]["Name"] == levelup["Name"]:

			player_mutation_index = i+1
			
	if player_mutation_index>0:
		player_mutations[player_mutation_index-1]["Level"]+=1
	else:
		player_mutations.push_back(levelup)
	
	var stat = levelup["Statup"]
	var modifier = levelup["Modifier"]
	match stat:
		"HP":
			player_max_health_mod +=modifier
			player.player_max_hp = player.player_base_max_health*player_max_health_mod
		"Heal Mod":
			player_heal_mod_mod += modifier
			player.player_heal_mod = player.player_base_heal_mod*player_heal_mod_mod
		"Dodge Distance":
			player_dodge_speed_mod += modifier
			player.player_dodge_speed = player.player_base_dodge_speed*player_dodge_speed_mod
		"Dodge Cooldown":
			player_dodge_cooldown_mod+=modifier
			player.player_dodge_cooldown = (player.player_base_dodge_cooldown*player_dodge_cooldown_mod)/10
		"Weapon Damage":
			player_main_damage_modifier+=modifier
			player.player_weapon_damage = player.player_base_weapon_damage*player_main_shoot_cooldown
		"Weapon Pierce":
			player_main_pierce+=modifier
			player.player_pierce += (player.player_base_weapon_pierce+player_main_pierce)
		"Mutation Damage":
			player_mutation_damage_mod+=modifier
			player.player_mutation_damage_mod = player.player_base_mutation_damage_mod * player_mutation_damage_mod
		"Mutation Area":
			player_mutation_area_mod+=modifier
			player.player_mutation_area_mod = player.player_base_mutation_area_mod * player_mutation_area_mod
		"Mutation Pierce":
			player_mutation_pierce_mod+=modifier
			player.player_mutation_pierce_mod = player.player_base_mutation_pierce_mod + player_mutation_pierce_mod

func add_mutation(levelup):
	player_mutation_level_interval_counter=0
	
	var player_mutations = player.mutation_book
	var player_mutation_index: int = 0
	for i in player_mutations.size():
		
		if player_mutations[i]["Name"] == levelup["Name"]:

			player_mutation_index = i+1
			
	if player_mutation_index>0:
		change_mutation(levelup)
		
	else:
		player_mutations.push_back(levelup)
		var mutation_prefab = load(levelup["Prefab"]).instantiate()
		player.add_child(mutation_prefab, true)
		player_mutation_level_interval_counter = 0

func change_mutation(levelup):
	var picked_mutation: Dictionary

	for mutation in player.mutation_book:
		if mutation["Name"]==levelup["Name"]:
			picked_mutation = mutation
	
	var target_mutation = player.mutation_book[player.mutation_book.find(picked_mutation)]
	var target_mutation_scene = player.get_node(target_mutation["Node Name"])
	
	var stat = target_mutation["Statup"][target_mutation["Level"]-1]
	var modifier = target_mutation["Modifier"][target_mutation["Level"]-1]
	match stat:
		"Size":
			target_mutation_scene.scale+=Vector2(modifier,modifier)
			
		"Damage":
			player_mutation_damage_mod+=modifier
			
		"Cooldown":
			player_mutation_cooldown_mod+=modifier
			
		"Projectiles":
			player_mutation_projectiles_mod+=modifier
	
	player_mutation_level_interval_counter = 0
	picked_mutation["Level"]+=1
	
	
