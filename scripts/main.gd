extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Start.connect("pressed", _on_Start_pressed)
	$Start.grab_focus()

func _on_Start_pressed():
	get_tree().change_scene_to_file("res://scenes/restaurant.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
