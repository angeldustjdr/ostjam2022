extends KinematicBody2D

var health = 3
var speed = 0.5
var isMoving = false
var pixel_count = 0
var dir = 0
var is_dead = false

func _ready():
	self.get_node("MovingTimer").connect("timeout", self, "_move_random")
	self.get_node("Area2D").connect("area_entered", self,"_on_Pikes_area_entered")
	self.get_node("Area2D").connect("body_entered", self,"_on_Pikes_body_entered")
	self.get_node("DeathTimer").connect("timeout",self,"_death")

func _process(delta):
	if health<=0 && !is_dead:
		is_dead = true
		print(self.get_node("DeathTimer").get_time_left())
		self.get_node("AnimationTree").get("parameters/playback").travel("death")
		self.get_node("MovingTimer").stop()
		if(self.get_node("DeathTimer").is_stopped()):
			self.get_node("DeathTimer").start()
	elif !is_dead:
		if self.isMoving:
			if(self.pixel_count < 16):
				self._move()
				self.pixel_count += speed
			else:
				self.get_node("AnimationTree").get("parameters/playback").travel("idle")
				self.pixel_count = 0
				self.isMoving = false
				self.get_node("MovingTimer").start()

func _death():
	self.queue_free()

func _on_Pikes_area_entered(area):
	if area._type=="Bullet":
		health -= 1
		if health == 0:
			self.get_node("Robot1_sounds")._play_song_from_name_with_playback("death")
		else:
			self.get_node("Robot1_sounds")._play_song_from_name_with_playback("hurt")
		$HealthUI.updateHealthUI()

func _on_Pikes_body_entered(body):
	if !is_dead:
		var player = get_parent().get_node("Player")
		if body==player and !player.isDashing:
			player.takeDamage(1,self.position)

func _move_using_vector(delta_x,delta_y):
	self.move_and_collide(Vector2(delta_x,delta_y))

func _move():
	if self.dir == 0: #up
		self.move_and_collide(Vector2(0,self.speed))
	elif self.dir == 1: #down
		self.move_and_collide(Vector2(0,-self.speed))
	elif self.dir == 2: #left
		self.move_and_collide(Vector2(-self.speed,0))
	else: #right
		self.move_and_collide(Vector2(self.speed,0))

func _move_random():
	self.get_node("MovingTimer").stop()
	self.isMoving = true
	self.dir = randi()%4
	self.get_node("AnimationTree").get("parameters/playback").travel("walk")
