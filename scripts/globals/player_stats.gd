extends Node

signal on_player_death
signal on_fuel_changed(fuel_amount: int)

var loaded_high_score := 0
var save_data: SaveData = null

var fuel_deterioration = 0.0
const FUEL_DETERIORATION_MULTIPLIER = 10.0

var current_fuel: float:
	set(value):
		value = clampf(value, 0, 100)
		current_fuel = value
		on_fuel_changed.emit(value)

func _ready() -> void:
	_initialize_save_data()
	reload_fuel()

func _process(delta: float) -> void:
	_handle_fuel_deterioration(delta)
		

func reload_fuel(amount: int = 100):
	print("picked up fuel!")
	current_fuel += amount

func _handle_fuel_deterioration(delta: float) -> void:
	fuel_deterioration += delta * FUEL_DETERIORATION_MULTIPLIER
	
	if fuel_deterioration > 1.0:
		current_fuel -= 1.0
		fuel_deterioration -= 1.0
		if current_fuel == 0:
			on_player_death.emit()

#region Save Data

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

#endregion
