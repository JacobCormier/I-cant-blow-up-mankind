extends Node3D

var parent

var TIMER_DEATH = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TIMER_DEATH:
		loop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loop():
	await get_tree().create_timer(randf()).timeout
	parent._reset_object(self)
	loop()
