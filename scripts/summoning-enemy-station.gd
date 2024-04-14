extends Area2D
class_name SummoningEnemyStation

@export var spawn_point: NodePath
@export var enemy_scene: PackedScene = null
@export var progress_value: float = 0.5

func summon_enemy():
	if GameManager.current_enemy != null:
		return false
	
	var enemy = enemy_scene.instantiate()
	get_node("/root/Restaurant").add_child(enemy)
	enemy.connect("health_depleted", _free_summon_point)

	enemy.global_position = get_node(spawn_point).global_position
	
	GameManager.current_enemy = enemy
	
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
		
	return true

func reset_progress():
	$ProgressBar.visible = false
	$ProgressBar.value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _free_summon_point(guard):
	GameManager.current_enemy = null
	print("Enemy died ", guard)
