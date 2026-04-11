extends Area2D

func _ready():
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 20)
	$CollisionShape2D.shape = shape
	connect("area_entered", _on_area_entered)

func _on_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		area.get_parent().activate_shield()
		queue_free()
