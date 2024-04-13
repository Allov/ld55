extends Area2D

# Member variables
var order = null
var initial_patience = 10.0  # Initial waiting time in seconds
@onready var patience_timer = $PatienceTimer
@onready var patience_bar = $PatienceBar

func _ready():
	patience_timer.wait_time = initial_patience
	patience_timer.start()

func _process(delta):
	# Update the patience bar based on the remaining time
	var time_left = patience_timer.time_left
	var patience_level = time_left / initial_patience
	patience_bar.value = patience_level

func leave():
	print("Customer is leaving due to impatience or order fulfillment.")
	queue_free()  # This will remove the Customer instance from the scene
	# Notify the DiningRoom to remove this customer from the list
	get_parent().remove_customer(self)

func set_order(new_order):
	order = new_order
	print("Order set to: " + order)
	# Future implementation: Update customer's thought bubble or similar UI element here

func receive_order(meal):
	if meal == null:
		print("No meal provided to the customer.")
		return false
	elif meal != order:
		print("Wrong meal provided. Customer wanted: " + order + ", but got: " + meal)
		return false
	else:
		print("Correct meal provided! Customer is satisfied.")
		leave()  # Assuming the customer leaves after receiving the correct meal
		return true


func _on_patience_timer_timeout():
	GameManager.lose_life();
	leave()
