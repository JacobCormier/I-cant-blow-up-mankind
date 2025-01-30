extends Control

signal on_complete

@onready var cant: Label = $NinePatchRect/Cant
@onready var blow_up: Label = $NinePatchRect/BlowUp
@onready var mankind: Label = $NinePatchRect/Mankind
@onready var dialogue_label: Label = $NinePatchRect/DialogueLabel

@export var letter_reveal_speed = 16.0
@export var initial_delay = 0.0
@export var end_delay = 0.0

var is_triggered = false
var letters_count = 0

func _ready() -> void:
	dialogue_label.visible_characters = 0
	self.visible = false
	self.scale = Vector2(1.0, 0.01)

func _process(delta: float) -> void:
	
	if is_triggered:
		letters_count += delta * letter_reveal_speed
		var int_letter_count = letters_count as int
		
		if int_letter_count > dialogue_label.visible_characters and dialogue_label.visible_characters < dialogue_label.get_total_character_count():
			dialogue_label.visible_characters = int_letter_count
			
		if int_letter_count > dialogue_label.get_total_character_count():
			await get_tree().create_timer(end_delay).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale:y", 0.01, 0.1)
			tween.tween_callback(_finish_dialogue)
			


func trigger_dialogue() -> void:
	await get_tree().create_timer(initial_delay).timeout
	self.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:y", 1.0, 0.2)
	tween.tween_callback(_trigger_text)

func _trigger_text() -> void:
	is_triggered = true

func _finish_dialogue() -> void:
	on_complete.emit()
	self.queue_free()
