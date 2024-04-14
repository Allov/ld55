class_name Enemy
extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var ingredients_array: Array[PackedScene]
@export var detection_area: Area2D
# À changer?
@onready var player = get_node("/root/Restaurant/Player")
@onready var restaurant = get_node("/root/Restaurant")

var timer;
var is_dead = false
var can_shoot = false
var guard = null

func _ready():
	add_to_group("enemies")
	$AttackDelay.connect("timeout", _on_timeout_complete)
	$AttackDelay.start()

func _process(delta):
	if can_shoot and not is_dead:
		if guard == null:
			for body in $DetectionArea.get_overlapping_bodies():
				if body.is_in_group("guards"):
					guard = body
					break
				
			if(guard == null):
				shoot_projectile(player)
		else:
			shoot_projectile(guard)
	elif is_dead:
		queue_free()

func shoot_projectile(target: CharacterBody2D):
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.start(global_position, target)
	can_shoot = false
	$AttackDelay.start()

func _on_timeout_complete() -> void:
	can_shoot = true

func _on_health_health_depleted():
	for ingredient in ingredients_array:
		var instance = ingredient.instantiate()
		restaurant.call_deferred("add_child", instance)
		instance.global_position = global_position
		instance.apply_force(Vector2(100, 100))
	is_dead = true
