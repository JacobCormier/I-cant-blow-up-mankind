extends Node


const NUCLEAR_MISSILE_EXPLOSION = preload("res://resources/assets/sound/sfx/nuclear_missile_explosion.wav")
const PICK_UP_SFX = preload("res://resources/assets/sound/sfx/pick-up-sfx.wav")
const ROCKET_LOOP = preload("res://resources/assets/sound/sfx/Rocket-loop.wav") #WARNING This sound is really loud

var audio_player = AudioStreamPlayer
var rocket_engine_player = AudioStreamPlayer


func _ready():
	# Create an AudioStreamPlayer node dynamically or ensure it exists in the scene tree
	audio_player = AudioStreamPlayer.new()
	rocket_engine_player = AudioStreamPlayer.new()
	add_child(audio_player)
	add_child(rocket_engine_player)
	rocket_engine_player.stream = ROCKET_LOOP


func play_nuclear_sound():
	audio_player.pitch_scale = 1.0
	audio_player.stream = NUCLEAR_MISSILE_EXPLOSION
	audio_player.play()
	
func play_pick_up_sound():
	audio_player.pitch_scale = randf_range(0.9, 1.3)
	audio_player.stream = PICK_UP_SFX
	audio_player.play()
	
func kill_sound():
	audio_player.stop()
