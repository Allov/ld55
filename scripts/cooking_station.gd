extends StaticBody2D
class_name CookingStation

enum INTERACTION_TYPES {
	TIMER,
	HOLD,
	TAP
}

@export var accepts: String = "default"
@export var interaction_type: INTERACTION_TYPES = INTERACTION_TYPES.TIMER
@export var progress_value: float = 0.25

var cooking_ingredient: Ingredient = null

func cook(ingredient: Ingredient):
	if ingredient.kind != accepts:
		print("Cannot cook this ingredient")
		return false

	if cooking_ingredient == null:
		cooking_ingredient = ingredient
		cooking_ingredient.cook()
		cooking_ingredient.follow(self)

		print("Cooking ingredient: ", cooking_ingredient)

		if interaction_type == INTERACTION_TYPES.TIMER:
			$Timer.one_shot = true
			$Timer.start()

		return true
	else:
		return false

func _stop_cooking():
	if cooking_ingredient != null:
		cooking_ingredient.stop_cooking()
		cooking_ingredient = null

func progress():
	if cooking_ingredient == null:
		return
	
	if interaction_type == INTERACTION_TYPES.TAP:
		$ProgressBar.value += progress_value
	elif interaction_type == INTERACTION_TYPES.HOLD:
		$ProgressBar.value += progress_value * get_process_delta_time()

	if $ProgressBar.value >= 1:
		_stop_cooking()

func is_holding_station():
	return interaction_type == INTERACTION_TYPES.HOLD

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", _stop_cooking)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if cooking_ingredient != null:
		if interaction_type == INTERACTION_TYPES.TIMER:
			$ProgressBar.value = 1 - ($Timer.time_left / $Timer.wait_time)
		$ProgressBar.visible = true
	else:
		$ProgressBar.visible = false

