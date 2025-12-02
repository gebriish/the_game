extends Node2D

@onready var label := $Label
@onready var area := $Area2D

@export var fade_time := 0.4
@export var bob_amplitude := 2.0  # How high the label moves up and down
@export var bob_speed := 1.0      # How fast the bobbing occurs

var bob_tween: Tween = null

func _ready() -> void:
	label.modulate.a = 0.0
	area.body_entered.connect(_on_enter)
	area.body_exited.connect(_on_exit)

func _on_enter(body):
	if body.name == "Player":
		fade_label(1.0)
		start_bobbing() # Start the bobbing when the player enters

func _on_exit(body):
	if body.name == "Player":
		fade_label(0.0)
		stop_bobbing() # Stop the bobbing when the player exits

func fade_label(target_alpha: float) -> void:
	var t := create_tween()
	t.tween_property(label, "modulate:a", target_alpha, fade_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func start_bobbing() -> void:
	# Stop any existing bobbing animation first
	if bob_tween and bob_tween.is_running():
		bob_tween.kill()
	
	# Reset label position to its original Y coordinate before starting the bob

	# Note: You might want to store the original position if the label moves for other reasons.
	# Assuming the label's position.y is its resting position.
	var original_y = label.position.y
	
	bob_tween = create_tween()
	bob_tween.set_loops() # Make the bobbing repeat indefinitely
	
	# 1. Move Up (or down)
	bob_tween.tween_property(label, "position:y", original_y - bob_amplitude, bob_speed / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# 2. Move Down (and back to original position)
	bob_tween.tween_property(label, "position:y", original_y + bob_amplitude, bob_speed / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_bobbing() -> void:
	if bob_tween:
		bob_tween.kill() # Stop the bobbing
		bob_tween = null
		# Optionally, Tween the label back to its resting position
		var t := create_tween()
		var original_y = label.position.y - bob_amplitude if label.position.y > 0 else label.position.y + bob_amplitude # crude guess for original Y
		t.tween_property(label, "position:y", original_y, fade_time) # Smoothly return to the original position
