extends Area3D

@onready var player: PlayerController = $"../.."


func _on_area_entered(area: Area3D) -> void:
	player.on_player_death.emit()
