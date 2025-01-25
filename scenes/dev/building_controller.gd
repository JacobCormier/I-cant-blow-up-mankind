extends Node3D

var building
var mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_building()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func new_building(index = -1):
	if not building == null:
		remove_child(building)
	
	var building_index = index
	if building_index == -1:
		building_index = randf_range(0, Globals.ALL_BUILDINGS.size())

	building = Globals.ALL_BUILDINGS[building_index].instantiate()
	building.scale = Vector3(25,25,25)
	building.position = Vector3(building.position.x,building.position.y-2.5,building.position.z)
	add_child(building)
