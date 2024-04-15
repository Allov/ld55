extends Area2D
class_name SummoningEnemyStation

@export var spawn_point: NodePath
@export var enemy_scene: PackedScene = null
@export var progress_value: float = 0.5

var invoke_audio_playing = false

func toggle_indicator(value):
	$Indicator.visible = value

func summon_enemy():
	if GameManager.current_enemy != null:
		return false
	
	var enemy = enemy_scene.instantiate()
	get_node("/root/Restaurant").add_child(enemy)
	enemy.connect("health_depleted", _free_summon_point)

	enemy.global_position = get_node(spawn_point).global_position
	GameManager.current_enemy = enemy
	
	$InvokeAudio.stop()
	invoke_audio_playing = false
	
	return true

func progress():
	if GameManager.current_enemy != null:
		print("Enemy already summoned")
		return false
	
	$ProgressBar.visible = true
	$ProgressBar.value += progress_value * get_process_delta_time()
	
	if $ProgressBar.value >= 1.0:
		$ProgressBar.value = 0.0
		summon_enemy()

	if not invoke_audio_playing && GameManager.current_enemy == null:
		$InvokeAudio.play()
		invoke_audio_playing = true
	
	return true

func reset_progress():
	$ProgressBar.visible = false
	$ProgressBar.value = 0.0
	$InvokeAudio.stop()
	invoke_audio_playing = false

func _free_summon_point(guard):
	GameManager.current_enemy = null
	print("Enemy died ", guard)
