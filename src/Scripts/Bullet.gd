extends Area2D

export var speed = 200
var _type="Bullet"

func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_Timer_timeout():
	queue_free()
