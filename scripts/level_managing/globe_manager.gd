extends Node3D

# Jacob Cormier 2025-01-25
# Add a radius for where the game takes place,
# and a different radius for the visual of the mesh


const globe_game_radius = 500
@export var sky_color: Color # Sky color
@export var planet_color: Color # Planet Color
@export var globe_visual_radius: float # Radius of the spinning globe
@export var level_data: LevelData # Resource for the level data

@onready var custom_environment: WorldEnvironment = $"../CustomEnvironment"

@onready var visual_container: Node3D = $VisualContainer
@onready var globe_visual: MeshInstance3D = $VisualContainer/GlobeVisual
@onready var area_3d: Area3D = $Area3D
@onready var game_ui: CanvasLayer = $"../GameUI"

@onready var wave_timer: Timer = $WaveTimer

const ORBIT_SPEED_X = 0.3
var orbit_speed_z_target : float
const MAX_Z_ORBIT_SPEED = 1.0
const z_transition_speed = 2.5

var orbit_speed_z: float:
	set(value):
		value = clampf(value, -MAX_Z_ORBIT_SPEED, MAX_Z_ORBIT_SPEED)
		orbit_speed_z = value


var direction: PlayerController.TurnDirection

func do_main_menu_tween(tween, attribute, target, time):
	tween.tween_property(globe_visual, attribute, target, time)

func _ready():
	wave_timer.wait_time = level_data.wave_frequency
	wave_timer.timeout.connect(_spawn_wave)
	wave_timer.start()
	area_3d.on_object_ready_for_reset.connect(_reset_building_for_points)
	Globals.on_fuel_pickup.connect(_reset_object)
	PlayerStats.initialize_progress_goal(level_data.progress_goal)
	
	Globals.current_level = 3
	
	_setup_globe()
	
	for x in range(0, level_data.initial_obstacles):
		_create_obstacle()
		
	for x in range(0, level_data.initial_fuel):
		_create_fuel()	
		
	var decorations = Globals.get_current_level_decorations()
	if decorations.size() > 0:
		# Create decorations at globe_visual_radius using random_point_on_sphere
		for x in range(0, 400):
			_create_decoration()
	
func _process(delta: float) -> void:
		globe_visual.rotate_x(ORBIT_SPEED_X * delta)
		
		
		orbit_speed_z = lerpf(orbit_speed_z, orbit_speed_z_target, delta * z_transition_speed)
		globe_visual.rotate_z(orbit_speed_z * delta)
		
#region Sphere Positioning

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

func create_object_at_random_point(object: PackedScene, radius: float):
	# THIS IS USED ONLY FOR DECORATIONS
	# DO NOT USE FOR OBSTACLES
	var sphere_radius = radius
	var result = random_point_on_sphere(sphere_radius)
	
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
	new_object.scale = new_object.scale / 2.0
	new_object.collider.queue_free()

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

func create_object_at_random_bottom_point(object: PackedScene, radius: float):
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

func place_object_at_random_bottom_point(object: Node3D ,radius: float):
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
	
#endregion 

func _setup_globe() -> void:
	# Set up the globe based on export variables
	globe_visual.mesh.radius = globe_visual_radius
	globe_visual.mesh.height = globe_visual_radius * 2.0
	var globe_material = globe_visual.get_surface_override_material(0)
	globe_material.albedo_color = planet_color
	custom_environment.set_sky_color(sky_color)
	

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
	place_object_at_random_bottom_point(object, globe_game_radius)	
		
func _reset_object(object: Node3D) -> void:
	place_object_at_random_bottom_point(object, globe_game_radius)

func _create_fuel() -> void:
		var new_object
		# Golden Fuel Cans have a 20% of spawning
		var random_selection = randi_range(0, 4)
		if random_selection != 0:
			new_object = Globals.FUEL_CAN
		else:
			new_object = Globals.GOLDEN_FUEL_CAN
		create_object_at_random_bottom_point(new_object, globe_game_radius)

func _create_obstacle() -> void:
	var obstacles = Globals.get_current_level_obstacles()
	var size = obstacles.size()
	var new_object = obstacles[randi_range(0, size - 1)]
	create_object_at_random_bottom_point(new_object, globe_game_radius)

func _spawn_wave() -> void:
	print("WAVE SPAWNED")
	for x in range(0, level_data.obstacles_per_wave):
		_create_obstacle()
		
	for x in range(0, level_data.fuel_per_wave):
		_create_fuel()

func _create_decoration() -> void:
	var decorations = Globals.get_current_level_decorations()
	var size = decorations.size()
	var new_deco = decorations[randi_range(0, size - 1)]
	create_object_at_random_point(new_deco, globe_visual_radius)

func get_progress_goal() -> int:
	return level_data.progress_goal
