extends Node3D

# Jacob Cormier 2025-01-25
# Add a radius for where the game takes place,
# and a different radius for the visual of the mesh


const globe_game_radius = 500
@export var sky_color: Color # Sky color
@export var planet_color: Color # Planet Color
@export var globe_visual_radius: float # Radius of the spinning globe
@export var obstacle_array_name: String # Identification for the obstacles
@export var decoration_array_name: String # Identification for the decorations


@onready var visual_container: Node3D = $VisualContainer
@onready var globe_visual: MeshInstance3D = $VisualContainer/GlobeVisual
@onready var area_3d: Area3D = $Area3D
@onready var game_ui: CanvasLayer = $"../GameUI"

const ORBIT_SPEED_X = 0.3
var orbit_speed_z_target : float
const MAX_Z_ORBIT_SPEED = 1.0
const z_transition_speed = 2.5

# Debug flag to change building movement behaviour to spawn rather than move
const CREATE_AND_STAY_INSTEAD_OF_MOVE = false

var orbit_speed_z: float:
	set(value):
		value = clampf(value, -MAX_Z_ORBIT_SPEED, MAX_Z_ORBIT_SPEED)
		orbit_speed_z = value


var direction: PlayerController.TurnDirection

func do_main_menu_tween(tween, attribute, target, time):
	tween.tween_property(globe_visual, attribute, target, time)

func _ready():
	area_3d.on_object_ready_for_reset.connect(_reset_building_for_points)
	Globals.on_fuel_pickup.connect(_reset_object)
	
	for x in range(0, 450):
		var size = Globals.level_1_buildings.size()
		var new_object = Globals.level_1_buildings[randi_range(0, size - 1)]
		create_object_at_random_point(new_object, globe_game_radius)
		
	for x in range(0, 100):
		var new_object = Globals.FUEL_CAN
		create_object_at_random_point(new_object, globe_game_radius)
		
	globe_visual.mesh.radius = globe_visual_radius
	globe_visual.mesh.height = globe_visual_radius * 2.0
	
func _process(delta: float) -> void:
		globe_visual.rotate_x(ORBIT_SPEED_X * delta)
		
		
		orbit_speed_z = lerpf(orbit_speed_z, orbit_speed_z_target, delta * z_transition_speed)
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
	# Get the sphere's global transform
	var sphere_transform = globe_visual.global_transform

	# Define the sphere's local up direction (global space, using transposed basis)
	var sphere_up = sphere_transform.basis.transposed().y

	# Generate a random point on the sphere's surface
	var phi = randf() * TAU  # Random azimuthal angle phi in [0, 2*pi]
	var z = randf() * 2 - 1  # Random z in [-1, 1] (full sphere)
	var local_radius = sqrt(1.0 - z * z)
	var x = radius * local_radius * cos(phi)
	var y = radius * local_radius * sin(phi)
	var local_point = Vector3(x, y, radius * z)

	# Transform the local point to global space
	var global_point = sphere_transform.origin + sphere_transform.basis * local_point

	# Check alignment with the sphere's up direction
	var direction_to_point = (global_point - sphere_transform.origin).normalized()
	var up_alignment = direction_to_point.dot(sphere_up)

	# If the point is too close to the top hemisphere, transpose it to the bottom
	if up_alignment > 0:
		global_point = sphere_transform.origin - (global_point - sphere_transform.origin)

	# Compute the surface normal in global space
	var normal = (global_point - sphere_transform.origin).normalized()

	return {"point": global_point, "normal": normal}

	
func create_object_at_random_point(object: PackedScene, radius: float):
	var sphere_radius = radius
	var result = random_point_on_bottom_of_sphere(sphere_radius)
	
	var point = result["point"]
	var normal = result["normal"]
	
	var new_object = object.instantiate()
	#new_object.parent = self
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

func place_object_at_random_point(object: Node3D ,radius: float):
	var sphere_radius = radius
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

func _reset_building_for_points(object: Node3D) -> void:
	# Technically, ANYTHING we reset with this is generating pointsd >:(
	PlayerStats.add_to_score(10)
	if CREATE_AND_STAY_INSTEAD_OF_MOVE:
		var size = Globals.level_1_buildings.size()
		var new_object = Globals.level_1_buildings[randi_range(0, size - 1)]
		create_object_at_random_point(new_object, globe_game_radius)
	else:
		place_object_at_random_point(object, globe_game_radius)
		
func _reset_object(object: Node3D) -> void:
	place_object_at_random_point(object, globe_game_radius)
