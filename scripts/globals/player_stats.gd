extends Node

var loaded_high_score := 0
var save_data: SaveData = null

func _ready() -> void:
	_initialize_save_data()

func check_high_score(score: float) -> void:
	save_data.check_high_score(score)
	trigger_save()
	loaded_high_score = save_data.high_score


func _initialize_save_data() -> void:
	if ResourceLoader.exists('user://save_data.tres'):
		save_data = load('user://save_data.tres')

	if save_data == null:
		save_data = SaveData.new()
		ResourceSaver.save(save_data, 'user://save_data.tres')
		
	loaded_high_score = save_data.high_score
	
	# Jacob Cormier
	# Add check for if high_score is > 1 for skipping intro


func trigger_save() -> void:
	ResourceSaver.save(save_data, 'user://save_data.tres')
