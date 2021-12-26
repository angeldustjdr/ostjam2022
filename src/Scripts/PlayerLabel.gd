extends Label

onready var Player = get_parent()

func _process(delta):
	self.text = "HP: " + str(Player.health)
