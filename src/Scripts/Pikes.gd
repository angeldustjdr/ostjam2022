extends Area2D

var health = 5

func knockback(player):
	player.inputON = false
	var RecoveryTimer = player.get_node("RecoveryTimer")
	RecoveryTimer.start()
	player.velocity = player.velocity.rotated(PI)

func _process(delta):
	if health<=0:
		queue_free()


func _on_Pikes_area_entered(area):
	if area._type=="Bullet":
		health -= 1


func _on_Pikes_body_entered(body):
	var player = get_parent().get_node("Player")
	if body==player:
		# knock back
		knockback(player)
		# damage
		player.health -=1
