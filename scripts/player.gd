extends CharacterBody2D

@export var MAX_SPEED = 300.0
@export var ACCELERATION = 10.0
@export var DASH_VELOCITY = 600.0
@export var DASH_COOLDOWN = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var dash_cooldown = 0.0
var speed = 0.0

func _physics_process(delta):
	var current_direction = velocity.normalized()
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		if current_direction.dot(Vector2(horizontal_direction, 0)) < 0.0:
			velocity.x /= 1.2
		velocity.x = move_toward(velocity.x, horizontal_direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * 2.0)

	var vertical_direction = Input.get_axis("move_up", "move_down")
	if vertical_direction:
		if current_direction.dot(Vector2(0, vertical_direction)) < 0.0:
			velocity.x /= 1.2
		velocity.y = move_toward(velocity.y, vertical_direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.y = move_toward(velocity.y, 0, ACCELERATION * 2.0)

	dash_cooldown = max(0, dash_cooldown - delta)
	
	if Input.is_action_just_pressed("dash") and dash_cooldown <= 0:
		dash_cooldown = DASH_COOLDOWN
		velocity.x = move_toward(velocity.x, velocity.normalized().x * DASH_VELOCITY, DASH_VELOCITY)
		velocity.y = move_toward(velocity.y, velocity.normalized().y * DASH_VELOCITY, DASH_VELOCITY)

	move_and_slide()
