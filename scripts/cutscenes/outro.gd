extends Node3D

@onready var intro_cam: Camera3D = $IntroCam
@onready var reveal_cam: Camera3D = $RevealCam
@onready var finale_cam: Camera3D = $FinaleCam
@onready var moon_reveal_light: DirectionalLight3D = $MoonRevealLight
@onready var rocket_particles: Node3D = $Player/ICBMCharacter/RocketModel/RocketParticles
@onready var game_globe: Node3D = $GameGlobe
@onready var moon: Node3D = $MoonRevealLight/Moon
@onready var moon_visual: Node3D = $MoonRevealLight/Moon/VisualContainer

var OutroTweens = preload("res://scripts/cutscenes/tweens/outro_tweens.gd").new()

var tween
var active_camera
var camera_root_position
var camera_shake = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	active_camera = intro_cam
	camera_root_position = intro_cam.position
	OutroTweens.play_sequence(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera_shake:
		AnimationUtils.rumble(active_camera, camera_root_position)

func intro_started():
	print("intro_started")
	active_camera = intro_cam
	intro_cam.make_current()
	
func moon_reveal_started():
	print("moon_reveal_started")
	active_camera = reveal_cam
	reveal_cam.make_current()
	game_globe.visible = false
	moon.visible = true

func finale_started():
	print("finale_started")
	active_camera = finale_cam
	finale_cam.make_current()

func start_camera_shake():
	camera_shake = true
	start_particles()
		
func start_particles():
	rocket_particles.visible = true
	
func stop_camera_shake():
	camera_shake = false
	stop_particles()
		
func stop_particles():
	rocket_particles.visible = false
