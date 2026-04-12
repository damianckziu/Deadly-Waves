extends Node2D

func _ready():
	$NormalHighscore.text = str(Global.highscore)
	$NormalHighscore.add_theme_color_override("font_color", Color("ffd700"))
	$HardcoreHighscore.text = str(Global.highscore_hardcore)
	$HardcoreHighscore.add_theme_color_override("font_color", Color("ff0000"))
	animate_title()

func animate_title():
	var full_text = "DEADLY WAVES"
	$Label.text = ""
	$TypingSound.play()
	for i in range(full_text.length()):
		await get_tree().create_timer(0.2).timeout
		$Label.text += full_text[i]
	$TypingSound.stop()

func _on_normal_button_pressed():
	Global.hardcore = false
	get_tree().change_scene_to_file("res://arena.tscn")

func _on_hardcore_button_pressed():
	Global.hardcore = true
	get_tree().change_scene_to_file("res://arena.tscn")

func _on_reset_button_pressed():
	Global.highscore = 0
	Global.highscore_hardcore = 0
	Global.save_highscore()
	$NormalHighscore.text = "0"
	$HardcoreHighscore.text = "0"
