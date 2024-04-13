class_name Hitbox
extends Area2D


signal target_hit()


@export_range(1, 10) var damage: int = 1 : set = set_damage, get = get_damage


func set_damage(value: int):
	var clamped_value = clamp(value, 1, 10)
	damage = value

func get_damage():
	return damage
