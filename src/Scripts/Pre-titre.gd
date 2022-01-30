extends ColorRect

func _ready():
	Global.set_keyboard("qzsd")

func _input(event):
	if (event is InputEventKey):
		if event.pressed:
			Musics._stop()
			SoundManager._play_song_from_name("menu2")
			get_tree().change_scene("res://Scenes/Main.tscn")


