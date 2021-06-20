extends Node2D

export(float) var semi_major_radius  # how far system extends left and right from sun
export(float) var semi_minor_radius  # how far up and down

export(float) var orbit_altitude  # how far from planets to orbit
export(int) var min_planet_radius
export(int) var max_planet_radius

export(float) var orbit_speed = .1  # max planet will orbit at .1 radians / s
export(float) var gravity = 1

export(PackedScene) var Planet

var planets: Array
var spaceship


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	planets = []
	generate_planets(4, 10)
	
	# set spaceship's orbit
	spaceship = $YSort/Spaceship
	spaceship.set_planet(planets[randi() % planets.size()])
	spaceship.set_orbit_radius(orbit_altitude + spaceship.planet.radius)
	
	
func generate_planets(minimum, minimum_tries):
	# generate at least 'minimum' planets, with at least 'minimum_tries' tries
	# start them all to the right of the sun at 0 radians
	# outermost planet first
	var first = Planet.instance()
	first.set_random_radius(min_planet_radius, max_planet_radius)  # set size, texture etc.
	first.set_distance_from_sun(1)
	$YSort.add_child(first)
	planets.push_back(first)
	
	# try making at least 'minimum' planets with at least 'minimum_tries' tries
	var tries = 0
	while planets.size() < minimum or tries < minimum_tries:
		tries += 1
		# print("try #", tries)
		var new_planet = Planet.instance()
		new_planet.set_random_radius(min_planet_radius, max_planet_radius)
		new_planet.set_random_distance_from_sun()
		# print("distance ", new_planet.distance_from_sun, " from sun")
		
		if is_planet_too_close(new_planet):
			new_planet.queue_free()
			continue

		$YSort.add_child(new_planet)
		planets.push_back(new_planet)
		
	# move them to random places in their orbits
	for planet in planets:
		planet.angle = randf() * 2 * PI
		
	
	
func is_planet_too_close(planet):
	# is this planet too close to an already existing planet?
	var start_x = semi_major_radius * planet.distance_from_sun
	var min_x = start_x - planet.radius - orbit_altitude
	var max_x = start_x + planet.radius + orbit_altitude
	for other in planets:
		if other == planet:
			continue
			
		# if their orbital space overlaps when aligned at angle = 0, they're too close
		var other_start_x = semi_major_radius * other.distance_from_sun
		var other_min_x = other_start_x - other.radius - orbit_altitude
		var other_max_x = other_start_x + other.radius + orbit_altitude
		
		if max_x >= other_min_x and min_x <= other_max_x:
			# print("regions (", min_x, ", ", max_x, ") and (", other_min_x, ", ", other_max_x, ") overlap")
			return true
		
	# or the sun?
	var sun_max_x = $YSort/Star.radius
	if min_x <= sun_max_x:
		# print("region (", min_x, ", ", max_x, ") overlaps with sun")
		return true
		
	return false


func _process(_delta):
	# rotate planets around the sun
	for planet in planets:
		planet.position.x = cos(planet.angle) * semi_major_radius * planet.distance_from_sun
		planet.position.y = sin(planet.angle) * semi_minor_radius * planet.distance_from_sun
		
	# move spaceship to correct position based on planet it's orbiting
	spaceship.position.x = spaceship.planet.position.x + cos(spaceship.angle) * spaceship.orbit_radius
	spaceship.position.y = spaceship.planet.position.y + sin(spaceship.angle) * spaceship.orbit_radius * semi_minor_radius / semi_major_radius
	
# draw orbits
func _draw():
	var num_points = 100
	for planet in planets:
		for i in range(num_points + 1):
			var from = Vector2(
				cos(2 * PI * i / num_points) * semi_major_radius * planet.distance_from_sun,
				sin(2 * PI * i / num_points) * semi_minor_radius * planet.distance_from_sun)
			
			var to = Vector2(
				cos(2 * PI * (i + 1) / num_points) * semi_major_radius * planet.distance_from_sun,
				sin(2 * PI * (i + 1) / num_points) * semi_minor_radius * planet.distance_from_sun)
			
			draw_line(from, to, planet.color.darkened(.6), 1)
