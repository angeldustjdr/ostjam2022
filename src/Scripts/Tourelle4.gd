extends "res://Scripts/Tourelle_generique.gd"

func _ready():
	self.nb_spray = 1
	self.disp = PI/12
	self.get_node("ShootTimer").connect("timeout",self,"_shoot_spray")
