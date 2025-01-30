class_name SaveData
extends Resource

@export var endless_unlocked := false
@export var high_score := 0
@export var has_beaten_game := false
@export var has_exploded := false
@export var has_moved := false
@export var has_jumped := false


func check_high_score(score: int) -> void:
	if score > high_score:
		high_score = score
