extends Node

var keyboard = "qzsd"
var run = 0
var timeEnd = 54876243

func getRun():
	return run

func getTimeEnd():
	return timeEnd

func incrRun():
	run += 1
	timeEnd += 1

func set_keyboard(val):
	self.keyboard = val
	
func get_keyboard():
	return self.keyboard
