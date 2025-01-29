extends Control

@onready var dialogue_label: Label = $NinePatchRect/MarginContainer/DialogueLabel

@export var starting_messages: Array[String]
@export var random_messages: Array[String]
@export var death_messages: Array[String]

@export var MAX_INTERVAL : float = 15.0
@export var MIN_INTERVAL : float = 10.0
var current_interval_timer : float

var is_triggered = false
var letters_count = 0

var tween: Tween = null

var say_stuff: int = 0

func _ready() -> void:
	PlayerStats.on_player_death.connect(_trigger_death_message)
	_reset_all()
	is_triggered = true
	_trigger_starting_message()

func _process(delta: float) -> void:
	# timer runs to calculate when next message will be displayed
	current_interval_timer -= delta
	
	if current_interval_timer <= 0.0 and not is_triggered:
		_trigger_random_message()
			
func _reset_all() -> void:
	PlayerStats.is_talking = false
	self.visible = false
	if tween != null:
		tween.kill()
	tween = null
	is_triggered = false
	scale = Vector2(1.0, 0.01)
	dialogue_label.visible_ratio = 0.0
	_restart_interval_timer()

func _restart_interval_timer() -> void:
	current_interval_timer = randf_range(MIN_INTERVAL, MAX_INTERVAL)

func _trigger_starting_message() -> void:
	PlayerStats.is_talking = true
	var random_number = randi_range(0, starting_messages.size() - 1)
	dialogue_label.text = starting_messages[random_number]
	
	is_triggered = true
	tween = get_tree().create_tween()
	tween.tween_interval(0.3)
	tween_message()
	
	visible = true
func _trigger_random_message() -> void:
	PlayerStats.is_talking = true
	var random_number = randi_range(0, random_messages.size() - 1)
	dialogue_label.text = random_messages[random_number]
	
	is_triggered = true
	tween = get_tree().create_tween()
	tween_message()
	
	visible = true

func _trigger_death_message() -> void:
	_reset_all() 
	PlayerStats.is_talking = true
	
	var random_number = randi_range(0, death_messages.size() - 1)
	dialogue_label.text = death_messages[random_number]
	
	# select death message
	
	tween = get_tree().create_tween()
	tween.set_ignore_time_scale(true)
	tween_message()
	
	visible = true


func tween_message() -> void:
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale:y", 1.0, 0.5)
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 0.8)
	tween.tween_interval(2.3)
	tween.tween_property(self, "scale:y", 0.01, 0.3)
	tween.tween_callback(_reset_all)
