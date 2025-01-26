extends Node3D

@onready var lid = $Block/Lid
@onready var launchPad = $Block/LaunchPad
@onready var player = $Block/LaunchPad/MenuPlayer

var is_launching = false
var tween
var current_root_position
const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Lid Opening
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(lid, "rotation_degrees:z", -75, 2)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(lid, "rotation_degrees:z", 29.4, 2)
	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(launchPad, "position:y", 0.55, 4)
	
	tween.tween_interval(2)
	tween.tween_callback(trigger_launch)
	tween.tween_interval(5)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(player, "position:y", 100, 5)
	tween.tween_callback(end_sequence)
	
	current_root_position = player.position

func end_sequence() -> void:
	# Trigger next scene
	is_launching = false
	
func trigger_launch() -> void:
	is_launching = true
	player.rocket_particles.gpu_particles_3d.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_launching:
		var random_rumble_x = current_root_position.x + randf_range(0, MAX_RUMBLE_VARIANCE.x)
		var random_rumble_y = current_root_position.y + randf_range(0, MAX_RUMBLE_VARIANCE.y)
		player.position = Vector3(random_rumble_x, random_rumble_y, current_root_position.z)
