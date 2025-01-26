extends CanvasLayer

@onready var score_label: Label = $Control/Panel/ScoreLabel
@onready var high_score_label: Label = $Control/Panel/HighScoreLabel

var score := 0.0
var is_score_posted = false

func _process(delta: float) -> void:
	if visible == false:
		score += delta
	elif not is_score_posted:
		is_score_posted = true
		score_label.text = "Final Score: " + str(int(score))
		Globals.check_high_score(score)
		high_score_label.text = "High Score: " + str(int(Globals.high_score))

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
