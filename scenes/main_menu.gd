extends Node3D

@onready var game_globe: Node3D = $GameGlobe
@onready var block: Node3D = $Block
@onready var lid = $Block/Lid
@onready var launchPad = $Block/LaunchPad
@onready var player = $Block/LaunchPad/MenuPlayer
@onready var camera_3d: Camera3D = $Camera3D

var is_launching = false
var is_rising = false
var tween
var current_root_position
var launchPad_root_position
var camera_root_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_tween_animation()
	current_root_position = player.position
	launchPad_root_position = launchPad.position
	camera_root_position = camera_3d.position

func end_sequence() -> void:
	# Caleb Reath
	# Trigger next scene
	return
	
func end_launch_shake() -> void:
	is_launching = false
	
func trigger_launch() -> void:
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
		
	if is_rising:
		rumble(launchPad, launchPad_root_position, 0.5, 0.5)

func rumble(node, root_position, x_scale = 1, y_scale = 1):
	var random_rumble_x = root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x) * x_scale
	var random_rumble_y = root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y) * y_scale
	node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)

func setup_tween_animation():
	# Lid Opening halfway
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(lid, "rotation_degrees:z", -75, 2)
	
	# Lid slam open
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(lid, "rotation_degrees:z", 26.5, 2)
	tween.tween_callback(trigger_rising)
	
	# Raise launch pad
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(launchPad, "position:y", 0.55, 4)
	tween.tween_callback(finish_rising)
	
	# wait then start launch sequence
	tween.tween_interval(2)
	tween.tween_callback(trigger_launch)
	
	# Launch Rocket
	tween.tween_interval(5)
	tween.tween_interval(0)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(player, "position:y", 500, 8)
	
	# Pan Camera Up
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:x", 65, 8)	
	tween.tween_callback(end_launch_shake)
	
	# Lower launch pad and block Fast
	tween.tween_interval(0)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(launchPad, "position:y", -15, 2)
	tween.parallel().tween_property(block, "position:y", -15, 2)
	tween.parallel().tween_property(player, "position:z", 250, 2)
	
	# Pan Camera Down
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(camera_3d, "position:x", 0, 8)
	tween.parallel().tween_property(camera_3d, "position:y", 516.134, 5)
	tween.parallel().tween_property(camera_3d, "position:z", 134.103, 7)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:x", -13.7, 8)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:y", 0, 8)
	tween.parallel().tween_property(camera_3d, "rotation_degrees:z", 0, 8)
	tween.parallel().tween_property(game_globe, "rotation_degrees:x", 360, 20)
	tween.tween_callback(end_sequence)
