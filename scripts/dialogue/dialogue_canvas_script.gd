extends CanvasLayer

@onready var story_1: Control = $Story_1
@onready var story_2: Control = $Story_2
@onready var story_3: Control = $Story_3
@onready var story_3_5: Control = $Story_3_5
@onready var story_4: Control = $Story_4
@onready var voiceline_1: Control = $voiceline_1
@onready var voiceline_2: Control = $voiceline_2
@onready var voiceline_3: Control = $voiceline_3
@onready var story_5: Control = $Story_5
@onready var voiceline_4: Control = $voiceline_4
@onready var voiceling_title: Control = $voiceling_title

var current_step = 0
var story_array = []

func _ready() -> void:
	story_array.append(story_1)
	story_array.append(story_2)
	story_array.append(story_3)
	story_array.append(story_3_5)
	story_array.append(story_4)
	story_array.append(voiceline_1)
	story_array.append(voiceline_2)
	story_array.append(voiceline_3)
	story_array.append(story_5)
	story_array.append(voiceline_4)
	story_array.append(voiceling_title)

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
