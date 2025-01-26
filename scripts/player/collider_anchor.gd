extends Node3D

const MAX_TURN_ANGLE = 30.0

var target_turn_angle = 0.0
var is_turning = false
var current_angle = 0.0
var turn_speed = 5.0

func _process(delta: float) -> void:	
	if is_turning:
		_handle_turning(delta)

func trigger_turn(direction: PlayerController.TurnDirection = PlayerController.TurnDirection.NONE):
	# This function is called often by the player controller to update what moves they are making
	is_turning = true

	match direction:
		PlayerController.TurnDirection.NONE:
			target_turn_angle = 0.0
		PlayerController.TurnDirection.LEFT:
			target_turn_angle = -MAX_TURN_ANGLE
		PlayerController.TurnDirection.RIGHT:
			target_turn_angle = MAX_TURN_ANGLE

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
