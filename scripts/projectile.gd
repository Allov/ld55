class_name Projectile
extends Area2D

@export var speed = 200
@export var steer_force = 150

var acceleration = Vector2.ZERO
var velocity := Vector2.ZERO
var target

func start(_position, _target):
	global_position = _position
	rotation += randf_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func _ready():
	velocity = speed * 5 * Vector2.RIGHT.rotated(rotation)
	$Lifespan.connect("timeout", _on_timeout_complete)
	$Lifespan.start()

func _physics_process(delta: float) -> void:
	if target != null:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity * delta
		look_at(global_position + velocity)
	else:
		queue_free()

func seek():
	var steer = Vector2.ZERO
	
	if target != null:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force

	return steer

func _on_timeout_complete():
	queue_free()

func _on_hitbox_area_entered(_area):
	if _area is Hurtbox:
		queue_free()
