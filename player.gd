extends Sprite2D

var speed = 150
var velocity = Vector2()

var bullet = preload("res://bullet.tscn")
var blood_particles = preload("res://blood_particles.tscn")

var can_shoot = true
var is_dead = false

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
		global_position += speed * velocity * delta
	
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
			blood.color = Color("004a8ddd")
			blood.rotation = velocity.angle()
		
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://game_over.tscn")
