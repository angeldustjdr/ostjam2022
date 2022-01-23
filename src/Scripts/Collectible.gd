extends Node2D

export(String, "Health", "DashSpeed", "BulletSize","BulletSpeed","MoveSpeed","CadenceUp") var thisCollectibleType
var _type = "Collectible"
onready var CollectibleLabel = preload("res://Scenes/CollectibleLabel.tscn")

func _ready():
	match thisCollectibleType:
			"Health":
				$Label.text = "Health +1"
				$Particles2D.process_material.color = Color("#19b0de")
			"DashSpeed":
				$Label.text = "Dash Speed UP"
				$Particles2D.process_material.color = Color("#decd19")
			"BulletSize":
				$Label.text = "Bullet Size +1"
				$Particles2D.process_material.color = Color("#ffffff")
			"BulletSpeed":
				$Label.text = "Bullet Speed UP"
				$Particles2D.process_material.color = Color("#d91a66")
			"MoveSpeed":
				$Label.text = "Movement Speed UP"
				$Particles2D.process_material.color = Color("#5ddc06")
			"CadenceUp":
				$Label.text = "Fire rate UP"
				$Particles2D.process_material.color = Color("#e81a1a")

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
