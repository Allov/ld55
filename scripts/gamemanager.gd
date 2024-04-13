extends Node

# Singleton instance
var instance: GameManager

# Attributes
var score: int = 0
var lives: int = 3
var game_speed: float = 1.0
var game_state: String = "playing" # Options: "playing", "paused", "game_over"

func _ready():
	instance = self
	# Ensure there is only one instance of the game manager
	if instance and instance != self:
		queue_free()
		return
	# Initialize game state
	start_game()

func start_game():
	score = 0
	lives = 3
	game_speed = 1.0
	game_state = "playing"
	print("Game started")

func pause_game():
	if game_state != "paused":
		game_state = "paused"
		get_tree().paused = true
		print("Game paused")

func resume_game():
	if game_state == "paused":
		game_state = "playing"
		get_tree().paused = false
		print("Game resumed")

func end_game():
	game_state = "game_over"
	print("Game over. Final score: ", score)

func lose_life():
	lives -= 1
	print("Lives remaining: ", lives)
	if lives <= 0:
		end_game()

func add_score(amount: int):
	score += amount
	print("Current score: ", score)

func update_game_speed():
	if score > 100:
		game_speed = 1.5
	elif score > 500:
		game_speed = 2.0
	print("Game speed updated to: ", game_speed)

func toggle_pause():
	if game_state == "paused":
		resume_game()
	else:
		pause_game()
