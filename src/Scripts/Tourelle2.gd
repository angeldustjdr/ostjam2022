extends "res://Scripts/Tourelle_generique.gd"

func _ready():
	self.get_node("ShootTimer").connect("timeout",self,"_shoot_4")
