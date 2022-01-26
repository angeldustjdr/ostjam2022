extends Node2D

func _ready():
	$Particles2D.emitting = true


func _on_Timer_timeout():
	queue_free()


func _on_Splatch_area_entered(area):
	if "Robot".is_subsequence_of(area.name):
		var robot = area.get_parent()
		robot.health -= 1
		robot.get_node("HealthUI").updateHealthUI()
	if "Bullet2".is_subsequence_of(area.name):
		area.queue_free()
