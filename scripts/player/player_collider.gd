extends Area3D

func _on_area_entered(area: Area3D) -> void:
	PlayerStats.on_player_death.emit()
