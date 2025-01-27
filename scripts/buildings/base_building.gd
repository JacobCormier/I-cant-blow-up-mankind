extends Node3D

var parent

var TIMER_DEATH = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TIMER_DEATH:
		reset_position()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position():
	await get_tree().create_timer(3).timeout
	parent._reset_object(self)
