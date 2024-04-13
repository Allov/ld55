extends RigidBody2D
class_name Ingredient


@export var kind: String = "default"
@export var cooked_kind: String = "default"

var node_to_follow: Node2D = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO	
var transformed = false
var cooking_station: CookingStation = null
var cooking = false
var cooked = false
var meal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func cook():
	cooking = true

func stop_cooking():
	cooking = false
	cooked = true
	kind = cooked_kind
	$Raw.visible = false
	$Cooked.visible = true

func follow(node: Node2D):
	node_to_follow = node
	cooking_station = null
	apply_central_force(Vector2.ZERO)

func stop_following():
	just_dropped = true
	cooking_station = null
	if node_to_follow.velocity:
		dropped_velocity = node_to_follow.velocity
	else:
		dropped_velocity = Vector2.ZERO
	node_to_follow = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	if just_dropped:
		just_dropped = false
		state.linear_velocity = dropped_velocity
		state.apply_central_impulse(dropped_velocity * 1.4)

	if node_to_follow != null:
		state.linear_velocity = Vector2.ZERO
		state.apply_central_force(Vector2.ZERO)
		state.apply_torque(0)
		state.transform = node_to_follow.global_transform
