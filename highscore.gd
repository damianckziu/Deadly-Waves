extends Label
func _ready():
	text = str(Global.highscore)
func _process(delta):
	if Global.points > Global.highscore:
		Global.highscore = Global.points
		Global.save_highscore()
