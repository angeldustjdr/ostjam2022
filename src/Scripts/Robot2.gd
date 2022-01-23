extends "res://Scripts/Robot1.gd"

func _ready():
	self.speed=1.0

func _process(delta):
	if health<=0 && !is_dead:
		is_dead = true
		print(self.get_node("DeathTimer").get_time_left())
		self.get_node("AnimationTree").get("parameters/playback").travel("death")
		self.get_node("MovingTimer").stop()
		if(self.get_node("DeathTimer").is_stopped()):
			self.get_node("DeathTimer").start()
	elif !is_dead:
		self.get_node("AnimationTree").get("parameters/playback").travel("walk")
		_move_towards_player()

func _move_towards_player():
	var player_position = self.get_parent().get_node("Player").position
	var delta_x = float(self.position.x-player_position.x)
	var delta_y = float(self.position.y-player_position.y)
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	if (norm > 0):
		_move_using_vector((-delta_x*self.speed)/norm,(-delta_y*self.speed)/norm)

func _move():
	pass

func _move_random():
	pass
