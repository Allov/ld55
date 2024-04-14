extends Node2D

var customers = []
var current_orders = {}
var customer_spawn_timer
var customer_positions = [Vector2(52, 170), Vector2(82, 170), Vector2(102, 170)]
var customer = preload("res://scenes/customer.tscn") 

func _ready():
	spawn_customer()
	customer_spawn_timer = $Customer_spawn_timer 
	customer_spawn_timer.start()

func _on_customer_spawn_timer_timeout():
	if len(customers) < 3:
		spawn_customer()
	else:
		customer_spawn_timer.stop()
  
func get_customers():
	return customers

func spawn_customer():
	var new_customer = customer.instantiate()
	var position_index = len(customers) % customer_positions.size()
	new_customer.position = customer_positions[position_index]
	var random_order = Recipebook.get_random_recipe()
	new_customer.set_order(random_order)
	add_child(new_customer)
	customers.append(new_customer)
	var meal_name = Recipebook.recipes[random_order]["name"]
	print("New customer spawned with order: " + meal_name)

func _process(delta):
	pass

func remove_customer(customer):
	if customer in customers:
		customers.erase(customer)
		if len(customers) < 3 and not customer_spawn_timer.is_stopped():
			customer_spawn_timer.start()
