
player_ctrl:
	control me in scene

shooter_excitation:


# delay and cache
for pixel[x,y] in canvas:
	generate_ray([x,y], ray)
	# ray = [x0, y0] + t * [x1, y1]
	module rasterizer(ray, color)
	show color

module generate_ray(ray):
	for me in scene:
		solve ray

module rasteriser(input ray, output color):
	# iter to intersect
	module sdf(ray, dt, max_t)
	ray = ray + dt
	# intersect !
	fetch_color
	# shading
	# fetch_shading
	# done
	#  compose color

module sdf(input ray, output dt):
	# binary optimization
	for object in scene:
		if box:
			ret = min(ret, box_sdf(ray))
		if sphere:
			ret = min(ret, sphere_sdf(ray))

module fetch_color(coordinates):
	fetch_normal
	for light in scene;
		fetch light
		solve color
	compose color

module fetch_shading(coordinates):
	for light in scene:
		fetch light
		fetch dist
		sdf(light, dt, max_dist)
		if dt:
			add shading
	compose shading

# main issue
scene structrue:
	player
	object info and approximation
	light
	collision

sdf_obj:
	sphere:
		3D vector
		solve angle between ray and OO1
		solve sin and cos value
	triangle composed:
		local coordinates conversion
		type:
			box
			...