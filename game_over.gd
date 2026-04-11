extends Node2D
func _ready():
	$PointsLabel.text = "WYNIK - " + str(Global.points)
	$WaveLabel.text = "FALA - " + str(Global.current_wave)
func _on_button_pressed():
	get_tree().change_scene_to_file("res://arena.tscn")
