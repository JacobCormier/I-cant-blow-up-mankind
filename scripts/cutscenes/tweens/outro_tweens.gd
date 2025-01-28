extends Object

class_name OutroTweens

static var tween
static var intro_tween
static var moon_reveal_tween
static var finale_tween

static func play_sequence(caller: Node):
	var outro_tweens = OutroTweens.new()
	tween = caller.get_tree().create_tween()
	
	# Create Tweens
	intro_tween = caller.get_tree().create_tween()
	moon_reveal_tween = caller.get_tree().create_tween()
	#finale_tween = caller.get_tree().create_tween()
	
	# Configure Primary Tween
	tween.tween_subtween(intro_tween)
	tween.tween_subtween(moon_reveal_tween)
	#tween.tween_subtween(finale_tween)
	
	# Configure Tweens
	intro_tween = outro_tweens.intro(caller, intro_tween)
	moon_reveal_tween = outro_tweens.moon_reveal(caller, moon_reveal_tween)
	#finale_tween = outro_tweens.finale(caller, finale_tween)
	
func intro(caller, tween):
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_callback(caller.intro_started)
	tween.tween_interval(2)
	sputter(caller, tween, 1)
	sputter(caller, tween, 0.5)
	sputter(caller, tween, 0.5)
	sputter(caller, tween, 0.1)
	sputter(caller, tween, 0.3)
	sputter(caller, tween, 0.2)
	sputter(caller, tween, 0.1)
	sputter(caller, tween, 0.5)
	tween.tween_callback(caller.stop_particles)
	tween.tween_interval(1)
	tween.tween_callback(caller.stop_camera_shake)
	tween.tween_interval(2) # Time after full cutout
	
func moon_reveal(caller, tween):
	tween.tween_callback(caller.moon_reveal_started)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(caller.moon_reveal_light, "rotation_degrees:x", -180, 5).as_relative()
	tween.tween_interval(2)
	
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(caller.moon_visual, "position:z", 10300.095, 10)
	
func finale(caller, tween):
	tween.tween_callback(caller.finale_started)
	tween.tween_interval(2)
	
func sputter(caller, tween, time):
	tween.tween_callback(caller.stop_camera_shake)
	tween.tween_interval(0.05)
	tween.tween_callback(caller.start_camera_shake)
	tween.tween_interval(time)
	
