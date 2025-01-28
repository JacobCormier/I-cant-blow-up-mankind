extends Node

signal on_fuel_pickup(object: Node3D)

const LEVEL_1 = preload("res://scenes/story_levels/1_level_1.tscn")

const level_1_buildings = [
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


const FUEL_CAN = preload("res://scenes/pickups/fuel_can.tscn")


func fuel_pickup(fuel_node: Node3D):
	on_fuel_pickup.emit(fuel_node)
