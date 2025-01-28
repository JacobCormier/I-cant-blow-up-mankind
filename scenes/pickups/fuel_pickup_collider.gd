extends Area3D

@export var fuel_amount: int

@onready var base_node: Node3D = $"../.."


func _on_area_entered(area: Area3D) -> void:
	# If they collide with the player:
	if area.collision_layer == 1:
		PlayerStats.reload_fuel(fuel_amount)
		SoundManager.play_pick_up_sound()
		
	# If a fuel can is colliding with anything, reset it's position
	Globals.fuel_pickup(base_node)
