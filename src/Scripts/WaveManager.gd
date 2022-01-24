extends Node2D

onready var Oxy = get_global_transform_with_canvas().origin
onready var myOffset = OS.window_size/5.5

var currentWave = -1
export var timerTable = [30,60,60,60,60]

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _process(delta):
	position += Oxy - get_global_transform_with_canvas().origin - myOffset
	
	if currentWave >= 0:
		$Label.text = "Wave "+str(currentWave)+" - Next wave in "+str(round_to_dec($Timer.time_left,2))
		if $Timer.is_stopped():
			$Timer.start(timerTable[currentWave])


func _on_Timer_timeout():
	currentWave+=1
	$Timer.stop()
