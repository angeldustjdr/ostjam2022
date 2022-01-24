extends Area2D

onready var player = get_parent().get_node("Player")
onready var wave = get_parent().get_node("WaveManager")
onready var alert = preload("res://Scenes/Alert.tscn")

func _on_BeginingArea_body_entered(body):
	if body==player:
		wave.currentWave = 0
		var a = alert.instance()
		player.add_child(a)
		player.get_node("PlayerDialog").speak("What now ?",3)
		queue_free()
