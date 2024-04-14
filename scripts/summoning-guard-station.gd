extends Area2D
class_name SummoningGuardStation

@export var spawn_points: Array[NodePath]
@export var guard_scene: PackedScene = null
@export var progress_value: float = 0.5

func summon_guard():
	var guard = guard_scene.instantiate()
	get_node("/root/Restaurant").add_child(guard)
	
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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
