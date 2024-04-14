extends CharacterBody2D
class_name Player

@export var MAX_SPEED = 200.0
@export var ACCELERATION = 10.0
@export var DASH_VELOCITY = 400.0
@export var DASH_COOLDOWN = 1.0

var dash_cooldown = 0.0
var speed = 0.0
var object_in_hand: Node2D = null
var cooking_station_in_range: CookingStation = null
var summoning_guard_station_in_range: SummoningGuardStation = null
var summoning_enemy_station_in_range: SummoningEnemyStation = null

func _ready():
	$CookArea.connect("body_entered", _on_CookArea_body_entered)
	$CookArea.connect("body_exited", _on_CookArea_body_exited)
	$CookArea.connect("area_entered", _on_CookArea_area_entered)
	$CookArea.connect("area_exited", _on_CookArea_area_exited)

func _process(_delta):
	var object_in_range = null
	if Input.is_action_just_pressed("action"):
		object_in_range = get_object_in_range()

		if object_in_range:
			# If the player is not holding an object and an object is in range, pick it up.
			if object_in_range is CookingStation and object_in_hand == null:
				object_in_range.progress()
			if object_in_hand == null:
				pick_up_object(object_in_range)

			# Player is holding an object
			elif object_in_hand != null:
				interact_with_object(object_in_range)
		else:
			clear_object_in_hand()
			
	if object_in_hand:
		return
	
	# A cooking station is in range, try to progress it with the holding action
	if cooking_station_in_range != null and cooking_station_in_range.is_holding_station() and Input.is_action_pressed("action"):
		cooking_station_in_range.progress()
		
	if summoning_guard_station_in_range and Input.is_action_pressed("action"):
		summoning_guard_station_in_range.progress()

	if summoning_enemy_station_in_range and Input.is_action_pressed("action"):
		summoning_enemy_station_in_range.progress()

func get_object_in_range():
	var objects_in_range = $GrabArea.get_overlapping_bodies()
	for object in objects_in_range:
		if object != object_in_hand and (object is Plate or object is CookingStation or (object is Ingredient and object.cooking == false)):
			return object
			
func pick_up_object(object_in_range):
	# Object has been found, pick it up.
	if object_in_range is Plate or (object_in_range is Ingredient and object_in_range.cooking == false):
		print("Object picked up ", object_in_range)
		object_in_hand = object_in_range
		object_in_hand.follow(self)

func interact_with_object(object_in_range):
	# A cooking station is in range, try and cook the object.
	if object_in_range is CookingStation and object_in_hand is Ingredient and object_in_hand.cooked == false:
		if object_in_range.cook(object_in_hand):
			object_in_hand = null

	# A plate is in range, try and add the ingredient to the plate.
	elif object_in_range is Plate and object_in_hand is Ingredient and object_in_hand.cooked:
		if object_in_range.add_ingredient(object_in_hand.kind):
			object_in_hand.stop_following()
			object_in_hand.queue_free()
			object_in_hand = null

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
		velocity.x = move_toward(velocity.x, velocity.normalized().x * DASH_VELOCITY, DASH_VELOCITY * 0.5)
		velocity.y = move_toward(velocity.y, velocity.normalized().y * DASH_VELOCITY, DASH_VELOCITY * 0.5)

	var collided = move_and_slide()
	if collided:
		velocity = velocity.lerp(Vector2.ZERO, .1)
	
	if velocity.length() > 0:
		$AnimationPlayer.speed_scale = 1 + velocity.length() / MAX_SPEED
		$AnimationPlayer.play("walk")
		$Trailing.emitting = true
	else:
		$AnimationPlayer.stop()
		$Trailing.emitting = false

func clear_object_in_hand():
	if object_in_hand != null:
		object_in_hand.stop_following()

	object_in_hand = null
	
func _on_CookArea_body_entered(body):
	if body is CookingStation:
		cooking_station_in_range = body
		print("In range!")

func _on_CookArea_body_exited(body):
	if body is CookingStation:
		cooking_station_in_range = null
		print("Not in range!")
		
func _on_CookArea_area_entered(area):
	if area is SummoningGuardStation:
		summoning_guard_station_in_range = area
		
	if area is SummoningEnemyStation:
		summoning_enemy_station_in_range = area

func _on_CookArea_area_exited(area):
	if area is SummoningGuardStation:
		area.reset_progress()
		summoning_guard_station_in_range = null

	if area is SummoningEnemyStation:
		area.reset_progress()
		summoning_enemy_station_in_range = null
