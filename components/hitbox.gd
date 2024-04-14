class_name Hitbox
extends Area2D

@export_range(1, 10) var damage: int = 1 : set = set_damage, get = get_damage

func set_damage(value: int):
	var clamped_value = clamp(value, 1, 10)
	damage = clamped_value

func get_damage():
	return damage
