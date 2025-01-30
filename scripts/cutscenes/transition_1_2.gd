extends Node3D

@onready var game_globe: Node3D = $"../GameGlobe"
@onready var player: PlayerController = $"../Player"
@onready var icbm_character: Node3D = $ICBMCharacter
@onready var follow_cam: Camera3D = $ICBMCharacter/FollowCam

var Transition12Tweens = preload("res://scripts/cutscenes/tweens/transition_1_2_tweens.gd").new()

enum OutroStep {
	FOLLOW,
	STATIONARY,
	INTERCEPT,
	SPACE,
	SUN
}

var rumble_intensity = 0
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

var step = OutroStep.FOLLOW
var tween
var camera_root_position

func _ready():
	PlayerStats.is_gameplay_running = false
	print("Transition")
	Engine.time_scale = 1
	camera_root_position = follow_cam.position
	start_tween_animation(finish)
	
func rumble(node, root_position, x_scale = 1, y_scale = 1):
	var random_rumble_x = root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x) * x_scale
	var random_rumble_y = root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y) * y_scale
	node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)
	
func finish():
	PlayerStats.is_gameplay_running = true
	Globals.next_level()
	
func start_tween_animation(callback):
	tween = get_tree().create_tween()
	
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 4,  3)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 0,  5)	
	tween.tween_callback(callback)
