extends Node

# Declare member variables here. Examples:
var _n_songs
var _current_song_idx

# Called when the node enters the scene tree for the first time.
func _ready():
	self._n_songs = self.get_child_count()
	self._current_song_idx = 0
	#for i in self.get_children():
	#	i.connect("finished", self, "_play_next")

func _stop():
	self.get_child(self._current_song_idx).stop()

func _change_music_volume(db):
	for i in self.get_children():
		i.set_volume_db(db)

func _play_song_from_idx(idx):
	self.get_child(self._current_song_idx).stop()
	self.get_child(idx).play()
	self._current_song_idx = idx

func _play_song_from_name(name):
	if self.get_child(self._current_song_idx).is_playing():
		self.get_child(self._current_song_idx).stop()
	self.get_node(name).play()
	self._current_song_idx = self.get_node(name).get_index()

func _play_next():
	if self.get_child(self._current_song_idx).is_playing():
		self.get_child(self._current_song_idx).stop()
	if self._current_song_idx < self._n_songs-1:
		self._current_song_idx += 1
	else:
		self._current_song_idx = 0
	self.get_child(self._current_song_idx).play()

func _play_previous():
	if self.get_child(self._current_song_idx).is_playing():
		self.get_child(self._current_song_idx).stop()
	if self._current_song_idx > 0:
		self._current_song_idx -= 1
	else:
		self._current_song_idx = self._n_songs
	self.get_child(self._current_song_idx).play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
