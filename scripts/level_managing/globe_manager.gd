extends Node3D

# Jacob Cormier 2025-01-25
# Add a radius for where the game takes place,
# and a different radius for the visual of the mesh

@onready var visual_container: Node3D = $VisualContainer
@onready var globe_visual: MeshInstance3D = $VisualContainer/GlobeVisual
@onready var area_3d: Area3D = $Area3D

const ORBIT_SPEED_X = 0.3
var orbit_speed_z_target : float
const MAX_Z_ORBIT_SPEED = 0.8

var orbit_speed_z: float:
	set(value):
		value = clampf(value, -MAX_Z_ORBIT_SPEED, MAX_Z_ORBIT_SPEED)
		orbit_speed_z = value


var direction: PlayerController.TurnDirection

func _ready():
	area_3d.on_object_ready_for_reset.connect(_reset_object)
	
	for x in range(0, 150):
		var size = Globals.level_1_buildings.size()
		var new_object = Globals.level_1_buildings[randi_range(0, size - 1)]
		create_object_at_random_point(new_object)
	
func _process(delta: float) -> void:
		globe_visual.rotate_x(ORBIT_SPEED_X * delta)
		
		var transition_speed = 1.5
		orbit_speed_z = lerpf(orbit_speed_z, orbit_speed_z_target, delta * transition_speed)
		globe_visual.rotate_z(orbit_speed_z * delta)
		

# Function to generate a random point on the sphere and surface normal
func random_point_on_sphere(radius: float) -> Dictionary:
	# Random azimuthal angle phi in [0, 2*pi]
	var phi = randf() * TAU
	# Random z in [-1, 1]
	var z = randf() * 2.0 - 1.0
	# Compute the radius in the xy-plane
	var local_radius = sqrt(1.0 - z * z)
	# Cartesian coordinates scaled by the sphere's radius
	var x = radius * local_radius * cos(phi)
	var y = radius * local_radius * sin(phi)
	
	var point = Vector3(x, y, radius * z)
	
	# The surface normal is the normalized position vector
	var normal = point.normalized()
	
	return {"point": point, "normal": normal}	

# Function to generate a random point on the sphere and surface normal
func random_point_on_bottom_of_sphere(radius: float) -> Dictionary:
	# Random azimuthal angle phi in [0, 2*pi]
	var phi = randf() * TAU
	# This is a random value from -1 to 0,
	# but then when the orb rotates, those values are not on the bottom anymore
	# Random z in [-1, 0]
	var z = randf() - 1.0
	# Compute the radius in the xy-plane
	var local_radius = sqrt(1.0 - z * z)
	# Cartesian coordinates scaled by the sphere's radius
	var x = radius * local_radius * cos(phi)
	var y = radius * local_radius * sin(phi)
	
	var point = Vector3(x, y, radius * z)
	
	# The surface normal is the normalized position vector
	var normal = point.normalized()
	
	return {"point": point, "normal": normal}	
	
func create_object_at_random_point(object: PackedScene):
	var sphere_radius = globe_visual.mesh.radius
	var result = random_point_on_bottom_of_sphere(sphere_radius)
	
	var point = result["point"]
	var normal = result["normal"]
	
	var new_object = object.instantiate()
	globe_visual.add_child(new_object)
	
	new_object.global_transform.origin = point # Position the child at the random point
	
	# Align the block's up vector with the surface normal
	var up_vector = normal
	var forward_vector = Vector3.FORWARD
	if abs(forward_vector.dot(up_vector)) > 0.99:
		# If forward is too close to up, choose a different forward vector
		forward_vector = Vector3.RIGHT
	
	var right_vector = up_vector.cross(forward_vector).normalized()
	forward_vector = right_vector.cross(up_vector).normalized()
	
	var basis = Basis(right_vector, up_vector, forward_vector)
	var transform = new_object.transform
	transform.origin = point
	transform.basis = basis
	new_object.transform = transform

func place_object_at_random_point(object: Node3D):
	var sphere_radius = globe_visual.mesh.radius
	var result = random_point_on_bottom_of_sphere(sphere_radius)
	
	var point = result["point"]
	var normal = result["normal"]
	
	object.global_transform.origin = point # Position the child at the random point
	
	# Align the block's up vector with the surface normal
	var up_vector = normal
	var forward_vector = Vector3.FORWARD
	
	# Not sure if this is being used
	if abs(forward_vector.dot(up_vector)) > 0.99:
		# If forward is too close to up, choose a different forward vector
		forward_vector = Vector3.RIGHT
	
	var right_vector = up_vector.cross(forward_vector).normalized()
	forward_vector = right_vector.cross(up_vector).normalized()
	
	var basis = Basis(right_vector, up_vector, forward_vector)
	var transform = object.transform
	transform.origin = point
	transform.basis = basis
	object.transform = transform

func pass_in_movement_direction(direction: PlayerController.TurnDirection):
	match direction:
		PlayerController.TurnDirection.NONE:
			orbit_speed_z_target = 0.0
		PlayerController.TurnDirection.LEFT:
			orbit_speed_z_target = -MAX_Z_ORBIT_SPEED
		PlayerController.TurnDirection.RIGHT:
			orbit_speed_z_target = MAX_Z_ORBIT_SPEED

func _reset_object(object: Node3D) -> void:
	place_object_at_random_point(object)
