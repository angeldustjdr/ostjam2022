extends Node2D

export var keyboard = "qzsd"

func _ready():
	self.keyboard = Global.get_keyboard()
	self.get_node("Player").set_keyboard(self.keyboard)
	property_list_changed_notify()
	var music_manager = self.get_node("MusicManager")
	music_manager._change_music_volume(-7.0)
	music_manager._play_song_from_name("wait")
