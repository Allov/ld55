# diningroom.gd
extends Node

var customers = []
var current_orders = {}
var customer_spawn_timer

func _ready():
	customer_spawn_timer = $Customer_spawn_timer 
	customer_spawn_timer.connect("timeout", Callable(self, "_on_customer_spawn_timer_timeout"))
	customer_spawn_timer.start()

func _on_customer_spawn_timer_timeout():
	print("Timer ticked - This is a test message.")
	#spawn_customer()

#func spawn_customer():
	#var customer = preload("res://path_to_customer_scene.tscn").instance()  # Ensure you have a customer scene
	#add_child(customer)
	#customers.append(customer)
	#print("Customer spawned")
	## Reset the timer
	#customer_spawn_timer.start()

# func accept_order(customer, order):
	# This function would be called when a player confirms an order with a customer.

# func deliver_meal(customer, meal):
	# In this method, you check if the meal matches the order and then handle the customer's reaction.

# func update_patience():
	# This function should periodically decrease the patience level of each customer.

# func handle_impatient_customer(customer):
	# Handle the case when a customer runs out of patience.

# Additional methods to manage customers and orders might be added here.
