extends Node

const THEME_INTRO_AND_VERSE = preload("res://resources/assets/sound/music/Theme_IntroAndVerse.wav")
const VERSE_2_LOOPEDTWICE = preload("res://resources/assets/sound/music/Verse2_loopedtwice.wav")

enum MusicStates {NONE, TITLE, GAME}

var current_music_state = MusicStates.GAME
var music_player: AudioStreamPlayer

func _ready():
	# Create an AudioStreamPlayer node dynamically or ensure it exists in the scene tree
	music_player = AudioStreamPlayer.new()
	music_player.pitch_scale = 1.0
	add_child(music_player)
	play_music_sequence()

func play_music_sequence():
	music_player.stream = THEME_INTRO_AND_VERSE
	music_player.play()
	music_player.finished.connect(_on_theme_intro_finished)

func _on_theme_intro_finished():
	music_player.finished.disconnect(_on_theme_intro_finished)
	music_player.stream = VERSE_2_LOOPEDTWICE
	music_player.play()
