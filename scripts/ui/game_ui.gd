extends CanvasLayer
@onready var final_score_label: Label = $DeathScreenControl/Panel/FinalScoreLabel
@onready var high_score_label: Label = $DeathScreenControl/Panel/HighScoreLabel
@onready var death_screen_control: Control = $DeathScreenControl
@onready var score_control: Control = $ScoreControl
@onready var score_label: Label = $ScoreControl/ScoreLabel
@onready var fuel_progress_bar: TextureProgressBar = $ScoreControl/FuelProgressBar

var score := 0.0
var is_score_posted = false

func _ready():
	death_screen_control.visible = false
	PlayerStats.on_fuel_changed.connect(update_fuel)

func _process(delta: float) -> void:
	if death_screen_control.visible == false:
		score += delta
		score_label.text = "Score: " + str(int(score))
	elif not is_score_posted:
		is_score_posted = true
		PlayerStats.check_high_score(score)
		final_score_label.text = "Final Score: " + str(int(score))
		high_score_label.text = "High Score: " + str(int(PlayerStats.loaded_high_score))

func show_death():
	death_screen_control.visible = true
	score_control.visible = false

func update_fuel(fuel_count: int) -> void:
	fuel_progress_bar.value = fuel_count

func _on_restart_button_pressed() -> void:
	PlayerStats.reload_fuel()
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
