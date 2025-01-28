extends Node3D

@onready var ground_cam: Camera3D = $GroundCam
@onready var follow_cam: Camera3D = $ICBMCharacter/FollowCam
var OutroTweens = preload("res://scripts/cutscenes/tweens/outro_tweens.gd").new()

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	start_tween_animation()
	camera_root_position = follow_cam.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if step == OutroStep.FOLLOW:
		print("FOLLOW Follow Cam")
		rumble(follow_cam, camera_root_position, rumble_intensity, rumble_intensity)
		step_complete(0)
	elif step == OutroStep.STATIONARY:
		print("STATIONARY Ground Cam")
		if rumble_intensity > 0:
			rumble(ground_cam, camera_root_position, rumble_intensity, rumble_intensity)
	elif step == OutroStep.INTERCEPT:
		print("INTERCEPT Follow Cam")
		rumble(follow_cam, camera_root_position, rumble_intensity, rumble_intensity)
	elif step == OutroStep.SPACE:
		print("SPACE Follow Cam")
		rumble(follow_cam, camera_root_position, rumble_intensity, rumble_intensity)
	elif step == OutroStep.SUN:
		print("SUN Follow Cam")
		rumble(follow_cam, camera_root_position, rumble_intensity, rumble_intensity)
	else:
		print("Impossible State")

func step_complete(step_completed):
	if step_completed == OutroStep.FOLLOW:
		print("FOLLOW Cam Step Complete")
		camera_root_position = ground_cam.position
		ground_cam.make_current()
		tween = OutroTweens.step2(self, get_tree().create_tween())
		step = OutroStep.STATIONARY
	elif step_completed == OutroStep.STATIONARY:
		print("STATIONARY Cam Step Complete")
		camera_root_position = follow_cam.position
		follow_cam.make_current()
		tween = OutroTweens.step3()
		step = OutroStep.INTERCEPT
	elif step_completed == OutroStep.INTERCEPT:
		print("INTERCEPT Cam Step Complete")
		tween = OutroTweens.step4()
		step = OutroStep.SPACE
	elif step_completed == OutroStep.SPACE:
		print("SPACE Cam Step Complete")
		tween = OutroTweens.step5()
		step = OutroStep.STATIONARY
	elif step_completed == OutroStep.SUN:
		print("SUN Cam Step Complete")
		tween = OutroTweens.step6()
	else:
		print("Impossible State")
		
func rumble(node, root_position, x_scale = 1, y_scale = 1):
	var random_rumble_x = root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x) * x_scale
	var random_rumble_y = root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y) * y_scale
	node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)
	
func start_tween_animation():
	tween = get_tree().create_tween()
	
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 4,  3)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rumble_intensity", 0,  5)	
