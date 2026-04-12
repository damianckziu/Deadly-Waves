extends Node
var node_creation_parent = null
var player = null
var arena = null
var points = 0
var highscore = 0
var current_wave = 0
var hp = 3

func _ready():
	load_highscore()

func save_highscore():
	var file = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	file.store_32(highscore)
	file.close()

func load_highscore():
	if FileAccess.file_exists("user://highscore.dat"):
		var file = FileAccess.open("user://highscore.dat", FileAccess.READ)
		highscore = file.get_32()
		file.close()

func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
