extends WorldEnvironment


func set_sky_color(color: Color):
	environment.sky.sky_material.sky_top_color = color
	environment.sky.sky_material.sky_horizon_color = color
	environment.sky.sky_material.ground_bottom_color = color
	environment.sky.sky_material.ground_horizon_color = color
