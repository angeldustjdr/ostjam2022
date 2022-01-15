extends Sprite

export var fadeTime = 2

func _ready():
	$Tween.interpolate_property(self, "modulate:a", 1.0,0.0,fadeTime,3,1)
	$Tween.start()

func _on_FadeTimer_timeout():
	queue_free()
