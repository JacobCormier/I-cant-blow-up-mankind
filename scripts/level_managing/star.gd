@tool
extends Node3D

var material

const white_color: Color = Color(1.0, 1.0, 1.0)
const red_color: Color = Color(0.918, 0.073, 0.0)
const blue_color: Color = Color(0.0, 0.944, 0.994)
const yellow_color: Color = Color(1.0, 0.858, 0.29)

var is_radiating: bool = false # Variable for modulating emission
var radiation_frequency: float

const MIN_RADIANCE = 0.5
const MAX_RADIANCE = 1.0

@onready var star_mesh: MeshInstance3D = $Visual/StarMesh

var color: Color

func _ready() -> void:
	var random_color = randi_range(1, 5)
	
	match random_color:
		1:
			color = red_color
		2:
			color = blue_color
		3:
			color = yellow_color
		_:
			color = white_color

	# Make the material unique and set it's color
	material = star_mesh.get_surface_override_material(0)
	material = material.duplicate()
	star_mesh.material_override = material
	material.emission = color
	material.albedo_color = color

func _process(delta: float) -> void:
	
	var new_emission = material.emission_energy_multiplier
	
	if is_radiating:
		new_emission = lerp(new_emission, MAX_RADIANCE, delta * radiation_frequency)
		if  new_emission / MAX_RADIANCE >= 0.9:
			is_radiating = false
		
	else:
		new_emission = lerp(new_emission, MIN_RADIANCE, delta * radiation_frequency)
		if MIN_RADIANCE / new_emission >= 0.9:
			is_radiating = true
			
	material.emission_energy_multiplier = new_emission
