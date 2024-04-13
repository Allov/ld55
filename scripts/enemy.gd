class_name Enemy
extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var detection_area: Area2D
@export_range(1, 10) var attack_delay: float = 2 
@onready var player = get_node("/root/Fridge/Player")

var timer;
var can_shoot = false;
var collision_array = []

func _ready():
	$Timer.connect("timeout", _on_timeout_complete)
	$Timer.start()

func _process(delta):
	if(can_shoot):
		if(collision_array.is_empty()):
			for body in detection_area.get_overlapping_bodies():
				if body.is_in_group("guards"):
					collision_array.push_back(body)
				
			if(collision_array.is_empty()):
				shoot_projectile(player)
		else:
			shoot_projectile(collision_array[0])

func shoot_projectile(target: CharacterBody2D):
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.start(global_position, target)
	can_shoot = false
	$Timer.start()

func _on_timeout_complete() -> void:
	can_shoot = true

func _on_health_health_depleted():
	queue_free()
