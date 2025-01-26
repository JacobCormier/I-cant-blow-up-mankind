extends Control

@onready var skip_button: Button = $MainMenuControl/Panel/SkipButton


func _ready() -> void:
	print(OS.get_data_dir())
	print(OS.get_user_data_dir())
	Engine.time_scale = 0.0
	
	if PlayerStats.loaded_high_score > 0:
		skip_button.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_skip_button_pressed() -> void:
	MusicManager.play_music_sequence()
	get_tree().change_scene_to_packed(Globals.LEVEL_1)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_launch_button_pressed() -> void:
	Engine.time_scale = 1.0
	MusicManager.play_music_sequence()
	self.visible = false
