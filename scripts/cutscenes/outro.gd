extends Node3D

@onready var intro_cam: Camera3D = $IntroCam
@onready var moon_reveal_light: DirectionalLight3D = $MoonRevealLight
@onready var rocket_particles: Node3D = $PlayerRoot/Player/ICBMCharacter/RocketModel/RocketParticles
@onready var game_globe: Node3D = $GameGlobe
@onready var moon: Node3D = $MoonRevealLight/Moon
@onready var orbit_control: Node3D = $MoonRevealLight/Moon/MoonVisual/OrbitControl
@onready var orbit_player: Node3D = $MoonRevealLight/Moon/MoonVisual/OrbitControl/OrbitPlayer
@onready var orbit_cam: Camera3D = $MoonRevealLight/Moon/MoonVisual/OrbitControl/OrbitPlayer/OrbitCam
@onready var player: Node3D = $PlayerRoot/Player
@onready var moon_visual: Node3D = $MoonRevealLight/Moon/MoonVisual
@onready var reveal_cam: Camera3D = $PlayerRoot/Player/RevealCam
@onready var icbm_character: Node3D = $MoonRevealLight/Moon/MoonVisual/OrbitControl/OrbitPlayer/ICBMCharacter

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
	active_camera = intro_cam
	intro_cam.make_current()
	
func moon_reveal_started():
	active_camera = reveal_cam
	reveal_cam.make_current()
	game_globe.visible = false
	moon.visible = true

func orbit_moon_started():
	active_camera = orbit_cam
	orbit_cam.make_current()
	orbit_player.visible = true
	player.visible = false

func finale_started():
	pass

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
