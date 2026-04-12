extends Node
var node_creation_parent = null
var player = null
var arena = null
var points = 0
var highscore = 0
var highscore_hardcore = 0
var current_wave = 0
var hp = 3
var hardcore = false
var enemies_killed = 0
var game_time = 0.0

func _ready():
	load_highscore()

func save_highscore():
	var file = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	file.store_32(highscore)
	file.close()
	var file2 = FileAccess.open("user://highscore_hardcore.dat", FileAccess.WRITE)
	file2.store_32(highscore_hardcore)
	file2.close()

func load_highscore():
	if FileAccess.file_exists("user://highscore.dat"):
		var file = FileAccess.open("user://highscore.dat", FileAccess.READ)
		highscore = file.get_32()
		file.close()
	if FileAccess.file_exists("user://highscore_hardcore.dat"):
		var file2 = FileAccess.open("user://highscore_hardcore.dat", FileAccess.READ)
		highscore_hardcore = file2.get_32()
		file2.close()

func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func get_time_string():
	var minutes = int(game_time) / 60
	var seconds = int(game_time) % 60
	return str(minutes) + ":" + ("0" if seconds < 10 else "") + str(seconds)
