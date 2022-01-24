extends Node2D

func _ready():
	$AnimationPlayer.play("flash")

func _on_Timer_timeout():
	queue_free()
