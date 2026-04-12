extends Sprite2D
var speed = 75
var velocity = Vector2()
var stun = false
var hp = 3
var points_value = 10
var blood_particles = preload("res://blood_particles.tscn")
var enemy_color = Color("fd0043")
var last_velocity = Vector2()
var running_away = false

func _ready():
	modulate = Color("fd0043")

func _process(delta):
	if running_away:
		global_position += velocity * speed * 2 * delta
		return
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
		last_velocity = velocity
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
	
	global_position += velocity * speed * delta
	 
	if hp <= 0:
		Global.points += points_value
		if Global.arena != null:
			Global.arena.get_node("DeathSound").play()
			Global.arena.enemy_died()
		if Global.node_creation_parent != null:
			var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood_particles_instance.rotation = last_velocity.angle() + PI
			blood_particles_instance.color = enemy_color.darkened(0.4)
			var label = Label.new()
			var font = load("res://ka1.ttf")
			label.add_theme_font_override("font", font)
			label.text = "+" + str(points_value)
			label.position = global_position
			label.add_theme_color_override("font_color", enemy_color)
			Global.node_creation_parent.add_child(label)
			var tween = label.create_tween()
			tween.tween_property(label, "position:y", global_position.y - 40, 0.8)
			tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
			tween.tween_callback(label.queue_free)
		queue_free()

func run_away():
	running_away = true
	if Global.player != null:
		velocity = global_position.direction_to(Global.player.global_position) * -1
	else:
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy_damager") and stun == false:
		modulate = Color.WHITE
		velocity = -velocity * 6
		hp -= 1
		stun = true
		$Stun_timer.start()
		area.get_parent().queue_free()

func _on_stun_timer_timeout():
	stun = false
	if speed >= 100:
		enemy_color = Color("ffd700")
		modulate = Color("ffd700")
	elif speed <= 50:
		enemy_color = Color("9b30ff")
		modulate = Color("9b30ff")
	else:
		enemy_color = Color("fd0043")
		modulate = Color("fd0043")
