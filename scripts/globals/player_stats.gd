extends Node

# Used for a last touch to make the rocket speak
var is_talking = false

signal on_player_death
signal on_fuel_changed(fuel_amount: int)
signal on_score_changed(score_amount: int)
signal on_progress_changed(progress_value: int, progress_goal: int)

var is_gameplay_running := false

var loaded_endless_unlocked := false

var loaded_high_score := 0
var save_data: SaveData = null

var fuel_deterioration = 0.0
const FUEL_DETERIORATION_MULTIPLIER = 10.0

var progress_goal: int = 999999

var current_fuel: float:
	set(value):
		var excess = value - 100
		if excess > 0:
			current_progress += excess
		
		value = clampf(value, 0, 100)
		current_fuel = value
		on_fuel_changed.emit(value)
		
var current_score: float:
	set(value):
		value = clampf(value, 0.0, 9999999999.0)
		current_score = value
		check_high_score(value)
		on_score_changed.emit(value)

var is_progress_loaded := true
var current_progress: float:
	set(value):
		current_progress = value
		if is_gameplay_running:
			check_end_of_level(value)
		on_progress_changed.emit(value, progress_goal)

func _ready() -> void:
	_initialize_save_data()
	reload_fuel()
	on_player_death.connect(end_gameplay)

func _process(delta: float) -> void:
	if is_gameplay_running:
		_handle_fuel_deterioration(delta)
		_handle_score_updates(delta)
		
	if not is_progress_loaded:
		is_progress_loaded = true
		current_progress = current_progress
		

func reload_fuel(amount: int = 100):
	current_fuel += amount

func _handle_fuel_deterioration(delta: float) -> void:
	fuel_deterioration += delta * FUEL_DETERIORATION_MULTIPLIER
	
	if fuel_deterioration > 1.0:
		current_fuel -= 1.0
		fuel_deterioration -= 1.0
		if current_fuel == 0:
			on_player_death.emit()
			
func _handle_score_updates(delta: float) -> void:
	current_score += delta

func add_to_score(add_value: int) -> void:
	current_score += add_value
	
func initialize_progress_goal(new_progress_goal: int):
	progress_goal = new_progress_goal
	
func start_gameplay() -> void:
	SoundManager.kill_sound()
	MusicManager.play_music_sequence()
	SoundManager.start_engine()
	is_gameplay_running = true

func after_progress_goal_loaded() -> void:
	current_progress = 0
	is_progress_loaded = false

func end_gameplay() -> void:
	MusicManager.stop()
	SoundManager.play_nuclear_sound()
	SoundManager.kill_engine()
	is_gameplay_running = false
	is_progress_loaded = false
	
func check_end_of_level(value) -> void:
	if value >= progress_goal and progress_goal > 0:
		print("YOU WIN!")
		Globals.next_level()

#region Save Data

func check_high_score(score: float) -> void:
	save_data.check_high_score(score)
	trigger_save()
	loaded_high_score = save_data.high_score	
	
func unlock_endless() -> void:
	save_data.endless_unlocked = true
	trigger_save()
	loaded_endless_unlocked = save_data.endless_unlocked

func _initialize_save_data() -> void:
	if ResourceLoader.exists('user://save_data.tres'):
		save_data = load('user://save_data.tres')

	if save_data == null:
		save_data = SaveData.new()
		ResourceSaver.save(save_data, 'user://save_data.tres')
		
	loaded_high_score = save_data.high_score
	loaded_endless_unlocked = save_data.endless_unlocked

func trigger_save() -> void:
	ResourceSaver.save(save_data, 'user://save_data.tres')

#endregion
