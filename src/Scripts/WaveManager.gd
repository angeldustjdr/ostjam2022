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

onready var Oxy = get_global_transform_with_canvas().origin
onready var myOffset = OS.window_size/5.5

var currentWave = -1
var timerTable = [30,30,60,90,120]
var populationDensity = [5,5,5,5,5]
var populationType = [	[50,0,0,0,0,0,0,0,0,0,50,0,0,0],
						[30,0,0,0,0,0,0,30,0,0,10,30,0,0],
						[10,0,0,10,0,0,30,10,10,0,10,10,10,0],
						[5,30,0,0,0,0,10,10,10,0,5,10,10,10],
						[0,20,30,0,30,0,0,5,5,0,0,0,5,5]]
var populateDeltaT = 5

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _process(delta):
	position += Oxy - get_global_transform_with_canvas().origin - myOffset
	
	if currentWave >= 0 and currentWave<5:
		$Label.text = "Wave "+str(currentWave)+" - Next wave in "+str(round_to_dec($Timer.time_left,2))
		if $Timer.is_stopped():
			if currentWave!=0 : player.get_node("PlayerDialog").speak("Another wave ?",3)
			$Timer.start(timerTable[currentWave])
			$PopulateTimer.start(populateDeltaT)
	else:
		$Label.text = ""


func _on_Timer_timeout():
	currentWave+=1
	$Timer.stop()
	randomize()
	var x = rand_range(0,1)
	var y = rand_range(0,1)
	var z = rand_range(0,1)
	fog.material.set_shader_param("color",Vector3(x,y,z))


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
