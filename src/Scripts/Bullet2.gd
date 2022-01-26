extends "res://Scripts/Bullet.gd"

onready var player = get_parent().get_node("Player")

func _ready():
	self._type = "Bullet2"

func _on_Bullet_area_entered(area):
	if "Player".is_subsequence_of(area.name):
		if !player.isDashing:
			player.takeDamage(1,self.position)
			queue_free()
	elif "Bullet".is_subsequence_of(area.name):
		if area._type == "Bullet":
			queue_free()
