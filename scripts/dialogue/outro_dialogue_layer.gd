extends CanvasLayer

@onready var outro_voiceline_1: Control = $outro_voiceline_1
@onready var outro_voiceline_2: Control = $outro_voiceline_2
@onready var outro_voiceline_3: Control = $outro_voiceline_3
@onready var outro_voiceline_4: Control = $outro_voiceline_4
@onready var outro_voiceline_5: Control = $outro_voiceline_5
@onready var outro_voiceline_6: Control = $outro_voiceline_6

var current_step = 0
var story_array = []

func _ready() -> void:
	story_array.append(outro_voiceline_1)
	story_array.append(outro_voiceline_2)
	story_array.append(outro_voiceline_3)
	story_array.append(outro_voiceline_4)
	story_array.append(outro_voiceline_5)
	story_array.append(outro_voiceline_6)
	
	start_dialogue()

func start_dialogue() -> void:
	story_array[current_step].trigger_dialogue()
	story_array[current_step].on_complete.connect(next_story_step)

func next_story_step() -> void:
	current_step += 1
	print(current_step)
	var current_story_step
	
	if story_array.size() > current_step:
		current_story_step = story_array[current_step]
	else:
		return

	current_story_step.trigger_dialogue()
	current_story_step.on_complete.connect(next_story_step)
