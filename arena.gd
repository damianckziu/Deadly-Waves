extends Node2D
var enemy_1 = preload("res://enemy.tscn")
var powerup_1 = preload("res://powerup.tscn")
var current_wave = 0
var enemies_alive = 0
var spawning = false
var music_on = true

func _ready():
	Global.node_creation_parent = self
	Global.points = 0
	Global.arena = self
	Global.enemies_killed = 0
	Global.game_time = 0.0
	$PauseMenu.visible = false
	$HUD/WaveCounter.text = "FALA 0"
	if Global.hardcore:
		$HUD/ShieldBar.visible = false
		$HUD/Hearts/Heart1.visible = false
		$HUD/Hearts/Heart2.visible = false
		$PowerupSpawnTimer.stop()
	else:
		$PowerupSpawnTimer.start()
	start_next_wave()

func _exit_tree():
	Global.node_creation_parent = null

func _process(delta):
	if not get_tree().paused:
		Global.game_time += delta
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

func start_next_wave():
	current_wave += 1
	Global.current_wave = current_wave
	$HUD/WaveCounter.text = "FALA: " + str(current_wave)
	spawning = true
	
	$HUD/WaveLabel.text = "FALA " + str(current_wave)
	$HUD/WaveLabel.visible = true
	$HUD/WaveCounter.visible = false
	await get_tree().create_timer(2.0).timeout
	$HUD/WaveLabel.visible = false
	$HUD/WaveCounter.visible = true
	
	var enemies_to_spawn = 3 + (current_wave * 2)
	enemies_alive = enemies_to_spawn
	
	for i in range(enemies_to_spawn):
		var type = get_enemy_type()
		spawn_enemy(type)
		await get_tree().create_timer(0.3).timeout
	
	spawning = false

func get_enemy_type():
	var roll = randf()
	if current_wave >= 8:
		if roll < 0.6:
			return "normal"
		elif roll < 0.85:
			return "fast"
		else:
			return "big"
	elif current_wave >= 5:
		if roll < 0.75:
			return "normal"
		else:
			return "fast"
	else:
		return "normal"

func spawn_enemy(type):
	var enemy_position = Vector2(randf_range(-160, 670), randf_range(-90, 390))
	while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(randf_range(-160, 670), randf_range(-90, 390))
	
	var e = Global.instance_node(enemy_1, enemy_position, self)
	
	if type == "fast":
		e.speed = 100
		e.hp = 1
		e.scale = Vector2(1.0, 1.0)
		e.modulate = Color("ffd700")
		e.enemy_color = Color("ffd700")
		e.points_value = 15
	elif type == "big":
		e.speed = 50
		e.hp = 5
		e.scale = Vector2(2.5, 2.5)
		e.modulate = Color("9b30ff")
		e.enemy_color = Color("9b30ff")
		e.points_value = 20
	else:
		e.speed = 75
		e.hp = 3
		e.scale = Vector2(1.5, 1.5)
		e.modulate = Color("fd0043")
		e.enemy_color = Color("fd0043")
		e.points_value = 10

func spawn_powerup():
	var pos = Vector2(randf_range(50, 590), randf_range(50, 310))
	Global.instance_node(powerup_1, pos, self)

func enemy_died():
	enemies_alive -= 1
	Global.enemies_killed += 1
	if enemies_alive <= 0 and spawning == false:
		await get_tree().create_timer(1.5).timeout
		start_next_wave()

func _on_wroc_pressed():
	_resume()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_powerup_spawn_timer_timeout():
	spawn_powerup()

func _on_music_button_pressed():
	music_on = !music_on
	if music_on:
		$Music.play()
		$PauseMenu/MusicButton.text = "MUZYKA: ON"
	else:
		$Music.stop()
		$PauseMenu/MusicButton.text = "MUZYKA: OFF"
