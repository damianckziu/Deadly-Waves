extends Sprite2D
var speed = 150
var velocity = Vector2()
var bullet = preload("res://bullet.tscn")
var blood_particles = preload("res://blood_particles.tscn")
var can_shoot = true
var is_dead = false
var stamina = 100.0
var stamina_drain = 40.0
var stamina_regen = 20.0
var dash_speed = 300.0
var stamina_depleted = false
var shield_active = false
var shield_time = 0.0
var shield_max = 100.0
var shield_blink = 0.0
var invincible = false
var enemies_in_hitbox = []

func _ready():
	Global.player = self
	Global.hp = 1 if Global.hardcore else 3
	add_to_group("Player")
	$Shield.visible = false
	if Global.hardcore and Global.node_creation_parent != null:
		Global.node_creation_parent.get_node("HUD/ShieldBar").visible = false

func _exit_tree():
	Global.player = null

func _process(delta):
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = velocity.normalized()
	
	global_position.x = clamp(global_position.x, 24, 616)
	global_position.y = clamp(global_position.y, 24, 336)
	
	if is_dead == false:
		var current_speed = speed
		
		if Input.is_action_pressed("dash") and stamina > 0 and velocity.length() > 0 and stamina_depleted == false:
			current_speed = dash_speed
			stamina -= stamina_drain * delta
			stamina = max(stamina, 0)
			if stamina == 0:
				stamina_depleted = true
				await get_tree().create_timer(3.0).timeout
				stamina_depleted = false
		else:
			if stamina_depleted == false:
				stamina += stamina_regen * delta
				stamina = min(stamina, 100)
		
		global_position += current_speed * velocity * delta
		
		if enemies_in_hitbox.size() > 0 and invincible == false and shield_active == false:
			take_damage()
	
	if Global.node_creation_parent != null:
		Global.node_creation_parent.get_node("HUD/StaminaBar").value = stamina
		update_hearts()
	
	if shield_active:
		shield_time -= delta * 10.0
		shield_time = max(shield_time, 0)
		if Global.node_creation_parent != null:
			Global.node_creation_parent.get_node("HUD/ShieldBar").value = shield_time
		
		if shield_time <= 30.0:
			shield_blink += delta * 8.0
			$Shield.visible = int(shield_blink) % 2 == 0
		else:
			$Shield.visible = true
		
		if shield_time <= 0:
			shield_active = false
			$Shield.visible = false
			$ShieldBreakSound.play()
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ShootSound.play()
		$Reload_speed.start()
		can_shoot = false

func take_damage():
	Global.hp -= 1
	$DamageSound.play()
	if Global.hp <= 0:
		is_dead = true
		visible = false
		if Global.node_creation_parent != null:
			Global.arena.get_node("LoseSound").play()
			var blood = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood.color = Color("006ac4c8")
			blood.rotation = velocity.angle()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://game_over.tscn")
	else:
		invincible = true
		modulate = Color(0.5, 0.5, 0.5, 1.0)
		await get_tree().create_timer(1.5).timeout
		modulate = Color(0, 0, 1, 1)
		invincible = false

func update_hearts():
	var hearts = Global.node_creation_parent.get_node("HUD/Hearts")
	if Global.hardcore:
		var heart = hearts.get_node("Heart3")
		if Global.hp >= 1:
			heart.modulate.a = 1.0
			heart.scale = Vector2(0.015, 0.015)
		else:
			heart.modulate.a = 0.3
			heart.scale = Vector2(0.012, 0.012)
	else:
		for i in range(3):
			var heart = hearts.get_child(i)
			if i < Global.hp:
				heart.modulate.a = 1.0
				heart.scale = Vector2(0.015, 0.015)
			else:
				heart.modulate.a = 0.3
				heart.scale = Vector2(0.012, 0.012)

func activate_shield():
	shield_active = true
	shield_time = 100.0
	shield_blink = 0.0
	$Shield.visible = true
	$ShieldPickupSound.play()

func _on_Reload_speed_timeout():
	can_shoot = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy") and is_dead == false:
		enemies_in_hitbox.append(area)

func _on_hitbox_area_exited(area):
	if area.is_in_group("Enemy"):
		enemies_in_hitbox.erase(area)
