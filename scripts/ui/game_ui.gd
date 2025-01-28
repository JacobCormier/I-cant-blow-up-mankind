extends CanvasLayer
@onready var final_score_label: Label = $DeathScreenControl/Panel/FinalScoreLabel
@onready var high_score_label: Label = $DeathScreenControl/Panel/HighScoreLabel
@onready var death_screen_control: Control = $DeathScreenControl
@onready var score_control: Control = $ScoreControl
@onready var score_label: Label = $ScoreControl/ScoreLabel
@onready var fuel_progress_bar: TextureProgressBar = $ScoreControl/FuelProgressBar
@onready var sub_viewport: SubViewport = $FaceCam/SubViewport
@onready var face_cam: TextureRect = $FaceCam
@onready var face_cam_rocket: Node3D = $FaceCam/SubViewport/FaceCamRocket

@onready var level_progress_bar: TextureProgressBar = $ScoreControl/LevelProgressBar
@onready var progress_label: Label = $ScoreControl/ProgressLabel

var dead = false
var timer_tween
var timer_delta = 0
var tween
var space_pressed = false

func _ready():
	death_screen_control.visible = false
	PlayerStats.on_fuel_changed.connect(update_fuel)
	PlayerStats.on_score_changed.connect(update_score)
	PlayerStats.on_progress_changed.connect(update_progress)
	PlayerStats.start_gameplay()
	slide_face_cam()
	
func _process(delta):
	# On Death Engine speed is 0 so tween must be done manually
	if timer_tween != null:
		timer_delta += delta
		timer_tween.custom_step(timer_delta)
		
	face_cam.texture = sub_viewport.get_texture()
	if face_cam.material and face_cam.material.is_class("ShaderMaterial"):
		var shader_material = face_cam.material as ShaderMaterial
		shader_material.set("shader_parameter/time", Time.get_ticks_msec() / 1000.0)
		shader_material.set("shader_parameter/resolution", Vector2(sub_viewport.size.x, sub_viewport.size.y))
		shader_material.set("shader_parameter/texture_albedo", sub_viewport.get_texture())

func _input(event):
	face_cam_rocket._input(event)
	
	if event is InputEventKey:  # Check if it's a key event
		if event.pressed:  # Check if the key was pressed
			if Input.is_action_pressed("ui_select") and not space_pressed:
				space_pressed = true
				if dead:
					if not death_screen_control.visible:
						timer_tween.custom_step(100)
					else:
						_on_restart_button_pressed()
		if event.is_action_released("ui_select") and space_pressed:
			space_pressed = false

func trigger_death():
	dead = true
	# Wait a few seconds for explosion to occur before showing UI. Skippable on space
	wait_for_input_or_timeout(7, show_death_ui)
	
func show_death_ui():
	timer_tween.kill()
	timer_tween = null
	death_screen_control.visible = true
	score_control.visible = false

func update_fuel(fuel_count: int) -> void:
	fuel_progress_bar.value = fuel_count

func update_score(score_count: int) -> void:
	score_label.text = "Score: " + str(int(score_count))
	final_score_label.text = "Final Score: " + str(int(score_count))
	high_score_label.text = "High Score: " + str(int(PlayerStats.loaded_high_score))

func update_progress(progress_count: int, progress_goal: int) -> void:
	# THis needs the total progress goal as well.
	if progress_goal < 0 and level_progress_bar.visible == true:
		level_progress_bar.hide()
		progress_label.hide()
	elif progress_goal >= 0 and level_progress_bar.visible == false:
		level_progress_bar.hide()
		progress_label.hide()
	
	level_progress_bar.max_value = progress_goal
	level_progress_bar.value = progress_count

func _on_restart_button_pressed() -> void:
	PlayerStats.reload_fuel()
	PlayerStats.current_score = 0.0
	PlayerStats.current_progress = 0.0
	Globals.restart_level()

func _on_menu_button_pressed() -> void:
	PlayerStats.reload_fuel()
	SoundManager.kill_sound()
	get_tree().change_scene_to_file("res://scenes/story_levels/0_main_menu.tscn")

func slide_face_cam():
	tween = get_tree().create_tween()
	
	# Pan Camera 180deg
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(face_cam, "position:x", 498, 1)
	tween.tween_property(face_cam, "position:y", 241, 1)

func wait_for_input_or_timeout(timeout: float, callback):
	if timer_tween == null:
		timer_tween = get_tree().create_tween()
		timer_tween.tween_interval(timeout)
		timer_tween.tween_callback(callback)
