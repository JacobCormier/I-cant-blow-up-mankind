extends Control

signal on_complete

@onready var dialogue_label: Label = $NinePatchRect/MarginContainer/DialogueLabel

@export var letter_reveal_speed = 16.0
@export var initial_delay = 0.0
@export var end_delay = 0.0

var is_triggered = false
var letters_count = 0

func _ready() -> void:
	dialogue_label.visible_characters = 0
	self.visible = false

func _process(delta: float) -> void:
	
	if is_triggered:
		letters_count += delta * letter_reveal_speed
		var int_letter_count = letters_count as int
		
		if int_letter_count > dialogue_label.visible_characters and dialogue_label.visible_characters < dialogue_label.get_total_character_count():
			dialogue_label.visible_characters = int_letter_count
			
		if int_letter_count > dialogue_label.get_total_character_count():
			await get_tree().create_timer(end_delay).timeout
			on_complete.emit()
			self.queue_free()

func trigger_dialogue() -> void:
	await get_tree().create_timer(initial_delay).timeout
	is_triggered = true
	self.visible = true
