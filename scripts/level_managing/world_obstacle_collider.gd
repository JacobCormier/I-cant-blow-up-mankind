extends Area3D

signal on_object_ready_for_reset(object: Node3D)

func _on_area_entered(area: Area3D) -> void:
	var collided_object = area.base_node
	if collided_object != null:
		on_object_ready_for_reset.emit(collided_object)
		
