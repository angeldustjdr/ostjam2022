extends Node2D

onready var Oxy = get_global_transform_with_canvas().origin
onready var myOffset = OS.window_size/5.5

func _process(delta):
	position += Oxy - get_global_transform_with_canvas().origin - myOffset
