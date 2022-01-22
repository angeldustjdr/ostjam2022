extends Node2D

onready var Parent = get_parent()
onready var HealthBlock = preload("res://Scenes/HealthBlock.tscn")
onready var HealhBlockWidth = 4
onready var intervale = 2

func _ready():
	updateHealthUI()
		

func updateHealthUI():
	for x in get_children() :
		x.queue_free()
	for i in range(Parent.health):
		var h = HealthBlock.instance()
		h.position = Vector2(i*(HealhBlockWidth+intervale) - Parent.health*(HealhBlockWidth+intervale)/2,0)
		add_child(h)
