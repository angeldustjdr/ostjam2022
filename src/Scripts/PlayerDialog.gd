extends Node2D

onready var opening = true
onready var ending = false
onready var line = 0
onready var player = get_parent()
var myDialog = ""

func _process(delta):
	var keyboard = player.keyboard
	var openingDialog = ["WTF happened?","Why am I still alive?","...I have a mission.","I gotta keep moving!","(wasd or qzsd to move)","(Left click to shoot)","(Space to dash)", "(Dashing damages the enemies upon landing)"]
	if opening and line<openingDialog.size():
		$Label.text = openingDialog[line]
	elif line==openingDialog.size():
		player.inputON = true
		opening = false
		line +=1
	
	if !opening and !ending:
		$Label.text = myDialog
		line = 0
	
	if ending:
		player.inputON = false
		var endingDialog = ["It's done...","I won...","They are all dead.","But I... feel weird."]
		if line<endingDialog.size():
			$Label.text = endingDialog[line]
		elif line==endingDialog.size():
			player.get_parent().get_node("WaveManager").currentWave += 1
			ending = false
		

func _input(event):
	if (event is InputEventKey) and (opening or ending):
		if event.pressed:
			line += 1

func speak(text,time):
	myDialog = text
	$Timer.wait_time = time
	$Timer.start()

func _on_Timer_timeout():
	myDialog = ""
	$Timer.stop()
