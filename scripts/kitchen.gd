extends Node2D

var spawned_a_monster = false
var tutorial_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var missing_guards = GameManager.summon_points_empty()
	$SummonGuardArea.toggle_indicator(missing_guards)
	
	if missing_guards:
		return
		
	var missing_monster = GameManager.current_enemy == null
	$SummonEnemyArea.toggle_indicator(missing_monster)
	$SummonEnemyArea2.toggle_indicator(missing_monster)
	
	if missing_monster and spawned_a_monster == false:
		return
	
	spawned_a_monster = true
	
	#var havent_cooked = GameManager.cooked_ingredients == 0
	#$CookingStationA.toggle_indicator(havent_cooked)
	#$CookingStationB.toggle_indicator(havent_cooked)
	#$CookingStationC.toggle_indicator(havent_cooked)
	#
	#if havent_cooked:
		#return
	
	var havent_made_meal = GameManager.assembled_meal == 0
	$PlateStation.toggle_indicator(havent_made_meal)
	
	if havent_made_meal:
		return
	
	tutorial_done = true
