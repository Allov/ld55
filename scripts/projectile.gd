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
	$Timer.connect("timeout", _on_timeout_complete)
	$Timer.start()

func _physics_process(delta: float) -> void:
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	position += velocity * delta
	look_at(global_position + velocity)

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
		return steer

func _on_timeout_complete():
	queue_free()
