extends Control

signal on_complete

@onready var body_art_1: Control = $BodyArt1
@onready var body_art_2: Control = $BodyArt2
@onready var body_art_3: Control = $BodyArt3

@export var letter_reveal_speed = 16.0
@export var initial_delay = 0.0
@export var end_delay = 0.0

var count = 0

func _ready():
	body_art_1.on_complete.connect(message_done)
	body_art_2.on_complete.connect(message_done)
	body_art_3.on_complete.connect(message_done)
	
	body_art_1.initial_delay = initial_delay
	body_art_1.letter_reveal_speed = letter_reveal_speed
	body_art_1.end_delay = end_delay
	
	body_art_2.initial_delay = initial_delay + 1
	body_art_2.letter_reveal_speed = letter_reveal_speed
	body_art_2.end_delay = end_delay -1
	
	body_art_3.initial_delay = initial_delay + 2
	body_art_3.letter_reveal_speed = letter_reveal_speed
	body_art_3.end_delay = end_delay - 2
	
func message_done():
	if count == 0:
		count += 1
		body_art_2.trigger_dialogue()
	if count == 1:
		count += 1
		body_art_3.trigger_dialogue()
	else:
		on_complete.emit()

func trigger_dialogue(timing: Vector2 = Vector2(initial_delay, end_delay)) -> void:
	initial_delay = timing.x
	end_delay = timing.y
	body_art_1.trigger_dialogue(timing)
