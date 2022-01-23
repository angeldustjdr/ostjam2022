extends "res://Scripts/Robot2.gd"

onready var Bullet2 = preload("res://Scenes/Bullet2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("ShootTimer").connect("timeout",self,"_shoot")

func _shoot():
	if !self.is_dead:
		var player_position = self.get_parent().get_node("Player").position
		var b = Bullet2.instance()
		self.get_node("Robot1_sounds")._play_song_from_name_with_playback("shoot")
		b.direction = Vector2(player_position.x-self.position.x,player_position.y-self.position.y)
		get_parent().add_child(b)
		b.transform = self.global_transform
		#b.rotation = self.position.angle_to_point(b.direction)

#func _process(delta):# Called every frame. 'delta' is the elapsed time since the previous frame.
#	pass
