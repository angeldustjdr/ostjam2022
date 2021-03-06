extends Node2D

var phase = 0
var waitTimeLong = 5.0
var waitTimeShort = 1.0

func _ready():
	$AppearTimer.connect("timeout",self,"_on_appeartimer_timeout")
	$AppearTimer.start()
	

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			phase = 11

func _on_appeartimer_timeout():
	if phase == 0:
		$theloop.set_appear(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 1:
		$credits.set_appear(true)
		$AppearTimer.wait_time = waitTimeShort
		phase += 1
	elif phase == 2:
		$theloop.set_appear(false)
		$theloop.set_fade(true)
		$credits.set_appear(false)
		$credits.set_fade(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 3:
		$credits_music.set_appear(true)
		$AppearTimer.wait_time = waitTimeShort
		phase += 1
	elif phase == 4:
		$credits_music.set_appear(false)
		$credits_music.set_fade(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 5:
		$credits_sounds.set_appear(true)
		$AppearTimer.wait_time = waitTimeShort
		phase += 1
	elif phase == 6:
		$credits_sounds.set_appear(false)
		$credits_sounds.set_fade(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 7:
		$credits_other.set_appear(true)
		$AppearTimer.wait_time = waitTimeShort
		phase += 1
	elif phase == 8:
		$credits_other.set_appear(false)
		$credits_other.set_fade(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 9:
		$thanksforplaying.set_appear(true)
		$AppearTimer.wait_time = waitTimeShort
		phase += 1
	elif phase == 10:
		$thanksforplaying.set_appear(false)
		$thanksforplaying.set_fade(true)
		$AppearTimer.wait_time = waitTimeLong
		phase += 1
	elif phase == 11:
		Musics._stop()
		Global.incrRun()
		get_tree().change_scene("res://Scenes/Titre.tscn")
