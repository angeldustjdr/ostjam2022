extends Node2D

export var keyboard = "qzsd"

func _ready():
	var music_manager = self.get_node("MusicManager")
	music_manager._change_music_volume(-7.0)
	music_manager._play_song_from_idx(0)
