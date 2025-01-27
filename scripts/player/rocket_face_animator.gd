extends Node3D

enum FaceStates {NONE, TALK, SURPRISE, PANIC, SAD, HAPPY, EXCITED}

@onready var camera_3d: Camera3D = $Camera3D
@onready var mouth: MeshInstance3D = $MenuPlayer/FakeBlock/Mouth

const MAX_MOUTH_HEIGHT = 0.45
const MIN_MOUTH_HEIGHT = 0.1

# The time for the mouth to open and close
var talk_frequency = 1.0
const MIN_TALK_FREQUENCY = 0.1
const MAX_TALK_FREQUENCY = 0.6

var tween: Tween
var camera_root_position
var last_jitter = [0, 0, 0]

func _ready() -> void:
	randomize_talk_frequency()
	camera_root_position = camera_3d.position
	
func _process(delta):
	micro_rumble(camera_3d, camera_root_position, delta, 0)
	micro_rumble(camera_3d, camera_root_position, delta, 1, 0.02, 0.02, 0.07)
	micro_rumble(camera_3d, camera_root_position, delta, 2, 0.05, 0.05, 0.13)


func randomize_talk_frequency() -> void:
	tween = null
	talk_frequency = randf_range(MIN_TALK_FREQUENCY, MAX_TALK_FREQUENCY)
	tween = get_tree().create_tween()
	tween.tween_property(mouth, "mesh:height", MIN_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.tween_property(mouth, "mesh:height", MAX_MOUTH_HEIGHT, talk_frequency/2.0)
	tween.finished.connect(randomize_talk_frequency)

func micro_rumble(node, root_position, delta, index, x_variance = 0.01, y_variance = 0.01, time_scale = 0.05):
	if last_jitter[index] > time_scale:
		last_jitter[index] = 0
		var random_rumble_x = root_position.x + randf_range(0, x_variance)
		var random_rumble_y = root_position.y + randf_range(0, y_variance)
		node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)
	else:
		last_jitter[index] += delta
	
