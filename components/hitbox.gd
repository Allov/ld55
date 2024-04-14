class_name Hitbox
extends Area2D

@export var damage: int = 10 : set = set_damage, get = get_damage

func set_damage(value: int):
	damage = value

func get_damage():
	return damage
