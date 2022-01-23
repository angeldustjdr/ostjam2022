extends ColorRect

onready var mySize = self.rect_size
onready var myTimer = get_parent().get_node("PowerUpTimer")

func _process(delta):
	if visible:
		self.rect_size = Vector2(mySize[0], mySize[1] *(myTimer.time_left / myTimer.wait_time))
	else:
		self.rect_size = mySize


func _on_PowerUpTimer_timeout():
	self.visible = false
	myTimer.stop()
