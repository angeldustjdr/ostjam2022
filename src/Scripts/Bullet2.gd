extends "res://Scripts/Bullet.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self._type = "Bullet2"

func _on_Bullet_area_entered(area):
	print(area.name)
	if "Player".is_subsequence_of(area.name):
		self.get_parent().get_node("Player").takeDamage(1,self.position)
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
