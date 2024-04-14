class_name PlateStation
extends StaticBody2D

@export var plate_scene: PackedScene
@onready var restaurant = get_node("/root/Restaurant")

func spawn_plate():
	var plate = plate_scene.instantiate()
	plate.spawn_from_station($SpawnPoint.global_position, restaurant)
