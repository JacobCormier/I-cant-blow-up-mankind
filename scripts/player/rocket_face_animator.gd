extends Node3D

enum FaceStates {NONE, TALK, SURPRISE, PANIC, SAD, HAPPY, EXCITED}

@onready var mouth: MeshInstance3D = $FakeBlock/Mouth

const MAX_MOUTH_HEIGHT = 0.45
const MIN_MOUTH_HEIGHT = 0.1

# The time for the mouth to open and close
var talk_frequency = 1.0
const MIN_TALK_FREQUENCY = 0.1
const MAX_TALK_FREQUENCY = 0.6

var tween: Tween

func _ready() -> void:
	randomize_talk_frequency()


func randomize_talk_frequency() -> void:
	tween = null
	talk_frequency = randf_range(MIN_TALK_FREQUENCY, MAX_TALK_FREQUENCY)
	tween = get_tree().create_tween()
	tween.tween_property(mouth, "mesh:height", MIN_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.tween_property(mouth, "mesh:height", MAX_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.finished.connect(randomize_talk_frequency)
	
