extends Node3D

@onready var mouth: MeshInstance3D = $FakeBlock/Mouth

const MAX_MOUTH_HEIGHT = 0.45
const MIN_MOUTH_HEIGHT = 0.1

# The time for the mouth to open and close
var talk_frequency = 1.0

var tween: Tween

func _ready() -> void:
	randomize_talk_frequency()


func randomize_talk_frequency() -> void:
	tween = null
	talk_frequency = randf_range(0.2, 2.0)
	tween = get_tree().create_tween()
	tween.tween_property(mouth, "mesh:height", MIN_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.tween_property(mouth, "mesh:height", MAX_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.finished.connect(randomize_talk_frequency)
	
