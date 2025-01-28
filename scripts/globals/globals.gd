extends Node

signal on_fuel_pickup(object: Node3D)

const MAIN_MENU = preload("res://scenes/story_levels/0_main_menu.tscn")
const LEVEL_1 = preload("res://scenes/story_levels/1_level_1.tscn")
const LEVEL_2 = preload("res://scenes/story_levels/2_level_2.tscn")
const LEVEL_3 = preload("res://scenes/story_levels/3_level_3.tscn")
const ARCADE = preload("res://scenes/endless_levels/arcade.tscn")
const FIRST_PERSON = preload("res://scenes/endless_levels/first_person.tscn")
const STANDARD = preload("res://scenes/endless_levels/standard.tscn")

var current_level = 1

const level_1_buildings = [
	preload("res://scenes/world/buildings/small_1.tscn"),
	preload("res://scenes/world/buildings/small_2.tscn"),
	preload("res://scenes/world/buildings/small_3.tscn"),
	preload("res://scenes/world/buildings/small_4.tscn"),
	preload("res://scenes/world/buildings/small_5.tscn"),
	preload("res://scenes/world/buildings/small_6.tscn")
]

const level_2_buildings = [
	preload("res://scenes/world/buildings/large_1.tscn"),
	preload("res://scenes/world/buildings/large_2.tscn"),
	preload("res://scenes/world/buildings/large_3.tscn"),
	preload("res://scenes/world/buildings/large_4.tscn"),
	preload("res://scenes/world/buildings/large_5.tscn"),
	preload("res://scenes/world/buildings/large_6.tscn"),
	preload("res://scenes/world/buildings/skyscraper_1.tscn"),
	preload("res://scenes/world/buildings/skyscraper_2.tscn"),
	preload("res://scenes/world/buildings/skyscraper_3.tscn"),
	preload("res://scenes/world/buildings/skyscraper_4.tscn"),
	preload("res://scenes/world/buildings/skyscraper_5.tscn"),
	preload("res://scenes/world/buildings/skyscraper_6.tscn"),
	preload("res://scenes/world/buildings/small_1.tscn"),
	preload("res://scenes/world/buildings/small_2.tscn"),
	preload("res://scenes/world/buildings/small_3.tscn"),
	preload("res://scenes/world/buildings/small_4.tscn"),
	preload("res://scenes/world/buildings/small_5.tscn"),
	preload("res://scenes/world/buildings/small_6.tscn")
]

const level_3_buildings = [ # Plan to change this to asteroids instead, maybe with random y value added
	preload("res://scenes/world/asteroids/Asteroid_1.tscn")
]


const FUEL_CAN = preload("res://scenes/pickups/fuel_can.tscn")
const GOLDEN_FUEL_CAN = preload("res://scenes/pickups/golden_fuel_can.tscn")

func fuel_pickup(fuel_node: Node3D):
	on_fuel_pickup.emit(fuel_node)
	
func set_level(level_code: int) -> void:
	current_level = level_code	
	
func next_level() -> void:
	if current_level <= 0:
		printerr("Globals::next_level() was called with an invalid level: ", current_level)
		return
	else:
		if current_level == 3:
			# Final Level complete!
			# transition out of this to final scene
			return
		else:
			# Increment to next level
			current_level += 1
			
	match current_level:
		1: 
			get_tree().change_scene_to_packed(Globals.LEVEL_1)
		2:
			get_tree().change_scene_to_packed(Globals.LEVEL_2)
		3:
			get_tree().change_scene_to_packed(Globals.LEVEL_3)
		_:
			printerr("Globals::next_level() was called with an invalid level: ", current_level)
	
func restart_level() -> void:
	if current_level <= 0:
		get_tree().reload_current_scene()
	else:
		current_level = 1
		get_tree().change_scene_to_packed(Globals.LEVEL_1)
	
func get_current_level_obstacles() -> Array:
	if current_level == 1:
		# Level 1, short buildings only, more fuel
		return level_1_buildings
	elif current_level == 2:
		# Level 2, Mix of buildings, average fuel
		return level_2_buildings
	elif current_level == 3:
		# Level 3, Asteroids (Eventually), Lower fuel
		return level_3_buildings
	elif current_level == -1:
		# Endless mode
		return level_2_buildings
		pass
	else:
		print("Globals::get_current_level_obstacles --- INVALID LEVEL REQUESTED")
		
	return []

func get_current_level_decorations() -> Array:
	if current_level == 3:
		# only the space level has decorations for the planet
		return level_2_buildings
		
	return []
