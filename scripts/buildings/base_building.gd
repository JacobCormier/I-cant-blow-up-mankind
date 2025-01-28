extends Node3D

var parent
@onready var visual: Node3D = $Visual
@onready var collider: Node3D = $Collider
var TIMER_DEATH = false

@export var is_asteroid := false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TIMER_DEATH:
		reset_position()
		
	# I'm sorry
	if is_asteroid:
		var random_y = randf_range(-15.0, 30.0)
		var random_scale = randf_range(0.4, 1.0)
		
		visual.position = Vector3(visual.position.x, visual.position.y + random_y, visual.position.z)
		collider.position = Vector3(collider.position.x, collider.position.y + random_y, collider.position.z)
		
		visual.scale = Vector3(visual.scale.x * random_scale, visual.scale.y * random_scale, visual.scale.z * random_scale)
		collider.get_child(0).get_child(0).scale = collider.get_child(0).get_child(0).scale * random_scale
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position():
	await get_tree().create_timer(3).timeout
	parent._reset_object(self)
