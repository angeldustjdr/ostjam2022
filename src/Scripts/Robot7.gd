extends "res://Scripts/Robot_generique.gd"

func _ready():
	self.move_type = 2
	self.nb_spray = 1
	self.disp = PI/12
	self.get_node("ShootTimer").connect("timeout",self,"_shoot_spray")
