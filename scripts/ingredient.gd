extends RigidBody2D
class_name Ingredient

@export var kind: String = "default"
@export var cooked_kind: String = "default"

var rng = RandomNumberGenerator.new()
var node_to_follow: Node2D = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO	
var transformed = false
var cooking = false
var cooked = false
var meal = false
var moveVector: Vector2
var spawning_from_enemy = false

func spawn_from_enemy(targetPos: Vector2, parent: Node):
	parent.add_child(self)
	moveVector = targetPos
	spawning_from_enemy = true

func cook():
	cooking = true

func stop_cooking():
	cooking = false
	cooked = true
	kind = cooked_kind
	$Raw.visible = false
	$Cooked.visible = true
	print("Ingredient cooked: ", kind)

func follow(node: Node2D):
	node_to_follow = node
	apply_central_force(Vector2.ZERO)
	print("Following ", node)

func stop_following():
	just_dropped = true
	if "velocity" in node_to_follow and node_to_follow.velocity:
		dropped_velocity = node_to_follow.velocity.normalized() * GameManager.get_player().MAX_SPEED
	else:
		dropped_velocity = Vector2.ZERO
	print("Stopped following: ", node_to_follow)
	node_to_follow = null

func _integrate_forces(state):
	if just_dropped:
		just_dropped = false
		state.linear_velocity = dropped_velocity
		state.apply_central_impulse(dropped_velocity * 2)

	if node_to_follow != null:
		state.linear_velocity = Vector2.ZERO
		state.apply_central_force(Vector2.ZERO)
		state.apply_torque(0)
		state.transform = node_to_follow.global_transform
	
	if spawning_from_enemy:
		state.transform = Transform2D(0.0, moveVector)
		state.apply_central_impulse(Vector2(rng.randf_range(-1000.0, 1000.0), rng.randf_range(750.0, 1500.0)))
		spawning_from_enemy = false
	
