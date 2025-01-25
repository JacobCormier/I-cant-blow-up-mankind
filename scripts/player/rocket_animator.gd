extends Node3D

enum TurnDirection {NONE, LEFT, RIGHT}

var target_turn_angle = 0.0 # Maximum angle in degrees for left/right movement
var MAX_TURN_ANGLE = 30.0
var is_turning = false
var current_turn_direction = TurnDirection.NONE # Direction flag
var turn_speed = 5.0 # Speed of turning
var current_angle = 0.0 # Current angle of the object

func _input(event: InputEvent) -> void:
	if event is InputEventKey:  # Check if it's a key event
		if event.pressed:  # Check if the key was pressed
			if Input.is_action_pressed("ui_left"):
				turn(TurnDirection.LEFT)
			elif Input.is_action_pressed("ui_right"):
				turn(TurnDirection.RIGHT)
		elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
			turn(TurnDirection.NONE)
			

func _process(delta: float) -> void:
	if is_turning:
		# Determine the target angle based on the direction
		var target_angle = target_turn_angle
		
		# Smoothly interpolate the current angle towards the target angle
		current_angle = lerp(current_angle, target_angle, turn_speed * delta)
		
		# Apply the rotation to the object's Y-axis
		rotation_degrees.y = current_angle
	
		# Check if the current angle is close to the target angle to switch direction
		if abs(current_angle - target_angle) < 1.0: # A small threshold to detect when to reverse
			is_turning = false

func turn(direction: TurnDirection = TurnDirection.NONE):
	is_turning = true
	# Example usage

	match direction:
		TurnDirection.NONE:
			target_turn_angle = 0.0
		TurnDirection.LEFT:
			target_turn_angle = MAX_TURN_ANGLE
		TurnDirection.RIGHT:
			target_turn_angle = -MAX_TURN_ANGLE
	
