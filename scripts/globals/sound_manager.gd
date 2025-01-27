extends Node


const NUCLEAR_MISSILE_EXPLOSION = preload("res://resources/assets/sound/sfx/nuclear_missile_explosion.wav")
const PICK_UP_SFX = preload("res://resources/assets/sound/sfx/pick-up-sfx.wav")
const ROCKET_LOOP = preload("res://resources/assets/sound/sfx/Rocket-loop.wav") #WARNING This sound is really loud

var audio_player = AudioStreamPlayer
var rocket_engine_player = AudioStreamPlayer
var is_engine_on = false
const MIN_ENGINE_VOLUME_DB = -80.0
const MAX_ENGINE_VOLUME_DB = -20.0
var engine_fade_speed = 2.0

const MIN_ENGINE_PITCH = 0.2
const MAX_ENGINE_PITCH = 1.3
var engine_pitch_speed = 5.0
var is_engine_pitch_rising = false

func _ready():
	# Create an AudioStreamPlayer node dynamically or ensure it exists in the scene tree
	audio_player = AudioStreamPlayer.new()
	rocket_engine_player = AudioStreamPlayer.new()
	add_child(audio_player)
	add_child(rocket_engine_player)
	
	
	rocket_engine_player.stream = ROCKET_LOOP
	rocket_engine_player.volume_db = MIN_ENGINE_VOLUME_DB
	
func _process(delta: float) -> void:
	if is_engine_on:
		rocket_engine_player.volume_db = lerp(rocket_engine_player.volume_db, MAX_ENGINE_VOLUME_DB, delta * engine_fade_speed)
	else:
		rocket_engine_player.volume_db = lerp(rocket_engine_player.volume_db, MIN_ENGINE_VOLUME_DB, delta * engine_fade_speed)
		
	if is_engine_pitch_rising:
		rocket_engine_player.pitch_scale = lerp(rocket_engine_player.pitch_scale, MAX_ENGINE_PITCH, delta * engine_pitch_speed)
		if rocket_engine_player.pitch_scale / MAX_ENGINE_PITCH >= 0.95:
			is_engine_pitch_rising = false
	else:
		rocket_engine_player.pitch_scale = lerp(rocket_engine_player.pitch_scale, MIN_ENGINE_PITCH, delta * engine_pitch_speed)
		if (MIN_ENGINE_PITCH / rocket_engine_player.pitch_scale) >= 0.95:
			is_engine_pitch_rising = true

func play_nuclear_sound():
	audio_player.pitch_scale = 1.0
	audio_player.stream = NUCLEAR_MISSILE_EXPLOSION
	audio_player.play()
	
func play_pick_up_sound():
	audio_player.pitch_scale = randf_range(0.9, 1.3)
	audio_player.stream = PICK_UP_SFX
	audio_player.play()
	
func start_engine():
	stop_engine()
	rocket_engine_player.play()
	
func trigger_engine():
	is_engine_on = true
	
func stop_engine():
	is_engine_on = false
	
func kill_engine():
	rocket_engine_player.stop()
	
func kill_sound():
	audio_player.stop()
