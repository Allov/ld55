extends Area2D
class_name Customer

# Member variables
var order = null
var initial_patience
@onready var patience_timer = $PatienceTimer
@onready var patience_bar = $PatienceBar

func _ready():
	initial_patience = patience_timer.wait_time;

func _process(_delta):
	# Update the patience bar based on the remaining time
	var time_left = patience_timer.time_left
	patience_bar.value = time_left / initial_patience

func leave():
	print("Customer is leaving")
	queue_free()  # This will remove the Customer instance from the scene
	# Notify the DiningRoom to remove this customer from the list
	get_parent().remove_customer(self)

func set_order(new_order):
	order = Recipebook.recipes[new_order]  # Store the entire recipe dictionary
	var order_texture_path = order["sprite"]
	var order_texture = load(order_texture_path)
	$OrderDisplay/MealOrder.texture = order_texture
	print("Order set to: " + order["name"])

func receive_plate(plate: Plate) -> bool:
	if not plate.has_meal():
		print("No meal on the plate to deliver.")
		return false

	var meal = plate.current_meal
	if meal == order["name"]:  # Compare with the name in the order dictionary
		print("Correct meal provided! Customer is satisfied.")
		leave()  # Assuming the customer leaves after receiving the correct meal
		return true
	else:
		print("Wrong meal provided. Customer wanted: " + order["name"] + ", but got: " + meal)
		GameManager.lose_life()
		leave()
		return true

func _on_patience_timer_timeout():
	print("Customer patience reached 0 and is now leaving.")
	GameManager.lose_life()
	leave()
