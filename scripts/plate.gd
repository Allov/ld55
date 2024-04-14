extends RigidBody2D
class_name Plate

var ingredients = []
var node_to_follow: Node2D = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO


func add_ingredient(kind: String):
	if ingredients.size() < 3 and ingredients.has(kind) == false:
		ingredients.append(kind) ## Lien avec les recettes ici
		$Empty.visible = false
		$WithIngredients.visible = true
		return true
	else:
		print("Plate is full")
		return false

func follow(node: Node2D):
	node_to_follow = node
	apply_central_force(Vector2.ZERO)

func stop_following():
	just_dropped = true
	if node_to_follow.velocity:
		dropped_velocity = node_to_follow.velocity
	else:
		dropped_velocity = Vector2.ZERO
	node_to_follow = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
