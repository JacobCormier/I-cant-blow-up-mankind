extends Control

@onready var main_menu_control: Control = $MainMenuControl
@onready var dialogue_ui: CanvasLayer = $"../DialogueUI"
@onready var options_control: Control = $OptionsControl
@onready var skip_button: Button = $CommonControl/SkipButton
@onready var endless_control: Control = $EndlessControl


func _ready() -> void:
	print(OS.get_data_dir())
	print(OS.get_user_data_dir())
	Engine.time_scale = 0.0
	
	if PlayerStats.loaded_high_score > 0:
		skip_button.visible = true
	
func _on_endless_button_pressed() -> void:
	skip_button.visible = false
	main_menu_control.visible = false
	endless_control.visible = true

func _on_skip_button_pressed() -> void:
	MusicManager.play_music_sequence()
	get_tree().change_scene_to_packed(Globals.LEVEL_1)

func _on_options_button_pressed() -> void:
	main_menu_control.visible = false
	options_control.visible = true

func _on_back_button_pressed() -> void:
	main_menu_control.visible = true
	skip_button.visible = true
	options_control.visible = false
	endless_control.visible = false
	
func _on_launch_button_pressed() -> void:
	Engine.time_scale = 1.0
	self.visible = false
	dialogue_ui.start_dialogue()
	
	MusicManager.stop()
	#await get_tree().create_timer(1).timeout
	MusicManager.play_music_sequence()

func _on_standard_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/standard.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_arcade_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/arcade.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_first_person_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/first_person.tscn"
	get_tree().change_scene_to_file(scene_path)
