extends RigidBody2D
class_name Item

@export var kind: String = "default"

var grabber: Player = null
var just_dropped = false
var dropped_velocity = Vector2.ZERO	
var transformed = false
var cooking_station: CookingStation = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func grab(player: Player):
	grabber = player
	cooking_station = null
	apply_central_force(Vector2.ZERO)
	print("grabbed by ", player)

func drop():
	just_dropped = true
	cooking_station = null
	dropped_velocity = grabber.velocity
	grabber = null

func cook(station: CookingStation):
	grabber.clear_item_in_hand()
	grabber = null
	cooking_station = station

func stop_cooking():
	cooking_station = null

func near_cooking_station(station: CookingStation):
	cooking_station = station

func left_cooking_station():
	cooking_station = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	if just_dropped:
		just_dropped = false
		state.linear_velocity = dropped_velocity
		state.apply_central_impulse(dropped_velocity * 1.4)

	if grabber != null:
		state.linear_velocity = Vector2.ZERO
		state.apply_central_force(Vector2.ZERO)
		state.apply_torque(0)
		state.transform = grabber.global_transform
	elif cooking_station != null:
		state.linear_velocity = Vector2.ZERO
		state.apply_central_force(Vector2.ZERO)
		state.apply_torque(0)
		state.transform = cooking_station.global_transform
