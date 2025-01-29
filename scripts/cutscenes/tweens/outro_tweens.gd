extends Object

class_name OutroTweens

static var tween
static var intro_tween
static var moon_reveal_tween
static var orbit_moon_tween
static var finale_tween

static func play_sequence(caller: Node):
	var outro_tweens = OutroTweens.new()
	tween = caller.get_tree().create_tween()
	
	# Create Tweens
	intro_tween = caller.get_tree().create_tween()
	moon_reveal_tween = caller.get_tree().create_tween()
	orbit_moon_tween = caller.get_tree().create_tween()
	finale_tween = caller.get_tree().create_tween()
	
	# Configure Primary Tween
	tween.tween_subtween(intro_tween)
	tween.tween_subtween(moon_reveal_tween)
	tween.tween_subtween(orbit_moon_tween)
	tween.tween_subtween(finale_tween)
	
	# Configure Tweens
	intro_tween = outro_tweens.intro(caller, intro_tween, 0.1)
	moon_reveal_tween = outro_tweens.moon_reveal(caller, moon_reveal_tween, 0.1)
	orbit_moon_tween = outro_tweens.orbit_moon(caller, orbit_moon_tween, 0.1)
	finale_tween = outro_tweens.finale(caller, finale_tween)
	
func intro(caller, tween, time_scale = 1):
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_callback(caller.intro_started)
	tween.tween_interval(2 * time_scale)
	sputter(caller, tween, 1 * time_scale)
	sputter(caller, tween, 0.5 * time_scale)
	sputter(caller, tween, 0.5 * time_scale)
	sputter(caller, tween, 0.1 * time_scale)
	sputter(caller, tween, 0.3 * time_scale)
	sputter(caller, tween, 0.2 * time_scale)
	sputter(caller, tween, 0.1 * time_scale)
	sputter(caller, tween, 0.5 * time_scale)
	tween.tween_callback(caller.stop_particles)
	tween.tween_interval(1 * time_scale)
	tween.tween_callback(caller.stop_camera_shake)
	tween.tween_interval(2 * time_scale) # Time after full cutout
	
func moon_reveal(caller, tween, time_scale = 1):
	tween.tween_callback(caller.moon_reveal_started)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(caller.moon_reveal_light, "rotation_degrees:x", -140, 5 * time_scale).as_relative()
	tween.tween_interval(0 * time_scale)
	
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(caller.moon_visual, "position:y", -18.91, 10 * time_scale)
	tween.parallel().tween_property(caller.moon_visual, "position:z", 10288.414, 10 * time_scale)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(caller.reveal_cam, "position:x", -4.369, 4 * time_scale)
	tween.parallel().tween_property(caller.reveal_cam, "position:y", -8.522, 4 * time_scale)
	tween.parallel().tween_property(caller.reveal_cam, "position:z", -7.224, 4 * time_scale)
	tween.parallel().tween_property(caller.reveal_cam, "rotation_degrees:x", 56.8, 4 * time_scale)
	tween.parallel().tween_property(caller.reveal_cam, "rotation_degrees:y", 178.2, 4 * time_scale)
	tween.parallel().tween_property(caller.reveal_cam, "rotation_degrees:z", 8.2, 4 * time_scale)
	tween.parallel().tween_property(caller.player, "rotation_degrees:x", -32.4, 4 * time_scale)
	tween.parallel().tween_property(caller.player, "rotation_degrees:y", -5.5, 4 * time_scale)
	tween.parallel().tween_property(caller.player, "rotation_degrees:z", -7.6, 4 * time_scale)

func orbit_moon(caller, tween, time_scale = 1):
	tween.tween_callback(caller.orbit_moon_started)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(caller.orbit_control, "rotation_degrees:x", -169.0, 4 * time_scale).as_relative() # 2.3 seconds?
	tween.parallel().tween_property(caller.orbit_control, "rotation_degrees:y", 19.5, 4 * time_scale)

func finale(caller, tween, time_scale = 1):
	tween.tween_callback(caller.finale_started)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(caller.orbit_player, "position:x", 400, 8 * time_scale).as_relative()
	tween.parallel().tween_property(caller.orbit_player, "position:y", 200, 8 * time_scale).as_relative()
	tween.parallel().tween_property(caller.orbit_player, "position:z", 1400, 8 * time_scale).as_relative()
	
	tween.tween_property(caller.orbit_cam, "rotation_degrees:x", 102.3, 4 * time_scale)
	tween.parallel().tween_property(caller.orbit_cam, "rotation_degrees:y", 207.2, 4 * time_scale)
	tween.parallel().tween_property(caller.orbit_cam, "rotation_degrees:z", -7.22, 4 * time_scale)
	tween.parallel().tween_property(caller.orbit_cam, "fov", 150, 4 * time_scale)
	tween.parallel().tween_property(caller.icbm_character, "position:x", -31, 4 * time_scale).as_relative()
	tween.parallel().tween_property(caller.icbm_character, "position:y", 400, 4 * time_scale).as_relative()
	tween.parallel().tween_property(caller.icbm_character, "position:z", -85, 4 * time_scale).as_relative()
	
func sputter(caller, tween, time):
	tween.tween_callback(caller.stop_camera_shake)
	tween.tween_interval(0.05)
	tween.tween_callback(caller.start_camera_shake)
	tween.tween_interval(time)
	
