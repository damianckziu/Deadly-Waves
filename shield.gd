extends Node2D

func _draw():
	draw_circle(Vector2.ZERO, 20, Color(0.510, 0.667, 1.0, 0.3))
	draw_arc(Vector2.ZERO, 20, 0, TAU, 32, Color(0.510, 0.667, 1.0, 0.8), 2.0)

func _process(delta):
	queue_redraw()
