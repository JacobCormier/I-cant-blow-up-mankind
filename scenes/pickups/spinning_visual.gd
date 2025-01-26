extends Node3D

@export var spin_speed := 0.0

func _process(delta: float) -> void:
	rotation = Vector3(rotation.x, rotation.y + (delta * spin_speed), rotation.z)
