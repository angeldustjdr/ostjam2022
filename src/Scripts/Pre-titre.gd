extends ColorRect

func _on_ButtonWASD_mouse_entered():
	SoundManager._play_song_from_name("menu1")
	
func _on_ButtonQZSD_mouse_entered():
	SoundManager._play_song_from_name("menu1")	

func _on_ButtonWASD_pressed():
	Global.set_keyboard("wasd")
	SoundManager._play_song_from_name("menu2")
	get_tree().change_scene("res://Scenes/Titre.tscn")

func _on_ButtonQZSD_pressed():
	Global.set_keyboard("qzsd")
	SoundManager._play_song_from_name("menu2")
	get_tree().change_scene("res://Scenes/Titre.tscn")


