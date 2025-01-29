extends Control

@onready var main_menu_control: Control = $MainMenuControl
@onready var dialogue_ui: CanvasLayer = $"../DialogueUI"
@onready var options_control: Control = $OptionsControl
@onready var skip_button: Button = $CommonControl/SkipButton
@onready var endless_control: Control = $EndlessControl
@onready var endless_button: Button = $MainMenuControl/Panel/EndlessButton

@onready var title: Label = $MainMenuControl/Panel/Title
@onready var title_real: Label = $MainMenuControl/Panel/TitleReal
@onready var sub_title: Label = $MainMenuControl/Panel/SubTitle
@onready var sub_title_real: Label = $MainMenuControl/Panel/SubTitleReal


func _ready() -> void:
	Engine.time_scale = 0.0
	
	endless_button.disabled = not PlayerStats.loaded_endless_unlocked
	
	if PlayerStats.loaded_high_score > 0:
		skip_button.visible = true
		
		title.visible = false
		title_real.visible = true
		sub_title.visible = false
		sub_title_real.visible = true
	
func _on_endless_button_pressed() -> void:
	skip_button.visible = false
	main_menu_control.visible = false
	endless_control.visible = true

func _on_skip_button_pressed() -> void:
	MusicManager.play_music_sequence()
	PlayerStats.current_score = 0.0
	PlayerStats.current_progress = 0.0
	Globals.current_level = 1
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
	Globals.current_level = 1
	
	MusicManager.stop()
	#await get_tree().create_timer(1).timeout
	MusicManager.play_music_sequence()

func _on_standard_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/standard.tscn"
	Globals.current_level = -1
	get_tree().change_scene_to_file(scene_path)
	
func _on_arcade_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/arcade.tscn"
	Globals.current_level = -1
	get_tree().change_scene_to_file(scene_path)
	
func _on_first_person_button_pressed() -> void:
	var scene_path = "res://scenes/endless_levels/first_person.tscn"
	Globals.current_level = -1
	get_tree().change_scene_to_file(scene_path)

func _on_toggle_unlock_button_pressed() -> void:
	PlayerStats.toggle_unlock()
	endless_button.disabled = not PlayerStats.loaded_endless_unlocked
