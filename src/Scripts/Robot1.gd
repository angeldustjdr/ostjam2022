extends "res://Scripts/Robot_generique.gd"

func _ready():
	self.move_type = 1
	self.get_node("MovingTimer").connect("timeout", self, "_move_random")
