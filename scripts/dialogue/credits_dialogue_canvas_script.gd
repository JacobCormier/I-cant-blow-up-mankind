extends CanvasLayer

@onready var icbm_text: Control = $ICBMText
@onready var developed_by_header: Control = $DevelopedByHeader
@onready var developed_by_body: Control = $DevelopedByBody
@onready var music_header: Control = $MusicHeader
@onready var music_body: Control = $MusicBody
@onready var sounds_header: Control = $SoundsHeader
@onready var sounds_body: Control = $SoundsBody
@onready var art_header: Control = $ArtHeader
@onready var art_body_1: Control = $ArtBody1
@onready var art_body_2: Control = $ArtBody2
@onready var art_body_3: Control = $ArtBody3
@onready var special_thanks_header: Control = $SpecialThanksHeader
@onready var special_thanks_body: Control = $SpecialThanksBody
@onready var final_statement: Control = $FinalStatement
@onready var thank_you: Control = $ThankYou
@onready var endless_mode_unlocked: Control = $EndlessModeUnlocked

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
		{ "header": developed_by_header, "body": developed_by_body, "timing": Vector2(3,6) },
		{ "header": music_header, "body": music_body, "timing": null },
		{ "header": sounds_header, "body": sounds_header, "timing": null },
		{ "header": art_header, "body": art_body_1, "timing": null },
		{ "header": art_header, "body": art_body_2, "timing": null },
		{ "header": art_header, "body": art_body_3, "timing": null },
		{ "header": special_thanks_header, "body": special_thanks_body, "timing": null },
		{ "header": final_statement, "body": null, "timing": null },
		{ "header": thank_you, "body": null, "timing": null },
		{ "header": endless_mode_unlocked, "body": null, "timing": null }
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
