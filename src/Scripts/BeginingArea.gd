extends Area2D

onready var player = get_parent().get_node("Player")
onready var wave = get_parent().get_node("WaveManager")

var first_time = true

func _on_BeginingArea_body_entered(body):
	if body==player:
		wave.currentWave = 0
		wave.alertMessage("Alert ! Intruder detected.\nInitiate elimination procedure.",5)
		player.get_node("PlayerDialog").speak("What now ?",3)
		if first_time:
			self.get_parent().get_node("MusicManager")._play_song_from_name("wave")
			self.get_parent().get_node("WaveManager").get_node("SoundManager")._play_song_from_name("honk",1.2)
			first_time = false
		queue_free()
