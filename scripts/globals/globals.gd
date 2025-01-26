extends Node

var high_score := 0

const level_1_buildings = [preload("res://scenes/world/buildings/skyscraper_1.tscn"), 
						   preload("res://scenes/world/buildings/skyscraper_2.tscn")]

func check_high_score(score: float) -> void:
	if score > high_score:
		high_score = score
