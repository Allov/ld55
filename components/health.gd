class_name Health
extends Node

signal health_changed(diff: int)
signal health_depleted()

@export_range(1, 10) var max_health: int = 5 : set = set_max_health, get = get_max_health

@onready var health: int = max_health : set = set_health, get = get_health

var is_dead: bool = false;

func set_max_health(value: int):
	if is_dead:
		return
	
	var clamped_value = clamp(value, 1, 10)
	
	if not clamped_value == max_health:
		max_health = clamped_value
	
	if max_health < health:
		health = max_health

func get_max_health() -> int:
	return max_health

func set_health(value: int):
	if is_dead:
		return
		
	var clamped_value = clamp(value, 0, max_health)
	
	if clamped_value != health:
		var diff = clamped_value - health
		health = value
		health_changed.emit(diff)
	
	if health <= 0:
		is_dead = true
		health_depleted.emit()

func get_health() -> int:
	return health
