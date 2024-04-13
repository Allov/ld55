class_name Guard
extends CharacterBody2D

@export var projectile_scene: PackedScene
@export_range(1, 10) var attack_delay: float = 2

var timer;
var can_shoot = false;
var enemy = null;

func _ready():
	add_to_group("guards")
	$AttackDelay.connect("timeout", _on_timeout_complete)
	$AttackDelay.start()

func _process(delta):
	if(can_shoot):
		if(enemy == null):
			for body in $DetectionArea.get_overlapping_bodies():
				if body.is_in_group("enemies"):
					enemy = body
					break
		else:
			shoot_projectile(enemy)

func shoot_projectile(target: CharacterBody2D):
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.start(global_position, target)
	can_shoot = false
	$AttackDelay.start()

func _on_timeout_complete() -> void:
	can_shoot = true

func _on_health_health_depleted():
	queue_free()
