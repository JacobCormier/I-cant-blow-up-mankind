extends Node3D

@export var starting_altitude: int = 0

var target_turn_angle = 0.0 # Maximum angle in degrees for left/right movement
const MAX_TURN_ANGLE = 30.0
var is_turning = false
var current_turn_direction = PlayerController.TurnDirection.NONE # Direction flag
var turn_speed = 5.0 # Speed of turning
var current_angle = 0.0 # Current angle of the object

var target_tilt = 0.0
const MAX_TILT_ANGLE = 90.0
var is_tilting = false
var current_tilt = 0.0
var tilt_speed = 2.0

var origin_position
var current_root_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

var is_jumping := false
var jump_strength := 40
var gravity := 30
var vertical_speed := 0.0
	
func _ready() -> void:
	is_jumping = true
	visible = true

func _process(delta: float) -> void:	
	if origin_position == null:
		origin_position = Vector3(position.x, position.y , position.z - starting_altitude)
		current_root_position = position
	
	if is_turning:
		_handle_turning(delta)
		
	if is_jumping: 
		process_jump(delta)
		
	# Random Rumble
	var random_rumble_x = current_root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x)
	var random_rumble_y = current_root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y)
	position = Vector3(random_rumble_x, random_rumble_y, current_root_position.z)
			
func _handle_turning(delta: float):
		# Smoothly interpolate the current angle towards the target angle
		current_angle = lerp(current_angle, target_turn_angle, turn_speed * delta)
		
		# Apply the rotation to the object
		rotation_degrees.x = abs(current_angle)
		rotation_degrees.y = current_angle
		rotation_degrees.z = -2*current_angle

		# Check if the current angle is close to the target angle to switch direction
		if abs(current_angle- target_turn_angle) < 1.0: # A small threshold to detect when to reverse
			is_turning = false
		
func trigger_turn(direction: PlayerController.TurnDirection = PlayerController.TurnDirection.NONE):
	# This function is called often by the player controller to update what moves they are making
	is_turning = true
	is_tilting = true

	match direction:
		PlayerController.TurnDirection.NONE:
			target_turn_angle = 0.0
			# target_tilt = 0.0
		PlayerController.TurnDirection.LEFT:
			target_turn_angle = -MAX_TURN_ANGLE
			# target_tilt = MAX_TILT_ANGLE
		PlayerController.TurnDirection.RIGHT:
			target_turn_angle = MAX_TURN_ANGLE
			# target_tilt = -MAX_TILT_ANGLE

func trigger_jump():
	if not is_jumping:
		vertical_speed = jump_strength
		is_jumping = true
		
func process_jump(delta):
	if is_jumping: 
		if vertical_speed <= 0 and current_root_position.z <= origin_position.z:
			current_root_position = Vector3(current_root_position.x, current_root_position.y, current_root_position.z)
			is_jumping = false 
		else:
			current_root_position = Vector3(current_root_position.x, current_root_position.y, current_root_position.z + vertical_speed * delta)
			vertical_speed -= gravity * delta
