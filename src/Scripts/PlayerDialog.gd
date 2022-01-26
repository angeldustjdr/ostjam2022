extends Node2D

onready var opening = true
onready var line = 0
onready var player = get_parent()
var myDialog = ""

func _process(delta):
	var keyboard = player.keyboard
	var openingDialog = ["WTF happened ?","Why am I still alive ?","I gotta find out.","I gotta keep moving !","("+keyboard+" to move)","(Left click to shoot)","(Space to dash - damages the enemy on landing)"]
	if opening and line<openingDialog.size():
		$Label.text = openingDialog[line]
	elif line==openingDialog.size():
		player.inputON = true
		opening = false
		line +=1
	
	if !opening:
		$Label.text = myDialog

func _input(event):
	if event is InputEventKey and opening:
		if event.pressed:
			line += 1

func speak(text,time):
	myDialog = text
	$Timer.wait_time = time
	$Timer.start()

func _on_Timer_timeout():
	myDialog = ""
	$Timer.stop()
