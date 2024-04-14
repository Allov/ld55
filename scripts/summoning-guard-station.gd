extends Area2D
class_name SummoningGuardStation

@export var spawn_points: Array[NodePath]
@export var guard_scene: PackedScene = null
@export var progress_value: float = 0.5

func toggle_indicator(value):
	$Indicator.visible = value

func summon_guard():
	var index = -1
	for point in GameManager.summon_points:
		if GameManager.summon_points[point] == null:
			index = point
	
	print(index)
	if index < 0:
		return false
	
	var guard = guard_scene.instantiate()
	get_node("/root/Restaurant").add_child(guard)
	guard.connect("health_depleted", _free_summon_point)

	var spawn_point = spawn_points[index]
	guard.global_position = get_node(spawn_point).global_position
	
	GameManager.summon_points[index] = guard
	
	return true

func progress():
	$ProgressBar.visible = true
	$ProgressBar.value += progress_value * get_process_delta_time()
	
	if $ProgressBar.value >= 1.0:
		$ProgressBar.value = 0.0
		summon_guard()

func reset_progress():
	$ProgressBar.visible = false
	$ProgressBar.value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(spawn_points.size()):
		GameManager.summon_points[i] = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _free_summon_point(guard):
	print("Guard died ", guard)
