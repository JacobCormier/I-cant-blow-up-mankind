class_name PlayerController
extends Node3D

signal on_player_death

@onready var icbm_model: Node3D = $ICBM
@onready var globe_manager: Node3D = $"../GameGlobe"

enum TurnDirection {NONE, LEFT, RIGHT}
var current_turn_direction = TurnDirection.NONE


var is_input_left := false
var is_input_right := false
var is_input_jumping := false

func _ready() -> void:
	on_player_death.connect(_trigger_player_death)

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
	if event is InputEventKey:  # Check if it's a key event
		if event.pressed:  # Check if the key was pressed
			if Input.is_action_pressed("ui_select") and not is_input_jumping:
				is_input_jumping = true
		if event.is_action_released("ui_select") and is_input_jumping:
			is_input_jumping = false

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
		
	if is_input_jumping:
		icbm_model.trigger_jump()
		
	# Next is Left right movement
	globe_manager.pass_in_movement_direction(current_turn_direction)
	
func _trigger_player_death() -> void:
	print("YOU DIED!")
