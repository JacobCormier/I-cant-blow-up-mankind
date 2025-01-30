extends CanvasLayer

@onready var icbm_text: Control = $ICBMText
@onready var header_developed_by: Control = $HeaderDevelopedBy
@onready var body_developed_by: Control = $BodyDevelopedBy
@onready var header_music: Control = $HeaderMusic
@onready var body_music: Control = $BodyMusic
@onready var header_art: Control = $HeaderArt
@onready var body_art_1: Control = $BodyArt
@onready var body_art_2: Control = $BodyArt2
@onready var header_sound: Control = $HeaderSound
@onready var body_sound: Control = $BodySound
@onready var header_special_thanks: Control = $HeaderSpecialThanks
@onready var body_special_thanks: Control = $BodySpecialThanks
@onready var body_final_statement: Control = $BodyFinalStatement
@onready var thank_you: Control = $ThankYou
@onready var unlocked_endless: Control = $UnlockedEndless
@onready var body_art_3: Control = $BodyArt3

var current_step = 0
var story_array = []

var show_text_box = false
var total_time = 0.0

var start_phase = false
var phase_start = 0.0
var phase_end = 0.0

var current_phase_playing = 0
var current_phase: Phase = null
var prev_phase: Phase = null
var phases: Array = []
var phase_data = []
var playing = false

func _ready() -> void:
	phases = Phase.from_array(phase_data)
	phase_data = [
		{ "header": icbm_text, "body": null, "timing": Vector2(0,4) },
		{ "header": header_developed_by, "body": body_developed_by, "timing": Vector2(3,6) },
		{ "header": header_music, "body": body_music, "timing": null },
		{ "header": header_sound, "body": body_sound, "timing": null },
		{ "header": header_art, "body": body_art_1, "timing": null },
		{ "header": header_art, "body": body_art_2, "timing": null },
		{ "header": header_art, "body": body_art_3, "timing": null },
		{ "header": header_special_thanks, "body": body_special_thanks, "timing": null },
		{ "header": body_final_statement, "body": null, "timing": null },
		{ "header": thank_you, "body": null, "timing": null },
		{ "header": unlocked_endless, "body": null, "timing": null }
	]

	# Find the first phase with `timing == null`
	for phase in phases:
		phase.on_complete.connect(message_complete)
		if current_phase == null and phase.timing == null:
			current_phase = phase
			current_phase.timing = Vector2(0, 0)  # Initialize timing

	if not current_phase:
		print("No valid phase found with timing == null.")

func _process(delta):
	total_time += delta
	
	if current_phase_playing >= phase_data.size():
		Phase.print_phases(phases)
	elif not playing and phase_data[current_phase_playing].timing:
		if phase_data[current_phase_playing].timing.x >= total_time:
			phase_data[current_phase_playing].play()
			playing = true

func message_complete():
	current_phase_playing += 1
	playing = false

func _input(event):
	# Start the dialogue when SPACE is pressed
	if event.is_action_pressed("jump") and not show_text_box:
		print("jump")
		if current_phase:
			show_text_box = true
			current_phase.timing.x = total_time
			current_phase.play()
		
		if prev_phase:
			prev_phase.timing.y = total_time
		
		prev_phase = current_phase

	# When SPACE is released, record `timing.x` (message open time)
	elif event.is_action_released("jump") and show_text_box:
		print("released")
		show_text_box = false
