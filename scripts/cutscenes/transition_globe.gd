extends Node3D

const globe_game_radius = 500
@export var sky_color: Color # Sky color
@export var planet_color: Color # Planet Color
@export var globe_visual_radius: float # Radius of the spinning globe

@onready var custom_environment: WorldEnvironment = $"../CustomEnvironment"
@onready var visual_container: Node3D = $VisualContainer
@onready var globe_visual: MeshInstance3D = $VisualContainer/GlobeVisual

func on_ready():
	_setup_globe()
	
func _setup_globe() -> void:
	# Set up the globe based on export variables
	globe_visual.mesh.radius = globe_visual_radius
	globe_visual.mesh.height = globe_visual_radius * 2.0
	set_environment_color(planet_color, sky_color)
	
func set_environment_color(planet_color: Color, sky_color: Color) -> void:
	var globe_material = globe_visual.get_surface_override_material(0)
	globe_material.albedo_color = planet_color
	custom_environment.set_sky_color(sky_color)
	
