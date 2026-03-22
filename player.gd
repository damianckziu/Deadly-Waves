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

func _ready():
	Global.player = self

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
		var hud = Global.node_creation_parent.get_node("HUD/StaminaBar")
		hud.value = stamina
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$Reload_speed.start()
		can_shoot = false

func _on_Reload_speed_timeout():
	can_shoot = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy") and is_dead == false:
		is_dead = true
		visible = false
		
		if Global.node_creation_parent != null:
			var blood = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood.color = Color("1e90ff")
			blood.rotation = velocity.angle()
		
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://game_over.tscn")
