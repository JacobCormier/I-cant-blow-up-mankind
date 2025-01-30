extends CanvasLayer

@onready var outro_voiceline_1: Control = $outro_voiceline_1
@onready var outro_voiceline_2: Control = $outro_voiceline_2
@onready var outro_voiceline_3: Control = $outro_voiceline_3
@onready var outro_voiceline_4: Control = $outro_voiceline_4
@onready var outro_voiceline_5: Control = $outro_voiceline_5
@onready var outro_voiceline_6: Control = $outro_voiceline_6
@onready var credits_new_1: Control = $credits_new_1
@onready var credits_new_2: Control = $credits_new_2
@onready var credits_new_3: Control = $credits_new_3
@onready var credits_new_4: Control = $credits_new_4
@onready var credits_new_5: Control = $credits_new_5
@onready var credits_new_6: Control = $credits_new_6
@onready var credits_new_7: Control = $credits_new_7
@onready var credits_new_8: Control = $credits_new_8
@onready var credits_new_9: Control = $credits_new_9
@onready var credits_new_10: Control = $credits_new_10
@onready var credits_new_11: Control = $credits_new_11
@onready var credits_new_12: Control = $credits_new_12
@onready var credits_new_13: Control = $credits_new_13
@onready var credits_new_14: Control = $credits_new_14
@onready var credits_new_15: Control = $credits_new_15
@onready var credits_new_16: Control = $credits_new_16

var current_step = 0
var story_array = []

func _ready() -> void:
	story_array.append(outro_voiceline_1)
	story_array.append(outro_voiceline_2)
	story_array.append(outro_voiceline_3)
	story_array.append(outro_voiceline_4)
	story_array.append(outro_voiceline_5)
	story_array.append(outro_voiceline_6)
	story_array.append(credits_new_1)
	story_array.append(credits_new_2)
	story_array.append(credits_new_3)
	story_array.append(credits_new_4)
	story_array.append(credits_new_5)
	story_array.append(credits_new_6)
	story_array.append(credits_new_7)
	story_array.append(credits_new_8)
	story_array.append(credits_new_9)
	story_array.append(credits_new_10)
	story_array.append(credits_new_11)
	story_array.append(credits_new_12)
	story_array.append(credits_new_13)
	story_array.append(credits_new_14)
	story_array.append(credits_new_15)
	
	if not PlayerStats.loaded_endless_unlocked:
		PlayerStats.unlock_endless()
		story_array.append(credits_new_16)
		
	
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
