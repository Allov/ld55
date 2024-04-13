# diningroom.gd
extends Node

var customers = []
var current_orders = {}
var customer_spawn_timer
var customer = preload("res://scenes/customer.tscn") 

func _ready():
	customer_spawn_timer = $Customer_spawn_timer 
	customer_spawn_timer.start()

func _on_customer_spawn_timer_timeout():
	spawn_customer()

func spawn_customer():
	var new_customer = customer.instantiate()
	new_customer.set_order("default")  # Set a default order, can be randomized later
	add_child(new_customer)
	customers.append(new_customer)
	print("New customer spawned with order: " + new_customer.order)
