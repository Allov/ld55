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
	print("Time left: " + str(time_left))

func leave():
	print("Customer is leaving due to impatience or order fulfillment.")
	queue_free()  # This will remove the Customer instance from the scene
	# Notify the DiningRoom to remove this customer from the list
	get_parent().remove_customer(self)

func set_order(new_order):
	order = new_order  # Assuming new_order is a string representing the meal name
	var order_details = Recipebook.recipes[order]  # Accessing the recipe details using the meal name
	var order_texture_path = order_details["sprite"]
	var order_texture = load(order_texture_path)
	$OrderDisplay/MealOrder.texture = order_texture
	print("Order set to: " + order)

func receive_plate(plate: Plate) -> bool:
	if not plate.has_meal():
		print("No meal on the plate to deliver.")
		return false

	var meal = plate.current_meal
	if meal == order:  # Directly compare two strings
		print("Correct meal provided! Customer is satisfied.")
		leave()  # Assuming the customer leaves after receiving the correct meal
		return true
	else:
		print("Wrong meal provided. Customer wanted: " + order + ", but got: " + meal)
		GameManager.lose_life()
		leave()
		return true

func _on_patience_timer_timeout():
	GameManager.lose_life()
	leave()
