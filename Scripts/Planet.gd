extends Node2D
class_name Planet

var colors = [
	Color("#cf4917"),  # Burnt Sienna
	Color("#985914"),  # teak
	Color("#d0b285"),  # natural
	Color("#758c33"),  # avocado
	Color("#2d758c")  # blue mustang
]

var color: Color
var radius: int  # size of planet
var distance_from_sun: float  # range from 0 to 1
var angle: float  # position around orbit in radians



# Called when the node enters the scene tree for the first time.
func _ready():
	color = colors[randi() % colors.size()]
	angle = 0
	
	
func set_random_radius(min_radius, max_radius):
	radius = (randi() % (max_radius - min_radius + 1)) + min_radius


func _draw():
	draw_circle(Vector2(0, 0), radius, color)
	draw_arc(Vector2(0, 0), radius, 0, 2 * PI, 32, color.darkened(.2), 2)


func set_distance_from_sun(distance):
	# distance between 0 and 1
	distance_from_sun = distance
	
	
func set_random_distance_from_sun():
	distance_from_sun = randf()


func _process(delta):
	angle += delta * .1 / pow(distance_from_sun, 2.0/3)
