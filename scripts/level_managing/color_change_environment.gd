extends Node

@onready var game_globe: Node3D = $"../GameGlobe"

@export var color_array: Array[Color]
var current_sky_color: Color
var current_ground_color: Color
var target_sky_color: Color
var target_ground_color: Color
var transition_progress: float = 0.0
var transition_speed: float = 0.001  # Adjust this for smoother/faster transitions

func _ready() -> void:
	if color_array.is_empty():
		push_error("Color array is empty!")
		return
	
	# Random initial colors
	current_sky_color = color_array.pick_random()
	current_ground_color = color_array.pick_random()
	
	# Ensure sky and ground colors are different
	while current_ground_color == current_sky_color:
		current_ground_color = color_array.pick_random()
	
	# Apply initial colors
	set_environment_color(current_ground_color, current_sky_color)
	
	# Pick first transition target colors
	select_new_target_colors()

func select_new_target_colors() -> void:
	target_sky_color = color_array.pick_random()
	target_ground_color = color_array.pick_random()
	
	# Ensure new colors are different from each other
	while target_ground_color == target_sky_color:
		target_ground_color = color_array.pick_random()
	
	transition_progress = 0.0  # Reset progress for smooth transition

func _process(delta: float) -> void:
	if transition_progress < 1.0:
		transition_progress += transition_speed
		
		# Lerp between current and target colors
		var lerped_sky_color = current_sky_color.lerp(target_sky_color, transition_progress)
		var lerped_ground_color = current_ground_color.lerp(target_ground_color, transition_progress)
		
		# Apply interpolated colors
		set_environment_color(lerped_ground_color, lerped_sky_color)
	else:
		# Once transition is done, update current colors and select new targets
		current_sky_color = target_sky_color
		current_ground_color = target_ground_color
		select_new_target_colors()

func set_environment_color(ground_color: Color, sky_color: Color) -> void:
	game_globe.set_environment_color(ground_color, sky_color)
