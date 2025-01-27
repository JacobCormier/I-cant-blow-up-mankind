extends CanvasLayer
@onready var final_score_label: Label = $DeathScreenControl/Panel/FinalScoreLabel
@onready var high_score_label: Label = $DeathScreenControl/Panel/HighScoreLabel
@onready var death_screen_control: Control = $DeathScreenControl
@onready var score_control: Control = $ScoreControl
@onready var score_label: Label = $ScoreControl/ScoreLabel
@onready var fuel_progress_bar: TextureProgressBar = $ScoreControl/FuelProgressBar
@onready var sub_viewport: SubViewport = $SubViewport
@onready var texture_rect: TextureRect = $TextureRect
@onready var rocket_face: Node3D = $SubViewport/RocketFace

func _ready():
	death_screen_control.visible = false
	PlayerStats.on_fuel_changed.connect(update_fuel)
	PlayerStats.on_score_changed.connect(update_score)
	PlayerStats.start_gameplay()
	
func _process(delta):
	texture_rect.texture = sub_viewport.get_texture()
	if texture_rect.material and texture_rect.material.is_class("ShaderMaterial"):
		var shader_material = texture_rect.material as ShaderMaterial
		shader_material.set("shader_parameter/time", Time.get_ticks_msec() / 1000.0)
		shader_material.set("shader_parameter/resolution", Vector2(sub_viewport.size.x, sub_viewport.size.y))
		shader_material.set("shader_parameter/texture_albedo", sub_viewport.get_texture())

func _input(event):
	rocket_face._input(event)

func show_death():
	death_screen_control.visible = true
	score_control.visible = false

func update_fuel(fuel_count: int) -> void:
	fuel_progress_bar.value = fuel_count

func update_score(score_count: int) -> void:
	score_label.text = "Score: " + str(int(score_count))
	final_score_label.text = "Final Score: " + str(int(score_count))
	high_score_label.text = "High Score: " + str(int(PlayerStats.loaded_high_score))

func _on_restart_button_pressed() -> void:
	PlayerStats.reload_fuel()
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
