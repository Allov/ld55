extends Node  # or whatever your root node type is

# On affiche un debug-display avec la touche '9'. Toutes les infos de GameManager s'y trouvent.
var debug_visible: bool = false

func _ready():
	$DebugLayer.visible = false

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		debug_visible = !debug_visible
		$DebugLayer.visible = debug_visible

func _process(delta):
	if debug_visible:
		update_debug_info()

func update_debug_info():
	var fps = Engine.get_frames_per_second()
	var lives = GameManager.lives
	var score = GameManager.score
	var game_speed = GameManager.game_speed
	var game_state = GameManager.game_state
	var debug_text = "FPS: %s\nLives: %s\nScore: %s\nGame Speed: %s\nGame State: %s" % [fps, lives, score, game_speed, game_state]
	$DebugLayer/DebugLabel.text = debug_text
