extends "res://Scripts/Robot_generique.gd"

func _ready():
	self.move_type = 1
	self.get_node("MovingTimer").connect("timeout", self, "_move_random")
	self.nb_spray = 1
	self.disp = PI/12
	self.get_node("ShootTimer").connect("timeout",self,"_shoot_spray")
