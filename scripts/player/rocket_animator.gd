extends Node3D

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

var original_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

func _ready() -> void:
	original_position = position

func _process(delta: float) -> void:
	if is_turning:
		_handle_turning(delta)
	#Tilting isn't gonna work yet cause Quaternions suck
	#if is_tilting:
		#_handle_tilting(delta)
		
	# Random Rumble
	var random_rumble_x = original_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x)
	var random_rumble_y = original_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y)
	position = Vector3(random_rumble_x, random_rumble_y, position.z)
			
func _handle_turning(delta: float):
		# Smoothly interpolate the current angle towards the target angle
		current_angle = lerp(current_angle, target_turn_angle, turn_speed * delta)
		
		# Apply the rotation to the object's Y-axis
		rotation_degrees.y = current_angle

		# Check if the current angle is close to the target angle to switch direction
		if abs(current_angle- target_turn_angle) < 1.0: # A small threshold to detect when to reverse
			is_turning = false

			
func _handle_tilting(delta: float):
	# Jacob Cormier 2025-01-25
	# Deprecated, will most likely set up an animation to tilt
		current_tilt = lerp(current_tilt, target_tilt, tilt_speed * delta)
		
		rotation_degrees.z = current_tilt
		
		if abs(current_tilt - target_tilt) < 1.0: # A small threshold to detect when to reverse
			is_tilting = false
		
func trigger_turn(direction: PlayerController.TurnDirection = PlayerController.TurnDirection.NONE):
	# This function is called often by the player controller to update what moves they are making
	is_turning = true
	is_tilting = true

	match direction:
		PlayerController.TurnDirection.NONE:
			target_turn_angle = 0.0
			# target_tilt = 0.0
		PlayerController.TurnDirection.LEFT:
			target_turn_angle = MAX_TURN_ANGLE
			# target_tilt = MAX_TILT_ANGLE
		PlayerController.TurnDirection.RIGHT:
			target_turn_angle = -MAX_TURN_ANGLE
			# target_tilt = -MAX_TILT_ANGLE
	
