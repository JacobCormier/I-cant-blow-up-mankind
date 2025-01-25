extends Node3D

var move_direction

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			# Check for left and right input
			if Input.is_action_pressed("ui_left"):
				move_direction = -1
			elif Input.is_action_pressed("ui_right"):
				move_direction = 1

func _process(delta: float) -> void:
	pass
