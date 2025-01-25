extends Node3D

@onready var globe_test: MeshInstance3D = $GlobeTest
const TEST_BUILDING = preload("res://scenes/dev/test_building.tscn")

const ORBIT_SPEED_X = 0.3
var orbit_speed_z_target : float
const MAX_Z_ORBIT_SPEED = 0.3

var orbit_speed_z: float:
	set(value):
		value = clampf(value, -MAX_Z_ORBIT_SPEED, MAX_Z_ORBIT_SPEED)
		orbit_speed_z = value


var direction: PlayerController.TurnDirection

func _ready():
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	create_block_at_random_point()
	
func _process(delta: float) -> void:
		globe_test.rotate_x(ORBIT_SPEED_X * delta)
		
		var transition_speed = 1.0
		orbit_speed_z = lerpf(orbit_speed_z, orbit_speed_z_target, delta * transition_speed)
		globe_test.rotate_z(orbit_speed_z * delta)
		

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
	
func create_block_at_random_point():
	
	var sphere_radius = globe_test.mesh.radius
	var result = random_point_on_sphere(sphere_radius)
	
	var point = result["point"]
	var normal = result["normal"]
	
	print("Random point on sphere:", point)
	print("Surface normal:", normal)
	
	var new_block = TEST_BUILDING.instantiate()
	globe_test.add_child(new_block)
	new_block.position = point
	
	new_block.global_transform.origin = point # Position the child at the random point
	new_block.look_at(point + normal, Vector3.UP) # Align the child with the surface normal

func pass_in_movement_direction(direction: PlayerController.TurnDirection):
	match direction:
		PlayerController.TurnDirection.NONE:
			orbit_speed_z_target = 0.0
		PlayerController.TurnDirection.LEFT:
			orbit_speed_z_target = -MAX_Z_ORBIT_SPEED
		PlayerController.TurnDirection.RIGHT:
			orbit_speed_z_target = MAX_Z_ORBIT_SPEED
