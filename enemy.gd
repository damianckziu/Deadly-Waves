extends Sprite2D
var speed = 75
var velocity = Vector2()
var stun = false
var hp = 3
var blood_particles = preload("res://blood_particles.tscn")
var enemy_color = Color("fd0043")
func _ready():
	modulate = Color("fd0043")
func _process(delta):
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
	
	global_position += velocity * speed * delta
	 
	if hp <= 0:
		Global.points += 10
		if Global.arena != null:
			Global.arena.get_node("DeathSound").play()
			Global.arena.enemy_died()
		if Global.node_creation_parent != null:
			var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood_particles_instance.rotation = velocity.angle()
			blood_particles_instance.color = enemy_color.darkened(0.4)
		queue_free()
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
	elif speed <= 40:
		enemy_color = Color("9b30ff")
		modulate = Color("9b30ff")
	else:
		enemy_color = Color("fd0043")
		modulate = Color("fd0043")
