extends Node2D

func _ready():
	$StatsPanel.visible = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://arena.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_stats_button_pressed():
	$StatsPanel.visible = !$StatsPanel.visible
	if $StatsPanel.visible:
		$StatsPanel/StatsLabel.text = "WYNIK - " + str(Global.points) + "\nFALA - " + str(Global.current_wave) + "\nZABICI WROGOWIE - " + str(Global.enemies_killed) + "\nCZAS - " + Global.get_time_string()

func _on_stats_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
