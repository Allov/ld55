class_name Guard
extends CharacterBody2D

func _ready():
	add_to_group("guards")

func _on_health_health_depleted():
	queue_free()
