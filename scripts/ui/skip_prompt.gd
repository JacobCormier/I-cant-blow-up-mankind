extends Panel

var is_animating := false
@onready var left_arrow: TextureRect = $Control/LeftArrow
@onready var right_arrow: TextureRect = $Control/RightArrow

func _process(delta: float) -> void:
	if self.visible and not is_animating:
		is_animating = true
		var tween = get_tree().create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_loops()
		var movement = 20
		var duration = 1.0
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(left_arrow, "position:x", left_arrow.position.x + movement, duration)
		tween.parallel().tween_property(right_arrow, "position:x", right_arrow.position.x - movement, duration)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(left_arrow, "position:x", left_arrow.position.x - movement, duration / 2)
		tween.parallel().tween_property(right_arrow, "position:x", right_arrow.position.x + movement, duration / 2)
		
