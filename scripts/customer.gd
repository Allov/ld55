extends Area2D

# Member variables
var order = null
var patience = 100.0

func _ready():
	# Initialize any necessary variables or states here
	pass

# Decrease patience over time or due to other triggers
func decrease_patience(delta):
	patience -= delta
	if patience <= 0:
		leave()

# Placeholder for customer departure
func leave():
	print("Customer is leaving due to impatience or order fulfillment.")
	queue_free()  # This will remove the Customer instance from the scene

# Placeholder to set an order, can be expanded later
func set_order(new_order):
	order = new_order
	# Update customer's thought bubble or similar UI element here
