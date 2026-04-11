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

func _ready():
	Global.player = self
	add_to_group("Player")
	$Shield.visible = false

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
	
	if Global.node_creation_parent != null:
		Global.node_creation_parent.get_node("HUD/StaminaBar").value = stamina
	
	if shield_active:
		shield_time -= delta * 10.0
		shield_time = max(shield_time, 0)
		if Global.node_creation_parent != null:
			Global.node_creation_parent.get_node("HUD/ShieldBar").value = shield_time
		if shield_time <= 0:
			shield_active = false
			$Shield.visible = false
			$ShieldBreakSound.play()
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ShootSound.play()
		$Reload_speed.start()
		can_shoot = false

func activate_shield():
	shield_active = true
	shield_time = 100.0
	$Shield.visible = true
	$ShieldPickupSound.play()

func _on_Reload_speed_timeout():
	can_shoot = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy") and is_dead == false and shield_active == false:
		is_dead = true
		visible = false
		
		if Global.node_creation_parent != null:
			Global.arena.get_node("LoseSound").play()
			var blood = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood.color = Color("006ac4c8")
			blood.rotation = velocity.angle()
		
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://game_over.tscn")
