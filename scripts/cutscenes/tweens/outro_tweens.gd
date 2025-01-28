extends Object

class_name OutroTween
	
func step2(caller, tween):
	# Shake Camera as rocket flies by
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(caller, "rumble_intensity", 4,  3)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(caller, "rumble_intensity", 0,  5)	
	
func step3():
	pass
	
func step4():
	pass
	
func step5():
	pass
	
func step6():
	pass
