extends Area2D

export var speed = 200
var _type="Bullet"
var direction = Vector2()

func _physics_process(delta):
	position += direction.normalized() * speed * delta
	
func _on_Timer_timeout():
	queue_free()

func _on_Bullet_area_entered(area):
	queue_free()
