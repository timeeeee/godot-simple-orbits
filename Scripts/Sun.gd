extends Node2D

export(float) var radius = 100

func _draw():
	draw_circle(Vector2(0, 0), radius, Color("#f9ac3d"))
