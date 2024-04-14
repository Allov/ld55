extends RigidBody2D
class_name Plate

var rng = RandomNumberGenerator.new()
var ingredients = []
var node_to_follow: Node2D = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO
var current_meal = ""
var moveVector: Vector2
var spawning_from_station = false

func spawn_from_station(targetPos: Vector2, parent: Node):
	parent.add_child(self)
	moveVector = targetPos
	spawning_from_station = true

func add_ingredient(kind: String):
	if ingredients.size() < 3 and not ingredients.has(kind):
		ingredients.append(kind)
		print("Ingredients on plate: ", ingredients)
		update_meal()
		$Empty.visible = false
		$WithIngredients.visible = true
		return true
	else:
		print("Plate is full or ingredient already added to this plate")
		return false

func update_meal():
	current_meal = Recipebook.get_meal(ingredients)
	print("Updated meal to: ", current_meal)

func follow(node: Node2D):
	node_to_follow = node
	apply_central_force(Vector2.ZERO)

func stop_following():
	just_dropped = true
	if node_to_follow and node_to_follow.velocity:
		dropped_velocity = node_to_follow.velocity
	else:
		dropped_velocity = Vector2.ZERO
	node_to_follow = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initialization code here.

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
	
	if spawning_from_station:
		state.transform = Transform2D(0.0, moveVector)
		state.apply_central_impulse(Vector2(rng.randf_range(-750.0, 750.0), rng.randf_range(-750.0, 750.0)))
		spawning_from_station = false
