extends Node2D  # or whatever your root node type is

# On affiche un debug-display avec la touche '9'. Toutes les infos de GameManager s'y trouvent.
var debug_visible: bool = false

func _ready():
	$DebugLayer.visible = false
	GameManager.set_restaurant(self)

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		debug_visible = !debug_visible
		$DebugLayer.visible = debug_visible

func _process(_delta):
	if debug_visible:
		update_debug_info()

func update_debug_info():
	var fps = Engine.get_frames_per_second()
	var lives = GameManager.lives
	var score = GameManager.score
	var game_speed = GameManager.game_speed
	var game_state = GameManager.game_state
	var spawn_timer = $DiningRoom/Customer_spawn_timer.time_left  # Access the timer's remaining time

	# Retrieve the list of customers from the DiningRoom
	var customers = $DiningRoom.get_customers()  # Ensure there's a method get_customers() in DiningRoom
	var patience_info = ""
	for customer in customers:
		var patience_bar = customer.get_node("PatienceBar")  # Correct way to access the node
		var patience_level = patience_bar.value
		patience_info += "Customer Patience: %.2f\n" % patience_level

	# var debug_text = "FPS: %s\nLives: %s\nScore: %s\nGame Speed: %s\nGame State: %s\nSpawn Timer: %.2f\n%s" % [fps, lives, score, game_speed, game_state, spawn_timer, patience_info]
	var debug_text = ""
	if GameManager.current_cooking_station:
		debug_text = "cooking station " + GameManager.current_cooking_station.name
	
	$DebugLayer/DebugLabel.text = debug_text
	
