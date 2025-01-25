extends Node3D



func _ready() -> void:
	pass

func random_on_sphere(radius : float) -> Vector3:
   # Generate random spherical coordinates
	var theta = 2 * PI * randf()
	var phi = PI * randf()
   
   # Convert to cartesiana
	var x = sin(phi) * cos(theta) * radius
	var y = sin(phi) * sin(theta) * radius
	var z = cos(phi) * radius
   
	return Vector3(x,y,z)
