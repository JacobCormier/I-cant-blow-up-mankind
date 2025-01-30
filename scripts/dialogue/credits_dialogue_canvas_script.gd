extends CanvasLayer

@onready var icbm_text: Control = $ICBMText
@onready var header_developed_by: Control = $HeaderDevelopedBy
@onready var body_developed_by: Control = $BodyDevelopedBy
@onready var header_music: Control = $HeaderMusic
@onready var body_music: Control = $BodyMusic
@onready var header_art: Control = $HeaderArt
@onready var header_sound: Control = $HeaderSound
@onready var body_sound: Control = $BodySound
@onready var header_special_thanks: Control = $HeaderSpecialThanks
@onready var body_special_thanks: Control = $BodySpecialThanks
@onready var body_final_statement: Control = $BodyFinalStatement
@onready var thank_you: Control = $ThankYou
@onready var unlocked_endless: Control = $UnlockedEndless
@onready var body_art: Control = $BodyArt

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
	phase_data = [
		{ "header": icbm_text, "body": null, "timing": Vector2(0,5) },
		{ "header": header_developed_by, "body": body_developed_by, "timing": Vector2(1,3) },
		{ "header": header_music, "body": body_music, "timing": Vector2(1,3) },
		{ "header": header_sound, "body": body_sound, "timing": Vector2(1,3)  },
		{ "header": header_art, "body": body_art, "timing": Vector2(1,6)  },
		{ "header": header_special_thanks, "body": body_special_thanks, "timing": Vector2(1,3)  },
		{ "header": body_final_statement, "body": null, "timing": Vector2(1,3)  },
		{ "header": thank_you, "body": null, "timing": Vector2(1,3)  },
		{ "header": unlocked_endless, "body": null, "timing": Vector2(1,3)  }
	]
	phases = Phase.from_array(phase_data)

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
	
	if not playing and phase_data[current_phase_playing].timing:
		if phase_data[current_phase_playing].timing.x <= total_time:
			print("playing phase",current_phase_playing)
			phases[current_phase_playing].play()
			playing = true

func message_complete():
	current_phase_playing += 1
	playing = false
