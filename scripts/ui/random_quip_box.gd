extends Control

@onready var dialogue_label: Label = $NinePatchRect/MarginContainer/DialogueLabel

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

func _process(delta: float) -> void:
	# timer runs to calculate when next message will be displayed
	current_interval_timer -= delta
	
	if current_interval_timer <= 0.0 and not is_triggered:
		_trigger_random_message()
			
func _reset_all() -> void:
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

func _trigger_random_message() -> void:
	# pick a message
	is_triggered = true
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(dialogue_label, "scale:y", 1.0, 1.0)
	tween.tween_callback(call_me_to_say_stuff)
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 2.0)
	tween.tween_callback(call_me_to_say_stuff)
	tween.tween_interval(1.5)
	tween.tween_property(dialogue_label, "scale:y", 0.01, 1.0)
	tween.tween_callback(call_me_to_say_stuff)
	tween.tween_callback(_reset_all)
	
	visible = true

func _trigger_death_message() -> void:
	_reset_all() 
	
	# select death message
	
	tween = get_tree().create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(dialogue_label, "scale:y", 1.0, 1.0)
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 2.0)
	tween.tween_interval(1.5)
	tween.tween_property(dialogue_label, "scale:y", 0.01, 1.0)
	
	visible = true

func call_me_to_say_stuff() -> void:
	say_stuff += 1
	
	print("STEP ", say_stuff)
	
	if say_stuff == 1:
		print("The box should be at 1 scale now")
	if say_stuff == 2:
		print("The box should be full of letters now")
	if say_stuff == 3:
		print("The box should be gone now!")
	
