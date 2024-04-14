extends CanvasLayer

@export var heart_container_scene: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_lives = GameManager.lives
	
	for i in range(player_lives):
		var heart = heart_container_scene.instantiate()
		$HBoxContainer.add_child(heart)

	GameManager.connect("player_lost_live", _player_lost_live)

func _player_lost_live():
	var children = $HBoxContainer.get_children()
	if children.size() > 0:
		$HBoxContainer.remove_child(children[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
