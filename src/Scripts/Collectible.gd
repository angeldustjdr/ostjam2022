extends Node2D

export(String, "Health", "DashSpeed", "BulletSize","BulletSpeed","MoveSpeed","CadenceUp") var thisCollectibleType
var _type = "Collectible"
onready var CollectibleLabel = preload("res://Scenes/CollectibleLabel.tscn")

func _on_Collectible_body_entered(body):
	var player = get_parent().get_node("Player")
	if body==player and !player.isDashing:
		player.applyCollectible(thisCollectibleType,$Particles2D.process_material.color)
		var c = CollectibleLabel.instance()
		match thisCollectibleType:
			"Health":
				c.text = "Health +1"
			"DashSpeed":
				c.text = "Dash Speed UP"
			"BulletSize":
				c.text = "Bullet Size +1"
			"BulletSpeed":
				c.text = "Bullet Speed UP"
			"MoveSpeed":
				c.text = "Movement Speed UP"
			"CadenceUp":
				c.text = "Fire rate UP"
		c.get_node("AnimationPlayer").play("Fade")
		get_parent().get_node("Player").add_child(c)
		queue_free()
