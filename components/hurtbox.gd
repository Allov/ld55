class_name Hurtbox
extends Area2D

signal received_damage(damage: int)

@export var health: Health

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if get_parent() is Player:
			GameManager.lose_life()
		else:
			health.health -= area.damage
			received_damage.emit(area.damage)
