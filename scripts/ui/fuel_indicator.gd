extends Panel

const FUEL_WARNING_LEVEL = 33
var is_indicator_on := false

var root_scale
var tween: Tween

func _ready() -> void:
	root_scale = scale
	PlayerStats.on_fuel_changed.connect(check_fuel_level)
	PlayerStats.on_player_death.connect(disable_fuel_indicator)


func check_fuel_level(fuel_amount: int) -> void:
	if fuel_amount <= FUEL_WARNING_LEVEL and not is_indicator_on:
		trigger_fuel_indicator()
	elif fuel_amount > FUEL_WARNING_LEVEL and is_indicator_on:
		disable_fuel_indicator()
	elif fuel_amount == 0:
		disable_fuel_indicator()


func trigger_fuel_indicator() -> void:
	is_indicator_on = true
	
	if tween != null:
		tween.kill()
		tween = null
		
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.2, 2.0), 0.1)
	tween.tween_property(self, "scale", Vector2(1.1, 1.2), 0.1)
	

func disable_fuel_indicator() -> void:
	is_indicator_on = false
	
	if tween != null:
		tween.kill()
		tween = null
	
	if get_tree() == null:
		return
	
	tween = get_tree().create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", root_scale, 0.1)
	
