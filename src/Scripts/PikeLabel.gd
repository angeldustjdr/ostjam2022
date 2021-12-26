extends Label

onready var Pike = get_parent()

func _process(delta):
	self.text = "HP: " + str(Pike.health)
