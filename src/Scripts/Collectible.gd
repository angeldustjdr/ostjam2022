extends Node2D

export(String, "Health", "DashSpeed", "BulletSize","BulletSpeed","MoveSpeed","CadenceUp","Grenade") var thisCollectibleType
var _type = "Collectible"
onready var CollectibleLabel = preload("res://Scenes/CollectibleLabel.tscn")
var time = 0

func _ready():
	match thisCollectibleType:
			"Health":
				$Label.text = "Health +1"
			"DashSpeed":
				$Label.text = "Dash Speed UP"
			"BulletSize":
				$Label.text = "Bullet Size +1"
			"BulletSpeed":
				$Label.text = "Bullet Speed UP"
			"MoveSpeed":
				$Label.text = "Movement Speed UP"
			"CadenceUp":
				$Label.text = "Fire rate UP"
			"Grenade":
				$Label.text = "BOOM"

func _process(delta):
	time += delta
	self.position += Vector2(0,0.1*sin(3*time))

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
			"Grenade":
				c.text = "KABOOM"
		c.get_node("AnimationPlayer").play("Fade")
		get_parent().get_node("Player").add_child(c)
		queue_free()
