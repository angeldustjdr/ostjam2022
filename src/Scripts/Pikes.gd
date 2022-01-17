extends Area2D

var health = 5

func _process(delta):
	if health<=0:
		queue_free()

func _on_Pikes_area_entered(area):
	if area._type=="Bullet":
		health -= 1

func _on_Pikes_body_entered(body):
	var player = get_parent().get_node("Player")
	if body==player and !player.isDashing:
		player.takeDamage(1)
