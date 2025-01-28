extends Node3D

@onready var rocket_particles: Node3D = $ICBM/rocket_particles

func _ready() -> void:
	rocket_particles.gpu_particles_3d.emitting = false
