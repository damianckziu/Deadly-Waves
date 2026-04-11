extends Area2D

func _ready():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = Vector2(20, 20)
	$ColorRect.size = Vector2(20, 20)
	$ColorRect.position = Vector2(-10, -10)
	$ColorRect.color = Color("3b75ff")
	connect("area_entered", _on_area_entered)

func _on_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		area.get_parent().activate_shield()
		queue_free()
