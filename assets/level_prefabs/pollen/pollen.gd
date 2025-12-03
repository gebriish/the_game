extends Node2D

@export var stamina_amount: float = 30.0
@export var bob_height: float = 6.0
@export var bob_speed: float = 3.0

var base_y: float
var t: float = 0.0
var original_pos: Vector2
var collected: bool = false

func _ready() -> void:
	original_pos = position
	base_y = position.y
	$Area2D.body_entered.connect(on_body_entered)
	GameEvents.player_died.connect(_on_player_died)

func _process(delta: float) -> void:
	if collected:
		return

	t += delta * bob_speed
	position.y = base_y + sin(t) * bob_height

func on_body_entered(body: Node) -> void:
	if collected:
		return

	if body.is_in_group("player"):
		if body.has_method("add_stamina"):
			body.add_stamina(stamina_amount)

		$CollectSound.play()
		collected = true
		hide()
		$Area2D.monitoring = false

func _on_player_died() -> void:
	collected = false
	position = original_pos
	base_y = original_pos.y
	t = 0.0

	show()
	$Area2D.monitoring = true
