extends Node3D

var target_turn_angle = 0.0 # Maximum angle in degrees for left/right movement
var MAX_TURN_ANGLE = 30.0
var is_turning = false
var current_turn_direction = PlayerController.TurnDirection.NONE # Direction flag
var turn_speed = 5.0 # Speed of turning
var current_angle = 0.0 # Current angle of the object

var original_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

func _ready() -> void:
	original_position = position

func _process(delta: float) -> void:
	if is_turning:
		_handle_turning(delta)
		
	# Random Rumble
	var random_rumble_x = original_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x)
	var random_rumble_y = original_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y)
	position = Vector3(random_rumble_x, random_rumble_y, position.z)
			
func _handle_turning(delta: float):
		# Determine the target angle based on the direction
		var target_angle = target_turn_angle
		
		# Smoothly interpolate the current angle towards the target angle
		current_angle = lerp(current_angle, target_angle, turn_speed * delta)
		
		# Apply the rotation to the object's Y-axis
		rotation_degrees.y = current_angle
	
		# Check if the current angle is close to the target angle to switch direction
		if abs(current_angle - target_angle) < 1.0: # A small threshold to detect when to reverse
			is_turning = false
			
func trigger_turn(direction: PlayerController.TurnDirection = PlayerController.TurnDirection.NONE):
	is_turning = true
	# Example usage

	match direction:
		PlayerController.TurnDirection.NONE:
			target_turn_angle = 0.0
		PlayerController.TurnDirection.LEFT:
			target_turn_angle = MAX_TURN_ANGLE
		PlayerController.TurnDirection.RIGHT:
			target_turn_angle = -MAX_TURN_ANGLE
	
