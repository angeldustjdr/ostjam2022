extends Node2D

var flash_speed = 3.0

func _ready():
	self.visible = false

func flash():
	self.visible = true
	$AnimationPlayer.play("fadein",-1,flash_speed,false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$AnimationPlayer.play("fadeout",-1,flash_speed,false)
	elif anim_name == "fadeout":
		self.visible = false 
