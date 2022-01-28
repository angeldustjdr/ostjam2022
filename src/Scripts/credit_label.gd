extends Label

var appear = false
var appear_speed = 1.0
var fade = false
var fade_speed = 1.0

func _ready():
	self.modulate.a = 0.0

func _process(delta):
	if self.appear and !self.fade and self.modulate.a <= 1.0:
		self.modulate.a += self.appear_speed*delta
	elif self.fade and !self.appear and self.modulate.a >= 0.0:
		self.modulate.a -= self.appear_speed*delta
	elif self.fade and self.appear:
		print("WARNING: credit_label.gd missuse")

func set_appear(val):
	self.appear = val

func set_fade(val):
	self.fade = val
