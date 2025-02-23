extends Node

const MAX_RUMBLE_VARIANCE := Vector3(0.25, 0.08, 0)

func rumble(node, root_position, x_scale = 1, y_scale = 1, override_max_rumble_variance = MAX_RUMBLE_VARIANCE):
	var random_rumble_x = root_position.x + randf_range(-override_max_rumble_variance.x/2, override_max_rumble_variance.x/2) * x_scale
	var random_rumble_y = root_position.y + randf_range(-override_max_rumble_variance.y/2, override_max_rumble_variance.y/2) * y_scale
	node.position = Vector3(random_rumble_x, random_rumble_y, root_position.z)
