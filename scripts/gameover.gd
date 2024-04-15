extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer.visible = false
	$CanvasLayer/RestartButton.connect("pressed", _on_RestartButton_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_RestartButton_pressed():
	print("Restart !Pressed!")
	GameManager.start_game()
	get_tree().reload_current_scene()
