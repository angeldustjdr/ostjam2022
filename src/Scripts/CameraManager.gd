extends Camera2D

onready var player=get_parent().get_node("Player")
export var screen_height = OS.window_size.y
export var screen_width = OS.window_size.x

func _process(delta):
	self.position = player.global_position
	var mouse_pos = get_global_mouse_position()
	self.offset_h = (mouse_pos.x - self.global_position.x) / (screen_height/2)
	self.offset_v = (mouse_pos.y - self.global_position.y) / (screen_width/2)
