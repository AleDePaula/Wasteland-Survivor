extends Area2D

var GM = GameManager
var PM = PlayerManager

var player = PM.player

@onready var damage_timer = $DamageTimer

@export var damage_animation_prefab: PackedScene
@export var base_area: float
@export var base_area_damage: float
@export var base_damage_interval: float #in seconds

### FAZER COM DOT PRODUCT O ANGULO DO GRITO
### AUMENTAR O RAIO DA AREA2D PARA CRESCER A DISTÂNCIA
