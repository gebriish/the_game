extends CharacterBody2D

const GRAVITY             = 2400.0      # px/s^2
const MAX_SPEED           = 500.0       # px/s
const ACCELERATION        = 9400.0      # px/s^2
const JUMP_VELOCITY       = -650.0      # px/s
const MIN_JUMP_VELOCITY   = -300.0      # px/s
const DASH_SPEED          = 1200.0      # px/s

const COYOTE_TIME         = 0.12        # sec
const JUMP_BUFFER_TIME    = 0.12        # sec
const DASH_DURATION       = 0.15        # sec

var player_vel = Vector2()
var axis = Vector2()

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var dash_timer = 0.0

var can_jump = false
var is_dashing = false
var has_dashed = false
var friction = false

var sprite_color = "red"

func _physics_process(delta: float):

	if !is_dashing:
		player_vel.y += GRAVITY * delta

	friction = false
	get_input_axis()

	dash(delta)

	if is_on_floor():
		can_jump = true
		coyote_timer = 0.0
		has_dashed = false
		sprite_color = "red"
	else:
		coyote_timer += delta
		if coyote_timer > COYOTE_TIME:
			can_jump = false
		friction = true

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME

	jump_buffer_timer -= delta
	if jump_buffer_timer > 0.0 and can_jump:
		jump()
		jump_buffer_timer = 0.0

	set_jump_height()

	horizontal_movement(delta)

	velocity = player_vel
	move_and_slide()
	player_vel = velocity

func horizontal_movement(delta: float):
	if is_dashing:
		return

	if axis.x != 0:
		player_vel.x = move_toward(player_vel.x, axis.x * MAX_SPEED, ACCELERATION * delta)
		$Rotatable.scale.x = sign(axis.x)
	else:
		player_vel.x = move_toward(player_vel.x, 0, ACCELERATION * delta * 0.4)

	if friction:
		player_vel.x = lerp(player_vel.x, 0.0, 0.001)


func jump():
	player_vel.y = JUMP_VELOCITY
	can_jump = false


func set_jump_height():
	if Input.is_action_just_released("jump"):
		if player_vel.y < MIN_JUMP_VELOCITY:
			player_vel.y = MIN_JUMP_VELOCITY

func dash(delta: float):
	if !has_dashed and Input.is_action_just_pressed("dash") and axis != Vector2.ZERO:
		player_vel = axis * DASH_SPEED
		is_dashing = true
		has_dashed = true
		dash_timer = 0.0
		sprite_color = "blue"
		Input.start_joy_vibration(0, 1, 1, 0.2)

	if is_dashing:
		dash_timer += delta
		if dash_timer >= DASH_DURATION:
			is_dashing = false


func get_input_axis():
	axis = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down"))  - float(Input.is_action_pressed("up"))
	)
	if axis != Vector2.ZERO:
		axis = axis.normalized()
