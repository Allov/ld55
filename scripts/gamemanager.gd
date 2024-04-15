# gamemanager.gd est un singleton appelé par main.gd et géré dans Autoload
extends Node

signal player_lost_live
signal score_updated

const SCORE_EASY = 50
const SCORE_MEDIUM = 125

var instance: GameManager
var score = 0
var lives: int = 5
var game_speed: float = 1.0
var game_state: String = "playing" # trois options: "playing", "paused", "game_over"
var current_enemy: Enemy = null
var summon_points = {}
var player = null
var restaurant = null
var cooked_ingredients = 0
var assembled_meal = 0
var current_cooking_station = null

func _input(event):
	if event.is_action_pressed("pause_game"):
		toggle_pause()

func start_game():
	score = 0
	lives = 5
	game_speed = 1.0
	game_state = "playing"
	print("Game started")

func toggle_pause():
	if game_state == "paused":
		resume_game()
	else:
		pause_game()

func pause_game():
	if game_state != "paused":
		game_state = "paused"
		## DiningArea.paused = true
		print("Game paused")

func resume_game():
	if game_state == "paused":
		game_state = "playing"
		get_tree().paused = false
		print("Game resumed")

func end_game():
	game_state = "game_over"
	print("Game over. Final score: ", score)
	var game_over_screen = get_tree().current_scene.get_node("GameOver")
	game_over_screen.get_node("CanvasLayer/ScoreLabel").text = "Score: " + str(score)
	game_over_screen.get_node("CanvasLayer").visible = true

func lose_life():
	player.lose_life()
	lives -= 1
	print("Lives remaining: ", lives)
	player_lost_live.emit()
	if lives <= 0:
		end_game()

func add_score(points : int) -> void:
	score += points
	print("Score updated: " + str(score))
	emit_signal("score_updated")  # This line emits the signal to update the UI

func update_game_speed():
	if score > 100:
		game_speed = 1.5
	elif score > 500:
		game_speed = 2.0
	print("Game speed updated to: ", game_speed)

func set_player(_player: Node):
	player = _player

func get_player():
	return player

func set_restaurant(_restaurant: Node):
	restaurant = _restaurant

func get_restaurant():
	return restaurant
	
func summon_points_empty(min: int = 2):
	var i = 0
	for point in summon_points:
		if summon_points[point] == null:
			i += 1
			if i > min:
				return true
	
	return false


func set_score(new_score: int):
	score = new_score
	emit_signal("score_updated")
