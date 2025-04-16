extends Resource

var attack_mutations: Array = [
	{
		"Type": "Mutation",
		"Name": "Rotten Aura",
		"Level": 1,
		"Max Level": 2,
		"Description": "Adds a Rotten Aura around the player that deals 1 damage in every 5 second(s) to all enemies inside",
		"Sprite": "res://assets/enemy_explosion/Zombie-Tileset---_0360_Capa-361.png",
		"Prefab": "res://scenes/mutation_scenes/rotten_aura/rotten_aura.tscn" ,
		"Node Name": "RottenAura",
		"Function": "add_mutation",
		"Statup": ["Size", "Damage", "Cooldown", "Size", "Cooldown", "Size", "Damage", "Cooldown", "Size"],
		"Modifier": [0.30, 1, 0.2, 0.30, 0.2, 0.30, 1, 0.2, 0.30]
	},
	{
		"Type": "Mutation",
		"Name": "Toxic Vomit",
		"Level": 1,
		"Max Level": 2,
		"Description": "Spits a toxic vomit in a random direction.",
		"Sprite": "res://assets/enemies/Turret Zombie Vomit Shooting Animation Frames/Zombie-Tileset---_0472_Capa-473.png",
		"Prefab": "res://scenes/mutation_scenes/toxic_vomit/toxic_vomit.tscn" ,
		"Node Name": "ToxicVomit",
		"Function": "add_mutation",
		"Statup": ["Size", "Damage", "Cooldown", "Projectiles", "Size", "Projectiles", "Damage", "Projectiles", "Cooldown"],
		"Modifier": [ 3, 3, 0.2, 1, 3, 1, 3, 1, 0.2]
	},
	{
		"Type": "Mutation",
		"Name": "Bone Spike",
		"Level": 1,
		"Max Level": 2,
		"Description": "Throw a Bone Spike in the colsest enemy. Pierces enemies.",
		"Sprite": "res://assets/enemy_explosion/Zombie-Tileset---_0360_Capa-361.png",
		"Prefab":  "res://scenes/mutation_scenes/bone_spikes/bone_spike.tscn",
		"Node Name": "BoneSpike",
		"Function": "add_mutation",
		"Statup": ["Cooldown", "Damage", "Cooldown", "Size", "Cooldown", "Size", "Damage", "Cooldown", "Size"],
		"Modifier": [0.2, 1, 0.2, 0.30, 0.2, 0.30, 1, 0.2, 0.30]
	},
	{
		"Type": "Mutation",
		"Name": "Giant Stomp",
		"Level": 1,
		"Max Level": 2,
		"Description": "Your leg produce a stomp that deals damage and pushes enemies back.",
		"Sprite": "res://assets/enemies/Turret Zombie Vomit Shooting Animation Frames/Zombie-Tileset---_0472_Capa-473.png",
		"Prefab": "res://scenes/mutation_scenes/giant_stomp/giant_stomp.tscn" ,
		"Node Name": "GiantStomp",
		"Function": "add_mutation",
		"Statup": ["Size", "Damage", "Cooldown", "Projectiles", "Size", "Projectiles", "Damage", "Projectiles", "Cooldown"],
		"Modifier": [ 3, 3, 0.2, 1, 3, 1, 3, 1, 0.2]
	},
	{
		"Type": "Mutation",
		"Name": "Putrid Pustule",
		"Level": 1,
		"Max Level": 2,
		"Description": "Your body starts to drop acid bubbles that burns the enemies that stand on it",
		"Sprite": "res://assets/enemies/Turret Zombie Vomit Shooting Animation Frames/Zombie-Tileset---_0472_Capa-473.png",
		"Prefab": "res://scenes/mutation_scenes/putrid_pustule/putrid_pustule.tscn" ,
		"Node Name": "PutridPustule",
		"Function": "add_mutation",
		"Statup": ["Size", "Damage", "Cooldown", "Projectiles", "Size", "Projectiles", "Damage", "Projectiles", "Cooldown"],
		"Modifier": [ 3, 3, 0.2, 1, 3, 1, 3, 1, 0.2]
	},
	{
		"Type": "Mutation",
		"Name": "Mutant Claw",
		"Level": 1,
		"Max Level": 2,
		"Description": "You have claws that attack quickly. It gets quicker if you are moving and deals double damage if dodging",
		"Sprite": "res://assets/enemies/Turret Zombie Vomit Shooting Animation Frames/Zombie-Tileset---_0472_Capa-473.png",
		"Prefab": "res://scenes/mutation_scenes/putrid_pustule/putrid_pustule.tscn" ,
		"Node Name": "MutantClaws",
		"Function": "add_mutation",
		"Statup": ["Size", "Damage", "Cooldown", "Projectiles", "Size", "Projectiles", "Damage", "Projectiles", "Cooldown"],
		"Modifier": [ 3, 3, 0.2, 1, 3, 1, 3, 1, 0.2]
	}
]

var stat_mutations: Array = [
	{
		"Type": "Stat Mutation",
		"Name": "Toughness",
		"Level": 1,
		"Max Level": 10,
		"Description": "Your body is becoming more resistent. Adds %02d to total HP"%["Modifier"],
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup": "HP",
		"Modifier": 20
	},
	{
		"Type": "Stat Mutation",
		"Name": "Quicker Metabolism",
		"Level": 1,
		"Max Level": 10,
		"Description": "You feel that soda healing your rotten body! Adds %02d  HP"%["Modifier"],
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup": "HP",
		"Modifier": 0.1
	},
	{
		"Type": "Stat Mutation",
		"Name": "Stronger Legs",
		"Level": 1,
		"Max Level": 10,
		"Description": String("You feel your legs getting stronger. Adds %02d to your speed"%["Modifier"]),
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup": "Heal Mod",
		"Modifier": 10
	},
	{
		"Type": "Stat Mutation",
		"Name": "Muscle Explosion",
		"Level": 1,
		"Max Level": 10,
		"Description": "Your muscles are stronger. Adds %02d distance to your dodge"%["Modifier"],
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup": "Dodge Distance",
		"Modifier": 0.5
	},
	{
		"Type": "Stat Mutation",
		"Name": "Quicker Reflexes",
		"Level": 1,
		"Max Level": 10,
		"Description": "MUTANT SENSE! Less %02d % from your dodge cooldown"%["Modifier"],
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup": "Dodge Cooldown",
		"Modifier": 5
	},
	{
		"Type": "Stat Mutation",
		"Name": "Mutant Strenght",
		"Level": 1,
		"Max Level": 10,
		"Description": "Your body is getting more violent reactions to radiation. You add %02d % to your mutation damage"%["Modifier"],
		"Sprite": "res://assets/medkit/medkit.png",
		"Function": "add_stat",
		"Statup":  "Mutation Damage",
		"Modifier": 0.2
	},
]

#@export_category("PLAYER STATS MODIFIERS")
##@export var player_max_health_mod: float
##@export var player_heal_mod_mod:int 
##@export var player_speed_mod: int
##@export var player_dodge_speed_mod: int
##@export var player_dodge_cooldown_mod: int #in %, bigger is better
#@export var player_dodge_lenght_mod: int  #NÃO VOU MUDAR
#@export var player_damage_mod: #REDUNDANTE COM WEAPON DAMAGE
#@export var player_max_rad_mod: int #TO BE DONE
#@export var player_rad_mod: float #TO BE DONE
#
#@export_category("PLAYER WEAPON MODIFIERS")
#@export var player_main_damage_modifier: float
#@export var player_main_shoot_cooldown: float #in %, bigger is better
#@export var player_main_pierce: int
#@export var player_main_bullet_speed: int


#@export var player_companion_damage_modifier: float
#@export var player_companion_cooldown_modifier: float #in %, bigger is better
#@export var player_companion_area_modifier: float
#
#@export_category("PLAYER MUTATION MODIFIERS")
#@export var player_max_mutations: int
#@export var player_mutation_damage_mod: float
#@export var player_mutation_speed_mod: float
#@export var player_mutation_area_mod: float
#@export var player_mutation_cooldown_mod: float #in %, bigger is better
#@export var player_mutation_projectiles_mod: float
#@export var player_mutation_pierce_mod: float
