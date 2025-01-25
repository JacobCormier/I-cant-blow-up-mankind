extends Node3D

var MAX_TURN_ANGLE = 30.0 # Maximum angle in degrees for left/right movement
var is_going_right = true # Direction flag
var turn_speed = 5.0 # Speed of turning
var current_angle = 0.0 # Current angle of the object

func _process(delta: float) -> void:
	# Determine the target angle based on the direction
	var target_angle = MAX_TURN_ANGLE if is_going_right else -MAX_TURN_ANGLE
	
	# Smoothly interpolate the current angle towards the target angle
	current_angle = lerp(current_angle, target_angle, turn_speed * delta)
	
	# Apply the rotation to the object's Y-axis
	rotation_degrees.y = current_angle
	
	# Check if the current angle is close to the target angle to switch direction
	if abs(current_angle - target_angle) < 1.0: # A small threshold to detect when to reverse
		is_going_right = not is_going_right # Reverse direction
