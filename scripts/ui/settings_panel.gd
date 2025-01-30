extends Panel

@onready var mute_all: CheckBox = $Panel/SubTitle/MuteAll
@onready var mute_music: CheckBox = $Panel/SubTitle/MuteMusic
@onready var fx_volume: HSlider = $Panel/SubTitle/FXVolume
@onready var music_volume: HSlider = $Panel/SubTitle/MusicVolume
@onready var dialogue_volume: HSlider = $Panel/SubTitle/DialogueVolume
@onready var master_volume: HSlider = $Panel/SubTitle/MasterVolume


func _on_master_volume_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_dialogue_volume_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_music_volume_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_fx_volume_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_mute_music_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_mute_all_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
