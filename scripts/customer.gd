#Customer script
extends CharacterBody2D
class_name Customer

@export var spawn_box = [32, 216+32, 284-32, 108-32]
@export var speed = 50.0

# Member variables
var order = null
var initial_patience
var target_position
@onready var patience_timer = $PatienceTimer
@onready var patience_bar = $PatienceBar

func _ready():
	initial_patience = patience_timer.wait_time;
	target_position = Vector2(randi_range(spawn_box[0], spawn_box[0] + spawn_box[2]), randi_range(spawn_box[1], spawn_box[1] + spawn_box[3]))
	$SpawnAudio.play()

func _process(_delta):
	# Update the patience bar based on the remaining time
	var time_left = patience_timer.time_left
	patience_bar.value = time_left / initial_patience
	
func _physics_process(_delta):
	var direction = target_position - global_position
	
	if direction.length() < 5.0:
		return
	
	velocity = direction.normalized() * speed
	move_and_slide()

func leave():
	print("Customer is leaving")
	queue_free()  # This will remove the Customer instance from the scene
	# Notify the DiningRoom to remove this customer from the list
	get_parent().remove_customer(self)

func set_order(new_order):
	order = Recipebook.recipes[new_order]  # Store the entire recipe dictionary
	var order_texture_path = order["sprite"]
	var order_texture = load(order_texture_path)
	$OrderDisplay/MealOrder.texture = order_texture
	print("Order set to: " + order["name"])

func receive_plate(plate: Plate) -> bool:
	if not plate.has_meal():
		print("No meal on the plate to deliver.")
		return false

	var meal = plate.current_meal
	if meal == order["name"]:  # Compare with the name in the order dictionary
		print("Correct meal provided! Customer is satisfied.")
		$PayAudio.play()
		$Sprite2D.visible = false
		$OrderDisplay.visible = false
		$PatienceBar.visible = false
		# Determine score based on difficulty
		var score_to_add = GameManager.SCORE_EASY if order["difficulty"] == "easy" else GameManager.SCORE_MEDIUM
		GameManager.add_score(score_to_add)
		leave()  # Assuming the customer leaves after receiving the correct meal
		return true
	else:
		print("Wrong meal provided. Customer wanted: " + order["name"] + ", but got: " + meal)
		GameManager.lose_life()
		leave()
		return true

func _on_patience_timer_timeout():
	print("Customer patience reached 0 and is now leaving.")
	GameManager.lose_life()
	leave()

func _on_pay_audio_finished():
	leave()
