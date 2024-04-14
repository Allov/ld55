#Plate script
extends RigidBody2D
class_name Plate

var ingredients = []
var node_to_follow: Node2D = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO
var current_meal = ""

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
	var meal_info = Recipebook.get_meal_info(ingredients)
	if meal_info and meal_info.has("name"):
		current_meal = meal_info["name"]
	else:
		current_meal = "Unknown Meal"
	print("Updated meal to: ", current_meal)
	update_meal_sprite()
	
func update_meal_sprite():
	var meal_info = Recipebook.get_meal_info(ingredients)
	if meal_info:
		$WithIngredients.texture = load(meal_info.sprite)  # Update the sprite texture

func has_meal() -> bool:
	return ingredients.size() > 0

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
