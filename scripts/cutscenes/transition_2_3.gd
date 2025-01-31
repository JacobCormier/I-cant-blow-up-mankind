extends Node3D
@onready var player_origin: Node3D = $PlayerOrigin
@onready var ground_cam: Camera3D = $GroundCam
var Transition12Tweens = preload("res://scripts/cutscenes/tweens/transition_1_2_tweens.gd").new()

var rumble_intensity = 0

var tween
var camera_root_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerStats.is_gameplay_running = false
	print("Transition 2 - 3")
	Engine.time_scale = 1
	SoundManager.kill_engine()
	camera_root_position = ground_cam.position
	start_tween_animation(finish)
	
func _process(delta):
	AnimationUtils.rumble(ground_cam, camera_root_position, rumble_intensity, rumble_intensity)
	
func finish():
	PlayerStats.is_gameplay_running = true
	Globals.next_level()
	
func start_tween_animation(callback):
	tween = get_tree().create_tween()
	
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 8,  3)
	
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 0,  5)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(player_origin, "position:z", 152,  5)
	tween.parallel().tween_property(player_origin, "rotation_degrees:x", -150,  7).as_relative()
	tween.tween_callback(callback)	
