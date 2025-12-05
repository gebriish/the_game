extends Node2D

@export var sway_amount_idle: float = 4.0
@export var sway_speed_idle: float = 2.0

@export var sway_amount_player: float = 10.0
@export var sway_speed_player: float = 5.0

var base_rotation = 0.0
var time = 0.0
var player = null

func _ready():
	base_rotation = rotation
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	time += delta
	
	var sway = sin(time * sway_speed_idle) * deg_to_rad(sway_amount_idle)

	if is_player_moving():
		sway += sin(time * sway_speed_player) * deg_to_rad(sway_amount_player)

	rotation = base_rotation + sway


func is_player_moving() -> bool:
	if not player:	
		return false
	if not player.has_method("get_velocity"):
		return false

	return player.get_velocity().length() > 5
