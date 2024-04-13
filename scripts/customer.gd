# Customer.gd
extends Area2D

# Member variables
var order = null
var patience = 100.0

func _ready():
	pass

func decrease_patience(delta):
	patience -= delta
	if patience <= 0:
		leave()

func leave():
	print("Customer is leaving due to impatience or order fulfillment.")
	queue_free()  # This will remove the Customer instance from the scene

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
