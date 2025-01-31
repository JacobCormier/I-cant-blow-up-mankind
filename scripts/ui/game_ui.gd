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
@onready var static_effect: TextureRect = $FaceCam/StaticEffect

@onready var level_progress_bar: TextureProgressBar = $ScoreControl/LevelProgressBar
@onready var progress_label: Label = $ScoreControl/ProgressLabel

@onready var white_transition: ColorRect = $WhiteTransition
@onready var skip_prompt: Panel = $SkipPrompt
@onready var initial_move_prompt: Panel = $InitialPrompt
@onready var jump_prompt: Panel = $JumpPrompt

var rumble_intensity = 0
var camera_root_position

var tween
var space_pressed = false
var static_transition_time = 0.5

var is_dead := false
var has_skip := false

var is_player_input_disabled := false

func _ready():
	camera_root_position = get_viewport().get_camera_3d().position
	death_screen_control.visible = false
	PlayerStats.on_fuel_changed.connect(update_fuel)
	PlayerStats.on_score_changed.connect(update_score)
	PlayerStats.on_progress_changed.connect(update_progress)
	PlayerStats.start_gameplay()
	initial_move_prompt.visible = not PlayerStats.save_data.has_moved
	jump_prompt.visible = not PlayerStats.save_data.has_jumped
	slide_face_cam()
	
func _process(delta):
	if static_effect.material and static_effect.material.is_class("ShaderMaterial"):
		if not is_dead:
			static_transition_time = max(0, ((randf() - 0.5)) + 0.3)
		var shader_material = static_effect.material as ShaderMaterial
		shader_material.set("shader_parameter/time", static_transition_time)
	
	face_cam.texture = sub_viewport.get_texture()
	if face_cam.material and face_cam.material.is_class("ShaderMaterial"):
		var shader_material = face_cam.material as ShaderMaterial
		shader_material.set("shader_parameter/time", Time.get_ticks_msec() / 1000.0)
		shader_material.set("shader_parameter/resolution", Vector2(sub_viewport.size.x, sub_viewport.size.y))
		shader_material.set("shader_parameter/texture_albedo", sub_viewport.get_texture())
		
	if rumble_intensity > 0:
		AnimationUtils.rumble(get_viewport().get_camera_3d(), camera_root_position, rumble_intensity, rumble_intensity, Vector3(1.0, 1.0, 1.0))
		
		
	# Quick death skip check
	if is_dead:
		is_dead = false
		await get_tree().create_timer(0.5, false, false, true).timeout
		has_skip = true
		skip_prompt.show()

func _input(event):
	face_cam_rocket._input(event)

	# Reset Command
	if has_skip:  # Check if it's a key event
		if Input.is_action_pressed("left"):
			_on_restart_button_pressed()
		elif Input.is_action_pressed("right"):
			_on_menu_button_pressed()
			
	# Checks for beginner controls
	if not is_player_input_disabled:
		# Move
		if PlayerStats.save_data.has_moved == false:
			if Input.is_action_pressed("left"):
				PlayerStats.save_data.has_moved = true
				initial_move_prompt.visible = false
			if Input.is_action_pressed("right"):
				PlayerStats.save_data.has_moved = true
				initial_move_prompt.visible = false
				
		# Jump
		if PlayerStats.save_data.has_jumped == false:
			if Input.is_action_pressed("jump"):
				PlayerStats.save_data.has_jumped = true
				jump_prompt.visible = false
			
func trigger_death():
	if PlayerStats.save_data.has_exploded == false:
		PlayerStats.save_data.has_exploded = true
	else:
		is_dead = true
		
	is_player_input_disabled = true
	
	face_cam_rocket.on_death()
	
	var tween = get_tree().create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property(white_transition, "modulate:a", 1.0, 4)
	tween.parallel().tween_property(self, "rumble_intensity", 15, 4)
	tween.parallel().tween_property(self, "static_transition_time", 10, 4)
	tween.tween_interval(3.0)
	tween.tween_callback(skip_prompt_timeout)
	tween.tween_property(white_transition, "modulate:a", 0.0, 2)
	
func skip_prompt_timeout() -> void:
	show_death_ui()
	skip_prompt.hide()
	face_cam.hide()
	jump_prompt.hide()
	initial_move_prompt.hide()
	has_skip = true
	
func show_death_ui():
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
	SoundManager.kill_engine()
	get_tree().change_scene_to_file("res://scenes/story_levels/0_main_menu.tscn")

func slide_face_cam():
	tween = get_tree().create_tween()
	
	# Pan Camera 180deg
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(face_cam, "position:x", 498, 1)
	tween.tween_property(face_cam, "position:y", 241, 1)
