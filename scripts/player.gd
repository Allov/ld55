extends CharacterBody2D
class_name Player

@export var MAX_SPEED = 200.0
@export var ACCELERATION = 10.0
@export var DASH_VELOCITY = 400.0
@export var DASH_COOLDOWN = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var dash_cooldown = 0.0
var speed = 0.0
var ingredient_in_hand: Ingredient = null
var ingredient_in_range: Ingredient = null
var cooking_station_in_range: CookingStation = null
var plate_in_range: Plate = null

func _ready():
	$GrabArea.connect("body_entered", _on_GrabArea_body_entered)
	$GrabArea.connect("body_exited", _on_GrabArea_body_exited)
	$CookArea.connect("body_entered", _on_CookArea_body_entered)
	$CookArea.connect("body_exited", _on_CookArea_body_exited)

func _process(_delta):
	if ingredient_in_hand == null and Input.is_action_just_pressed("action"):
		if ingredient_in_range == null:
			# Check if there is an ingredient in range because the player could have not moved from the station.
			var ingredients_in_range = $GrabArea.get_overlapping_bodies()
			for ingredient in ingredients_in_range:
				if ingredient is Ingredient and !ingredient.cooking:
					ingredient_in_range = ingredient
					break

		if ingredient_in_range != null:
			# Ingredient has been found in range, pick it up.
			ingredient_in_hand = ingredient_in_range
			ingredient_in_range = null
			if ingredient_in_hand != null:
				ingredient_in_hand.follow(self)

	elif ingredient_in_hand != null and Input.is_action_just_pressed("action"):
		if ingredient_in_hand != null and cooking_station_in_range != null:
			if cooking_station_in_range.cook(ingredient_in_hand):
				clear_ingredient_in_hand()
		else:
			ingredient_in_hand.stop_following()
			ingredient_in_hand = null
	elif plate_in_range != null and Input.is_action_just_pressed("action"):
		plate_in_range.follow(self)

	if cooking_station_in_range != null and cooking_station_in_range.is_holding_station() and Input.is_action_pressed("action"):
		cooking_station_in_range.progress()
	elif cooking_station_in_range != null and Input.is_action_just_pressed("action"):
		cooking_station_in_range.progress()


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

	var collided = move_and_slide()
	if collided:
		velocity = velocity.lerp(Vector2.ZERO, .1)

func _on_GrabArea_body_entered(body):
	if body is Ingredient and ingredient_in_range == null and ingredient_in_hand == null:
		var ingredient = body as Ingredient
		if !ingredient.cooking:
			ingredient_in_range = ingredient

func _on_GrabArea_body_exited(_body):
	if ingredient_in_range != null:
		clear_ingredient_in_hand()

func _on_CookArea_body_entered(body):
	# var station = body as CookingStation
	#if ingredient_in_hand != null and station != null and station.accepts == ingredient_in_hand.kind:
	
	if body is CookingStation:
		cooking_station_in_range = body
	elif body is Plate and ingredient_in_hand != null and ingredient_in_hand.cooked:
		var plate = body as Plate
		if plate.add_ingredient(ingredient_in_hand.kind):
			ingredient_in_hand.stop_following()
			ingredient_in_hand.queue_free()
			clear_ingredient_in_hand()
	elif body is Plate and ingredient_in_hand == null:
		plate_in_range = body


func _on_CookArea_body_exited(body):
	if body is CookingStation:
		cooking_station_in_range = null

func clear_ingredient_in_hand():
	ingredient_in_hand = null
	ingredient_in_range = null
