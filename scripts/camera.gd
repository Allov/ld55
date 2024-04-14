extends Camera2D

@export var shake_duration = 1.0
@export var shake_amount = 1.0
var shaking = false
@onready var shake_time = shake_duration

func _ready():
	randomize()


func shake():
	shaking = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shaking:
		shake_time -= delta
		
		if shake_time > 0:
			offset.x = move_toward(position.x, randi_range(-shake_amount, shake_amount), .4)
			offset.y = move_toward(position.y, randi_range(-shake_amount, shake_amount), .4)
		else:
			shaking = false
			shake_time = shake_duration
			position = Vector2.ZERO
