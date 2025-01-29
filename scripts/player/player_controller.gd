class_name PlayerController
extends Node3D

@onready var globe_manager: Node3D = $"../GameGlobe"
@onready var game_ui: CanvasLayer = $"../GameUI"
@onready var icbm_character: Node3D = $ICBMCharacter

@export var starting_altitude: int = 0

enum TurnDirection {NONE, LEFT, RIGHT}
var current_turn_direction = TurnDirection.NONE

var is_input_left := false
var is_input_right := false
var is_input_jumping := false

func _ready() -> void:
	PlayerStats.on_player_death.connect(_trigger_player_death)
	icbm_character.starting_altitude = starting_altitude
	Engine.time_scale = 1.0

func _input(event: InputEvent) -> void:
	# Read input Actions

	if Input.is_action_pressed("left") and not is_input_left:
		is_input_left = true
	elif Input.is_action_pressed("right") and not is_input_right:
		is_input_right = true
	elif event.is_action_released("left") and is_input_left:
		is_input_left = false
	elif event.is_action_released("right") and is_input_right:
		is_input_right = false

	if Input.is_action_pressed("jump") and not is_input_jumping:
		is_input_jumping = true
	if event.is_action_released("jump") and is_input_jumping:
		is_input_jumping = false

	# Check Left-Right Controls
	if is_input_left and is_input_right:
		current_turn_direction = TurnDirection.NONE
		SoundManager.stop_engine()
	elif is_input_left:
		current_turn_direction = TurnDirection.LEFT
		SoundManager.trigger_engine()
	elif is_input_right:
		current_turn_direction = TurnDirection.RIGHT
		SoundManager.trigger_engine()
	else:
		current_turn_direction = TurnDirection.NONE
		SoundManager.stop_engine()
		
	icbm_character.trigger_turn(current_turn_direction)
		
	if is_input_jumping:
		icbm_character.trigger_jump()
		
	# Next is Left right movement
	globe_manager.pass_in_movement_direction(current_turn_direction)
	
func _trigger_player_death() -> void:
	game_ui.trigger_death()
	#  icbm_character.trigger_death()
	Engine.time_scale = 0.0
