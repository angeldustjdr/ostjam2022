extends Camera2D

onready var player=get_parent().get_node("Player")
export var screen_height = OS.window_size.y
export var screen_width = OS.window_size.x

var shake = 0.0
var time = 0.0
var time_scale = 150
var decay = 0.6
var max_x = 150
var max_y = 150
var max_r = 25
var noise = OpenSimplexNoise.new()

func addShake(value):
	shake = clamp(shake + value, 0, 1)

func _process(delta):
	self.position = player.global_position
	var mouse_pos = get_global_mouse_position()
	self.offset_h = (mouse_pos.x - self.global_position.x) / (screen_height/2)
	self.offset_v = (mouse_pos.y - self.global_position.y) / (screen_width/2)
	
	time += delta
	self.offset_h += noise.get_noise_3d(time * time_scale, 0, 0) * max_x * pow(shake,2)
	self.offset_v += noise.get_noise_3d(0, time * time_scale, 0) * max_y * pow(shake,2)
	
	if shake > 0: shake = clamp(shake - (delta * decay), 0, 1)
