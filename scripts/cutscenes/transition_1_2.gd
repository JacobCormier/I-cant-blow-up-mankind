extends Node3D

@onready var player: PlayerController = $"../Player"
@onready var icbm_character: Node3D = $ICBMCharacter
@onready var tracking_cam: Camera3D = $ICBMCharacter/TrackingCam
@onready var transition_globe: Node3D = $TransitionGlobe
@onready var camera_3d: Camera3D = $Camera3D

var rumble_intensity = 0

var tween
var tween2
var camera_root_position
var current_ground_color = Color("#60e331")
var current_sky_color = Color("#38b2f5")

func set_environment_color(ground_color: Color, sky_color: Color) -> void:
	transition_globe.set_environment_color(ground_color, sky_color)
	
func _ready():
	PlayerStats.is_gameplay_running = false
	Engine.time_scale = 1
	camera_root_position = tracking_cam.position
	start_tween_animation(finish)
	
func _process(delta):
	AnimationUtils.rumble(tracking_cam, camera_root_position, rumble_intensity, rumble_intensity)
	set_environment_color(current_ground_color, current_sky_color)
	
func finish():
	PlayerStats.is_gameplay_running = true
	Globals.next_level()
	
func switch_camera():
	camera_3d.make_current()
	
func start_tween_animation(callback):
	tween = get_tree().create_tween()
	tween2 = get_tree().create_tween()
	
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(icbm_character, "position:z", 0,  5)
	tween.tween_interval(6)
	tween2.set_trans(Tween.TRANS_LINEAR)
	tween2.tween_property(tracking_cam, "position:y", -20,  5)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_BACK)
	tween2.parallel().tween_property(self, "rumble_intensity", 2,  3)
	tween2.tween_property(tracking_cam, "position:y", -10,  6)
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.parallel().tween_property(tracking_cam, "rotation_degrees:x", 79,  3)
	tween2.parallel().tween_property(self, "current_sky_color", Color("#0f5ebe"), 3)
	tween2.parallel().tween_property(self, "current_ground_color", Color("#5b6e54"), 3)
	tween2.parallel().tween_property(tracking_cam, "position:y", -2000,  8)
	tween2.parallel().tween_property(icbm_character, "position:z", -2000,  8)
	tween.tween_interval(2)
	
	tween.tween_callback(callback)
