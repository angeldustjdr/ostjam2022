extends Node2D

var phase = 1
var waitTimeLong = 3.0
var waitTimeShort = 1.0

func _ready():
	$AppearTimer.connect("timeout",self,"_on_appeartimer_timeout")
	$AppearTimer.wait_time = waitTimeShort
	$AppearTimer.start()
	Musics._play_song_from_name("ending")
	

#func _input(event):
#	if event is InputEventKey:
#		if event.pressed:
#			phase = 11

func _on_appeartimer_timeout():
	if phase == 13:
		get_tree().change_scene("res://Scenes/Credits.tscn")
	elif phase % 2 == 1:
		var label_to_appear = "l"+str((phase-1)/2+1)
		self.get_node(label_to_appear).set_appear(true)
		$AppearTimer.stop()
		$AppearTimer.wait_time = waitTimeLong
		$AppearTimer.start()
		phase += 1
	elif phase % 2 == 0:
		var label_to_fade = "l"+str(phase/2)
		self.get_node(label_to_fade).set_appear(false)
		self.get_node(label_to_fade).set_fade(true)
		$AppearTimer.stop()
		$AppearTimer.wait_time = waitTimeShort
		$AppearTimer.start()
		phase += 1
