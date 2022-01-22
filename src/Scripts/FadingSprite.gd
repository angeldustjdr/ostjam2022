extends Sprite

export var fadeTime = 1
var PlayerSprite

func _ready():
	self.frame = PlayerSprite.frame
	self.frame_coords = PlayerSprite.frame_coords
	$Tween.interpolate_property(self, "modulate:a", 1.0,0.0,fadeTime,3,1)
	$Tween.start()

func _on_FadeTimer_timeout():
	queue_free()
