extends Node3D

@onready var game_globe: Node3D = $"../GameGlobe"

func _ready():
	PlayerStats.on_begin_transition.connect(begin_transition)
	
func begin_transition(callback: Callable):
	if Globals.current_level == 1:
		get_tree().change_scene_to_file("res://scenes/cutscenes/transition_1_2.tscn")
	elif Globals.current_level == 2:
		get_tree().change_scene_to_file("res://scenes/cutscenes/transition_2_3.tscn")
	else:
		callback.call()
