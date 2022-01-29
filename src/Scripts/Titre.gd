extends Node2D

var keyboard = "wasd"
func _ready():
	Global.set_keyboard(keyboard)
	self.get_node("MusicManager")._play_song_from_name("43-loop-unfinished")

func _process(delta):
	if Input.is_action_just_pressed("space_switch"):
		if keyboard=="qzsd":
			self.keyboard = "wasd"
			Global.set_keyboard(keyboard)
			self.get_node("Label3").text="WASD"
		else:
			self.keyboard = "qzsd"
			Global.set_keyboard(keyboard)
			self.get_node("Label3").text="QZSD"
	if Input.is_action_just_pressed("enter_begin"):
		get_tree().change_scene("res://Scenes/Main.tscn")
