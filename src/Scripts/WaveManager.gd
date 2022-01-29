extends Node2D

onready var main = get_parent()
onready var player = main.get_node("Player")
onready var fog = main.get_node("Fog").get_node("FogShader")

onready var enemies = [ preload("res://Scenes/Robot1.tscn"),
						preload("res://Scenes/Robot2.tscn"),
						preload("res://Scenes/Robot3.tscn"),
						preload("res://Scenes/Robot4.tscn"),
						preload("res://Scenes/Robot5.tscn"),
						preload("res://Scenes/Robot6.tscn"),
						preload("res://Scenes/Robot7.tscn"),
						preload("res://Scenes/Robot8.tscn"),
						preload("res://Scenes/Robot9.tscn"),
						preload("res://Scenes/Robot10.tscn"),
						preload("res://Scenes/Tourelle1.tscn"),
						preload("res://Scenes/Tourelle2.tscn"),
						preload("res://Scenes/Tourelle3.tscn"),
						preload("res://Scenes/Tourelle4.tscn")]
onready var DarkMC = preload("res://Scenes/Dark_MC1.tscn")

onready var Oxy = get_global_transform_with_canvas().origin
onready var myOffset = OS.window_size/5.5

var currentWave = -1
var timerTable = [30,30,30,40,60]
#var timerTable = [1,1,1,1,1]
var populationDensity = [4,4,4,4,4]
var waveColor = [Vector3(0.4,0.8,0.9),Vector3(0.4,0.8,0.6),Vector3(0.7,0.9,0.4),Vector3(1.0,0.7,0.2),Vector3(1.0,0.2,0.2)]
var populationType = [	[50,0,0,0,0,0,0,0,0,0,50,0,0,0],
						[10,60,10,10,0,0,0,0,0,0,5,0,0,5],
						[10,50,20,10,0,0,0,0,0,0,0,10,0,0],
						[10,50,25,5,0,0,10,10,0,0,0,0,10,0],
						[10,40,30,15,15,15,0,0,5,0,0,0,0,0]]
var populateDeltaT = 5
var nbDMC = 10
#var nbDMC = 1
var DMC_remain = 0

var firstTimeWave0 = false
var firstTimeWave6 = true

func setFTW0(val):
	self.firstTimeWave0 = val
func setFTW6(val):
	self.firstTimeWave6 = val
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _process(delta):
	position += Oxy - get_global_transform_with_canvas().origin - myOffset
	
	if currentWave >= 0 and currentWave<5:
		if self.firstTimeWave0 && currentWave == 0:
			self.get_parent().get_node("MusicManager")._play_song_from_name("wave")
			firstTimeWave0 = false
		$Label.text = "Wave "+str(currentWave+1)+" - Next wave in "+str(round_to_dec($Timer.time_left,2))
		if $Timer.is_stopped():
			var dialogOnNextWave = ["What?","How...?","Another wave?","Just a little more time...","Almost there!"]
			player.get_node("PlayerDialog").speak(dialogOnNextWave[currentWave],3)
			var alertDialog = ["More units","Exterminate!","Destroy!","Why don't you die?\nYou're just an anomaly!"]
			if currentWave > 0 : alertMessage(alertDialog[currentWave-1],5)
			$Timer.start(timerTable[currentWave])
			$PopulateTimer.start(populateDeltaT)
		fog.material.set_shader_param("color",self.waveColor[self.currentWave])
	elif(currentWave==5):
		$Label.text = "Wave ***ERROR***"
		if $Timer.is_stopped():
			self.get_parent().get_node("Flash").flash()
			for n in get_tree().get_nodes_in_group("Enemy"):
				n.health -= 5
				n.get_node("HealthUI").updateHealthUI()
			for n in get_tree().get_nodes_in_group("Collectible"):
				n.queue_free()
			for n in get_tree().get_nodes_in_group("Bullet"):
				n.queue_free()
			player.get_node("PlayerDialog").speak("What now ?",3)
			alertMessage("He has used his deadly weapon!\nDESTROY HIM NOW!",4.9)
			$Timer.start(4.9)
	elif(currentWave==6):
		$Label.text = "Wave ***ERROR***"
		#alertMessage("He has used his deadly weapon!\nDestroy him NOW!",5)
		player.get_node("PlayerDialog").speak("Oh Shit",3)
		for i in range(nbDMC):
			populate_DMC()
		if self.firstTimeWave6:
			self.get_parent().get_node("MusicManager")._play_song_from_name("lastwave")
			firstTimeWave6 = false
		DMC_remain = nbDMC
		currentWave += 1		
	elif(currentWave==7):
		$Label.text = "Wave ***ERROR***"
		if DMC_remain<=0 :
			if $Timer.is_stopped():
				alertMessage("You did more damage than usual.\nBut it is too late...",5)
				player.get_node("PlayerDialog").speak("It's over?",5)
				$Timer.start(5)
	elif(currentWave==8):
		get_tree().change_scene("res://Scenes/Credits.tscn")
	else:
		$Label.text = ""


func _on_Timer_timeout():
	currentWave+=1
	if currentWave < 6:
		self.get_node("SoundManager")._play_song_from_name("honk",1.2)
	$Timer.stop()


func _on_PopulateTimer_timeout():
	if currentWave<5:
		populate()

func populate():
	randomize()
	var enemyToPop = []
	var i = 0
	for n in populationType[currentWave]:
		for m in range(n):
			enemyToPop.append(enemies[i])
		i += 1
	for n in range(populationDensity[currentWave]):
		enemyToPop.shuffle()
		var r = enemyToPop[0].instance()
		var distance = rand_range(150,200)
		var angle = rand_range(0,2*PI)
		r.position = player.position + Vector2.ONE.rotated(angle)*distance
		main.add_child(r)

func populate_one():
	var r=enemies[1].instance()
	randomize()
	var distance = rand_range(150,200)
	var angle = rand_range(0,2*PI)
	r.position = player.position + Vector2.ONE.rotated(angle)*distance
	main.call_deferred("add_child",r)

func populate_DMC():
	var r=DarkMC.instance()
	randomize()
	var distance = rand_range(150,200)
	var angle = rand_range(0,2*PI)
	r.position = player.position + Vector2.ONE.rotated(angle)*distance
	main.call_deferred("add_child",r)

func alertMessage(text,time):
	$AlertLabel.text = text
	$AlertLabel/AlertTimer.wait_time=time
	$AlertLabel/AlertTimer.start()
	
func _on_AlertTimer_timeout():
	$AlertLabel/AlertTimer.stop()
	$AlertLabel.text=""
