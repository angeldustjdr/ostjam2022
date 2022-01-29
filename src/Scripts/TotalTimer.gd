extends Timer

func _ready():
	var timers = get_parent().timerTable
	var totalTimer = 0.0
	for t in timers:
		totalTimer += t
	self.wait_time = totalTimer
