extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var building = Globals.ALL_BUILDINGS[randf_range(0, Globals.ALL_BUILDINGS.size())].instantiate()
	building.scale = Vector3(25,25,25)
	add_child(building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
