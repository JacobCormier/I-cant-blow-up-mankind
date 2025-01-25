class_name PlayerController
extends Node3D

@onready var icbm_model: Node3D = $ICBM
@onready var globe_test: MeshInstance3D = $"../GlobeManager/GlobeTest"

var current_turn_direction = TurnDirection.NONE
enum TurnDirection {NONE, LEFT, RIGHT}

var is_input_left := false
var is_input_right := false

func _input(event: InputEvent) -> void:
	
	# Read input Actions
	if event is InputEventKey:  # Check if it's a key event
		if event.pressed:  # Check if the key was pressed
			if Input.is_action_pressed("ui_left") and not is_input_left:
				is_input_left = true
			elif Input.is_action_pressed("ui_right") and not is_input_right:
				is_input_right = true
		elif event.is_action_released("ui_left") and is_input_left:
			is_input_left = false
		elif event.is_action_released("ui_right") and is_input_right:
			is_input_right = false

	# Check Left-Right Controls
	if is_input_left and is_input_right:
		current_turn_direction = TurnDirection.NONE
		icbm_model.trigger_turn(current_turn_direction)
	elif is_input_left:
		current_turn_direction = TurnDirection.LEFT
		icbm_model.trigger_turn(current_turn_direction)
	elif is_input_right:
		current_turn_direction = TurnDirection.RIGHT
		icbm_model.trigger_turn(current_turn_direction)
	else:
		current_turn_direction = TurnDirection.NONE
		icbm_model.trigger_turn(current_turn_direction)
		
	# Next is Left right movement
	
	
