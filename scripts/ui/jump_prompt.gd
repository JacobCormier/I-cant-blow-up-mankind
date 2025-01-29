extends Panel

var is_animating := false
@onready var up_arrow: TextureRect = $UpArrow


func _process(delta: float) -> void:
	if self.visible and not is_animating:
		is_animating = true
		var tween = get_tree().create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_loops()
		var movement = 20
		var duration = 1.0
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(up_arrow, "position:y", up_arrow.position.y + movement, duration)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(up_arrow, "position:y", up_arrow.position.y - movement, duration / 2)
		
