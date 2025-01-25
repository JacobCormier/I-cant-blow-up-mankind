class_name PlayerController
extends Node3D

@onready var icbm_model: Node3D = $ICBM
@onready var globe_test: MeshInstance3D = $"../GlobeManager/GlobeTest"

enum TurnDirection {NONE, LEFT, RIGHT}

func _input(event: InputEvent) -> void:
	if event is InputEventKey:  # Check if it's a key event
		if event.pressed:  # Check if the key was pressed
			if Input.is_action_pressed("ui_left"):
				icbm_model.turn(TurnDirection.LEFT)
			elif Input.is_action_pressed("ui_right"):
				icbm_model.turn(TurnDirection.RIGHT)
		elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
			icbm_model.turn(TurnDirection.NONE)
