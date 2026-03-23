extends Node2D

var enemy_1 = preload("res://enemy.tscn")

func _ready():
	Global.node_creation_parent = self
	Global.points = 0
	$PauseMenu.visible = false

func _exit_tree():
	Global.node_creation_parent = null

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_resume()
		else:
			_pause()

func _pause():
	$PauseMenu.visible = true
	get_tree().paused = true

func _resume():
	$PauseMenu.visible = false
	get_tree().paused = false

func _on_enemy_spawn_timer_timeout():
	var enemy_position = Vector2(randf_range(-160, 670), randf_range(-90, 390))
	
	while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(randf_range(-160, 670), randf_range(-90, 390))
	
	Global.instance_node(enemy_1, enemy_position, self)

func _on_difficulty_timer_timeout():
	if $Enemy_spawn_timer.wait_time > 0.5:
		$Enemy_spawn_timer.wait_time -= 0.1

func _on_wroc_pressed():
	_resume()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
