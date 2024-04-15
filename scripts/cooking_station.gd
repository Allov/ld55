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
var audio_player: AudioStreamPlayer2D = null
var is_audio_playing = false

func toggle_indicator(value):
	$Indicator.visible = value

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
			audio_player = $MeatAudio
			audio_player.play()
			$Timer.one_shot = true
			$Timer.start()
		elif interaction_type == INTERACTION_TYPES.HOLD:
			audio_player = $SquishAudio
		elif interaction_type == INTERACTION_TYPES.TAP:
			audio_player = $KnifeAudio

		return true
	else:
		return false

func _stop_cooking():
	if cooking_ingredient != null:
		cooking_ingredient.stop_cooking()
		cooking_ingredient = null
		GameManager.cooked_ingredients += 1
		$ReadyAudio.play()
		
		if audio_player != null:
			audio_player.stop()
			audio_player = null
			is_audio_playing = false

func progress():
	if cooking_ingredient == null:
		return
	
	if interaction_type == INTERACTION_TYPES.TAP:
		$ProgressBar.value += progress_value
		if audio_player != null:
			audio_player.play()
	elif interaction_type == INTERACTION_TYPES.HOLD:
		if audio_player != null && not is_audio_playing:
			audio_player.play()
			is_audio_playing = true
		$ProgressBar.value += progress_value * get_process_delta_time()

	if $ProgressBar.value >= 1:
		$ProgressBar.value = 0
		_stop_cooking()

func is_holding_station():
	return interaction_type == INTERACTION_TYPES.HOLD

func stop_audio_hold():
	if audio_player != null && is_holding_station():
		audio_player.stop()
		is_audio_playing = false

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

