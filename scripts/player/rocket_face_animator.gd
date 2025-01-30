extends Node3D

enum FaceStates {NONE, TALK, SURPRISE, PANIC, SAD, HAPPY, EXCITED}

@onready var icbm_character: Node3D = $Camera3D/ICBMCharacter
@onready var mouth: MeshInstance3D = $Camera3D/ICBMCharacter/RocketModel/Face/Mouth

const MAX_MOUTH_HEIGHT = 0.45
const MIN_MOUTH_HEIGHT = 0.1

# The time for the mouth to open and close
var talk_frequency = 1.0
const MIN_TALK_FREQUENCY = 0.1
const MAX_TALK_FREQUENCY = 0.6

var tween: Tween
var turn_tween: Tween
var turn_dir = 1
var cur_tween_dir = 1
var did_turn= false 
var icbm_character_root_position
var last_jitter = [0, 0, 0]
var dead = false

var is_input_left = false
var is_input_right = false

func _ready() -> void:
	icbm_character_root_position = icbm_character.position
	PlayerStats.on_player_death.connect(on_death)
	
func _process(delta):	
	micro_rumble(icbm_character, icbm_character_root_position, delta, 0, 0.05, 0.1, 0.05)
	micro_rumble(icbm_character, icbm_character_root_position, delta, 1, 0.2, 0.1, 0.17)
	micro_rumble(icbm_character, icbm_character_root_position, delta, 2, 0.4, 0.3, 0.3)
	
	if dead:
		return

	if (is_input_left and is_input_right) or (not is_input_left and not is_input_right): 
		turn_dir = 1
	elif is_input_left:
		turn_dir = 0
	elif is_input_right:
		turn_dir = 2

	turn()
	
	if tween != null and not PlayerStats.is_talking:
		tween.kill()
		tween = null
		mouth.mesh.set("height", MIN_MOUTH_HEIGHT)
	elif tween == null and PlayerStats.is_talking:
		randomize_talk_frequency()
		
	
func _input(event):
	# Read input Actions
	if Input.is_action_pressed("left") and not is_input_left:
		is_input_left = true
	elif Input.is_action_pressed("right") and not is_input_right:
		is_input_right = true
	elif event.is_action_released("left") and is_input_left:
		is_input_left = false
	elif event.is_action_released("right") and is_input_right:
		is_input_right = false

func turn():
	if turn_dir != cur_tween_dir:
		if not turn_tween == null:
			turn_tween.stop()
			turn_tween = null
		did_turn = false

	if not did_turn:
		cur_tween_dir = turn_dir
		var rotation = -50
		
		did_turn = true
		if turn_dir == 0:
			rotation = -115
		elif turn_dir == 2:
			rotation = -15
			
		turn_tween = get_tree().create_tween()
		
		turn_tween.set_ease(Tween.EASE_OUT)
		turn_tween.set_trans(Tween.TRANS_CUBIC)
		turn_tween.tween_property(icbm_character, "rotation_degrees:x", rotation,  1)	

func randomize_talk_frequency() -> void:
	if (get_tree() == null):
		return

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
		last_jitter[index] += randf() * delta

func on_death():
	dead = true
	rotation = Vector3(-90.0,rotation.y, rotation.z)
	tween.kill()
	mouth.mesh.set("height", MAX_MOUTH_HEIGHT)
