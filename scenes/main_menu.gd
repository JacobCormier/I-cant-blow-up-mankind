extends Node3D

const LEVEL_1 = preload("res://scenes/Level1.tscn")
@onready var game_globe: Node3D = $GameGlobe
@onready var block: Node3D = $Block
@onready var lid = $Block/Lid
@onready var launchPad = $Block/LaunchPad
@onready var player = $MenuPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var diorama: Node3D = $Diorama
@onready var diorama_camera_base: MeshInstance3D = $DioramaCameraBase
@onready var follow_cam: Camera3D = $MenuPlayer/FollowCam

var is_launching = false
var is_rising = false
var is_following = false
var tween
var current_root_position
var follow_cam_root_position
var launchPad_root_position
var camera_root_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)
const TIME_SCALE = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_tween_animation()
	current_root_position = player.position
	launchPad_root_position = launchPad.position
	camera_root_position = camera_3d.position
	follow_cam_root_position = follow_cam.position

func trigger_dialogue() -> void:
	Engine.time_scale = 0
	
func end_sequence() -> void:
	get_tree().change_scene_to_packed(Globals.LEVEL_1)
	
func end_launch_shake() -> void:
	is_launching = false
	player.visible = false
	block.visible = false
	
func trigger_launch() -> void:
	current_root_position = player.position
	camera_root_position = camera_3d.position
	is_launching = true
	player.rocket_particles.gpu_particles_3d.emitting = true
	
func trigger_rising() -> void:
	is_rising = true
	
func finish_rising() -> void:
	is_rising = false
	launchPad_root_position = launchPad.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_launching:
		rumble(player, current_root_position)		
		rumble(camera_3d, camera_root_position, 0.25, 0.25)
		rumble(follow_cam, follow_cam_root_position)
		
	if is_rising:
		rumble(launchPad, launchPad_root_position, 0.5, 0.5)
		rumble(player, current_root_position)		

func rumble(node, root_position, x_scale = 1, y_scale = 1):
	var random_rumble_x = root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x) * x_scale
	var random_rumble_y = root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y) * y_scale
	node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)

func remove_diorama():
	diorama.visible = false
	
func remove_base():
	diorama_camera_base.visible = false
	block.visible = false
	current_root_position = player.position

func save_positions():
	follow_cam_root_position = follow_cam.position
	camera_root_position = camera_3d.position
	current_root_position = player.position

func switch_camera():
	if (follow_cam.current):
		Engine.time_scale = 1
		camera_3d.make_current()
		is_following = false
	else:
		follow_cam.make_current()
		is_following = true
	
func start_tween_animation():
	tween = get_tree().create_tween()
	
	# Pan Camera 180deg
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera_3d, "rotation_degrees:y", 90, TIME_SCALE * 3)	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera_3d, "rotation_degrees:y", 0, TIME_SCALE * 3)	
	tween.tween_callback(remove_diorama)
	
	# Lid Opening halfway
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(lid, "rotation_degrees:z", -70, TIME_SCALE * 2)
	
	# Lid slam open
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(lid, "rotation_degrees:z", 23.9, TIME_SCALE * 2)
	tween.tween_callback(trigger_rising)
	
	# Raise launch pad
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(launchPad, "position:y", 0.55, TIME_SCALE * 4)
	tween.parallel().tween_property(player, "position:y", 509.4, TIME_SCALE * 4)
	tween.tween_callback(finish_rising)
	
	# wait then start launch sequence
	tween.tween_interval(TIME_SCALE * 2)
	tween.tween_callback(trigger_launch)
	
	# Launch Rocket
	tween.tween_interval(TIME_SCALE * 5)
	tween.tween_interval(0)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(player, "position:y", 1000, TIME_SCALE * 12)
	
	# Pan Camera Up
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:x", 65, TIME_SCALE * 8)	
	tween.tween_callback(remove_base)
	tween.tween_callback(save_positions)
	
	# Angle camera for intercept
	tween.tween_interval(1)
	tween.tween_interval(0)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:x", 16.7, TIME_SCALE * 3)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:y", 0, TIME_SCALE * 3)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:z", 38.5, TIME_SCALE * 3)
	tween.parallel().tween_property(camera_3d, "position:y", 716.134, TIME_SCALE * 3)
	tween.tween_callback(switch_camera)
	
	# Intercept Rocket
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(follow_cam, "position:y", -3, TIME_SCALE * 4)
	tween.tween_callback(save_positions)
	
	# Accelerate away
	tween.tween_interval(TIME_SCALE * 3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(follow_cam, "position:y", -100, TIME_SCALE * 8)
	tween.tween_callback(save_positions)
	tween.tween_callback(end_launch_shake)
	tween.tween_callback(switch_camera)
	
	# Derotate camera
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera_3d, "rotation_degrees:y", 0, TIME_SCALE * 3)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:z", 0, TIME_SCALE * 3)
	tween.parallel().tween_property(camera_3d, "position:y", 916.134, 0)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:x", -13.7, TIME_SCALE * 3)
	
	# Game Position
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_interval(TIME_SCALE * 1)
	tween.tween_interval(0)
	tween.tween_property(camera_3d, "position:x", 0, TIME_SCALE * 8)
	tween.parallel().tween_property(camera_3d, "position:y", 516.134, TIME_SCALE * 5)
	tween.parallel().tween_property(camera_3d, "position:z", 134.103, TIME_SCALE * 7)
	tween.parallel().tween_property(game_globe, "rotation_degrees:x", 200, TIME_SCALE * 9)
	#tween.parallel().tween_property(game_globe, "rotation_degrees:x", 1800000, TIME_SCALE * 120000)
	#tween.tween_callback(trigger_dialogue)
	tween.tween_callback(end_sequence)
