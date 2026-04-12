extends Label
func _ready():
	if Global.hardcore:
		text = str(Global.highscore_hardcore)
		add_theme_color_override("font_color", Color("ff0000"))
	else:
		text = str(Global.highscore)
		add_theme_color_override("font_color", Color("ffd700"))

func _process(delta):
	if Global.hardcore:
		if Global.points > Global.highscore_hardcore:
			Global.highscore_hardcore = Global.points
			Global.save_highscore()
	else:
		if Global.points > Global.highscore:
			Global.highscore = Global.points
			Global.save_highscore()
