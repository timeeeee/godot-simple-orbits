extends Node2D


var orbit_radius

var planet
var angle

func _ready():
	angle = PI / 2
	
	
func _draw():
	draw_circle(Vector2(0, 0), 2, Color(1, 1, 1))
	
	
func set_orbit_radius(radius):
	orbit_radius = radius
	
	
func _process(delta):
	angle += delta * 2


func set_planet(planet_to_orbit):
	planet = planet_to_orbit
