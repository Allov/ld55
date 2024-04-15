class_name Enemy
extends CharacterBody2D

signal health_depleted(enemy)

@export var projectile_scene: PackedScene
@export var ingredients_array: Array[PackedScene]
@export var detection_area: Area2D

var timer;
var is_dead = false
var can_shoot = false
var guard = null

func _ready():
	add_to_group("enemies")
	$AttackDelay.connect("timeout", _on_timeout_complete)
	$AttackDelay.start()
	$SpawnAudio.play()

func _process(_delta):
	if can_shoot and not is_dead:
		if guard == null:
			print($DetectionArea.get_overlapping_bodies())
			for body in $DetectionArea.get_overlapping_bodies():
				if body.is_in_group("guards"):
					guard = body
					break
				
			if(guard == null):
				shoot_projectile(GameManager.get_player())
		else:
			shoot_projectile(guard)

func shoot_projectile(target: CharacterBody2D):
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.start(global_position, target)
	can_shoot = false
	$AttackDelay.start()

func deferred_spawn_ingredients(_ingredients_array: Array[PackedScene]):
	for ingredient in _ingredients_array:
		var instance = ingredient.instantiate()
		instance.spawn_from_enemy(global_position, GameManager.get_restaurant())

func _on_timeout_complete() -> void:
	can_shoot = true

func _on_health_health_depleted():
	call_deferred("deferred_spawn_ingredients", ingredients_array)
	is_dead = true
	health_depleted.emit(self)
	$DieAudio.play()
	$Sprite2D.visible = false


func _on_die_audio_finished():
	queue_free()
