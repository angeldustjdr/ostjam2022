extends KinematicBody2D

var health = 3
var speed = 1
var isMoving = false
var pixel_count = 0
var dir = 0

func _ready():
	self.get_node("MovingTimer").connect("timeout", self, "_move_random")
	self.get_node("Area2D").connect("area_entered", self,"_on_Pikes_area_entered")
	self.get_node("Area2D").connect("body_entered", self,"_on_Pikes_body_entered")

func _process(delta):
	if health<=0:
		queue_free()
	if self.isMoving:
		if(self.pixel_count < 16):
			self._move()
			self.pixel_count += speed
		else:
			self.pixel_count = 0
			self.isMoving = false
			self.get_node("MovingTimer").start()

func _on_Pikes_area_entered(area):
	if area._type=="Bullet":
		health -= 1
		$HealthUI.updateHealthUI()

func _on_Pikes_body_entered(body):
	var player = get_parent().get_node("Player")
	if body==player and !player.isDashing:
		player.takeDamage(1)

func _move_using_vector(delta_x,delta_y):
	self.position.x += self.speed*delta_x
	self.position.y += self.speed*delta_y

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
