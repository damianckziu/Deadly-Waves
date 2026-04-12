extends Node2D
func _on_normal_button_pressed():
	Global.hardcore = false
	get_tree().change_scene_to_file("res://arena.tscn")

func _on_hardcore_button_pressed():
	Global.hardcore = true
	get_tree().change_scene_to_file("res://arena.tscn")
