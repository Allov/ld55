extends CharacterBody2D
class_name Player

@export var MAX_SPEED = 300.0
@export var ACCELERATION = 10.0
@export var DASH_VELOCITY = 600.0
@export var DASH_COOLDOWN = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var dash_cooldown = 0.0
var speed = 0.0
var item_in_hand: Item = null
var item_in_range: Item = null
var cooking_station_in_range: CookingStation = null

func _ready():
	$GrabArea.connect("body_entered", _on_GrabArea_body_entered)
	$GrabArea.connect("body_exited", _on_GrabArea_body_exited)
	$CookArea.connect("body_entered", _on_CookArea_body_entered)
	$CookArea.connect("body_exited", _on_CookArea_body_exited)

func _process(_delta):
	if item_in_hand == null and Input.is_action_just_pressed("action"):
		if item_in_range == null:
			var items_in_range = $GrabArea.get_overlapping_bodies()
			for item in items_in_range:
				if item is Item:
					item_in_range = item
					break

		item_in_hand = item_in_range
		item_in_range = null
		if item_in_hand != null:
			item_in_hand.grab(self)
	elif item_in_hand != null and Input.is_action_just_pressed("action"):
		if item_in_hand != null and cooking_station_in_range != null:
			print("Cooking", item_in_hand.kind, "at", cooking_station_in_range.name)
			item_in_hand.cook(cooking_station_in_range)
		else:
			item_in_hand.drop()
			item_in_hand = null


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

func _on_GrabArea_body_entered(body):
	if item_in_range == null:
		item_in_range = body

func _on_GrabArea_body_exited(_body):
	if item_in_range != null:
		clear_item_in_hand()

func _on_CookArea_body_entered(body):
	var station = body as CookingStation
	if item_in_hand != null and station != null and station.accepts == item_in_hand.kind:
		cooking_station_in_range = body

func _on_CookArea_body_exited(_body):
	cooking_station_in_range = null

func clear_item_in_hand():
	item_in_hand = null
	item_in_range = null
