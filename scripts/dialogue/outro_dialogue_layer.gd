extends CanvasLayer

# @onready var story_1: Control = $Story_1

var current_step = 0
var story_array = []

func _ready() -> void:
	#story_array.append(story_1)
	pass

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
