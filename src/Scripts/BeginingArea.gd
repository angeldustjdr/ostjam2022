extends Area2D

onready var player = get_parent().get_node("Player")
onready var wave = get_parent().get_node("WaveManager")

func _on_BeginingArea_body_entered(body):
	if body==player:
		wave.currentWave = 0
		wave.alertMessage("Alert ! Intruder detected.\nInitiate elimination procedure.",5)
		player.get_node("PlayerDialog").speak("What now ?",3)
		queue_free()
