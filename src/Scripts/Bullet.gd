extends Area2D

export var speed = 150
var _type="Bullet"
var direction = Vector2()

func _physics_process(delta):
	position += direction.normalized() * speed * delta
	
func _on_Timer_timeout():
	queue_free()

func _on_Bullet_area_entered(area):
	if "Robot".is_subsequence_of(area.name):
		if !area.get_parent()._get_is_dead():
			queue_free()

func _on_Bullet_body_entered(body):
	if "Tile".is_subsequence_of(body.name):
		queue_free()
