extends Control

signal on_complete

@onready var icbm_header: Control = $ICBMHeader
@onready var icbm_header_2: Control = $ICBMHeader2

@export var letter_reveal_speed = 16.0
@export var initial_delay = 0.0
@export var end_delay = 0.0

var count = 0

func _ready():
	icbm_header.on_complete.connect(message_done)
	icbm_header_2.on_complete.connect(message_done)
	
	icbm_header.initial_delay = initial_delay
	icbm_header.letter_reveal_speed = letter_reveal_speed
	icbm_header.end_delay = end_delay / 2
	
	icbm_header_2.initial_delay = initial_delay + end_delay / 2
	icbm_header_2.letter_reveal_speed = letter_reveal_speed
	icbm_header_2.end_delay = end_delay / 2
	
func message_done():
	if count == 0:
		count += 1
		icbm_header_2.trigger_dialogue()
	else:
		on_complete.emit()

func trigger_dialogue(timing: Vector2 = Vector2(initial_delay, end_delay)) -> void:
	initial_delay = timing.x
	end_delay = timing.y
	icbm_header.trigger_dialogue(timing)
