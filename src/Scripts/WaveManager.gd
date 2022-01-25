extends Node2D

onready var robot1 = preload("res://Scenes/Robot1.tscn")
onready var robot2 = preload("res://Scenes/Robot2.tscn")
onready var robot3 = preload("res://Scenes/Robot3.tscn")
onready var main = get_parent()
onready var player = main.get_node("Player")

onready var Oxy = get_global_transform_with_canvas().origin
onready var myOffset = OS.window_size/5.5

var currentWave = -1
var timerTable = [10,10,10,10,10]
var populationDensity = [1,2,2,3,5]
var populationType = [[100,0,0],[50,100,0],[20,60,100],[0,50,100],[0,0,100]]
var populateDeltaT = 1

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


func _on_PopulateTimer_timeout():
	if currentWave<5:
		populate()

func populate():
	randomize()
	for n in range(populationDensity[currentWave]):
		var dice = rand_range(0,100)
		var r
		if dice < populationType[currentWave][0]:
			r = robot1.instance()
		elif dice < populationType[currentWave][1]:
			r = robot2.instance()
		else:
			r = robot3.instance()
		var distance = rand_range(150,200)
		var angle = rand_range(0,2*PI)
		r.position = player.position + Vector2.ONE.rotated(angle)*distance
		main.add_child(r)

func populate_one():
	var r=robot2.instance()
	randomize()
	var distance = rand_range(150,200)
	var angle = rand_range(0,2*PI)
	r.position = player.position + Vector2.ONE.rotated(angle)*distance
	main.call_deferred("add_child",r)
