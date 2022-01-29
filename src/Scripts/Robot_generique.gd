extends KinematicBody2D

onready var Bullet2 = preload("res://Scenes/Bullet2.tscn")
onready var collectiblesPrimary = [preload("res://Scenes/Collectible_BulletSize.tscn"),
							preload("res://Scenes/Collectible_BulletSpeed.tscn"),
							preload("res://Scenes/Collectible_CadenceUp.tscn"),
							preload("res://Scenes/Collectible_Health.tscn"),
							preload("res://Scenes/Collectible_MoveSpeed.tscn"),
							preload("res://Scenes/Collectible_Grenade.tscn")]
var collectibleRate = [10,10,20,20,10,10]
var collectibles = []
var droprate=30

export var health = 3
export var speed = 0.5
var isMoving = false
var pixel_count = 0
var dir = 0
var is_dead = false
var move_type = 0
var disp = PI/6
var nb_spray = 1

var tshoot_min=0.5
var tshoot_max=2.0

var knock_back_speed = 200
onready var velocity = Vector2.ZERO
export var friction = 0.1

var isHit = false

var count = true

func _setCount(val):
	self.count = val

func _setDropRate(val):
	self.droprate = val

func _ready():
	for n in range(6):
		for i in range(collectibleRate[n]):
			collectibles.append(collectiblesPrimary[n])
	self.get_node("RobotArea").connect("area_entered", self,"_on_Pikes_area_entered")
	self.get_node("RobotArea").connect("body_entered", self,"_on_Pikes_body_entered")
	self.get_node("DeathTimer").connect("timeout",self,"_death")
	randomize()
	#$DeathTimer.wait_time += rand_range(0.0,1.0)
	$ShootTimer.wait_time = rand_range(tshoot_min,tshoot_max)

func _process(delta):
	if health<=0 && !is_dead:
		is_dead = true
		self.get_node("AnimationTree").get("parameters/playback").travel("death")
		self.get_node("MovingTimer").stop()
		if(self.get_node("DeathTimer").is_stopped()):
			self.get_node("DeathTimer").start()
	elif !is_dead:
		if self.move_type>0:
			if !isHit:
				if self.move_type == 1:
					if self.isMoving:
						if(self.pixel_count < 16):
							self._move()
							self.pixel_count += speed
						else:
							self.get_node("AnimationTree").get("parameters/playback").travel("idle")
							self.pixel_count = 0
							self.isMoving = false
							self.get_node("MovingTimer").start()
				elif self.move_type ==2:
					self.get_node("AnimationTree").get("parameters/playback").travel("walk")
					_move_towards_player()
				else:
					print("ERROR : error on move_type")
					get_tree().quit()
			else:
				velocity = lerp(velocity, Vector2.ZERO, friction)
				move_and_slide(velocity)
	elif is_dead:		
		velocity = lerp(velocity, Vector2.ZERO, friction)
		move_and_slide(velocity)
				

func _knockback(pos):
	var delta_x = self.position.x - pos.x
	var delta_y = self.position.y - pos.y
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	velocity = Vector2(self.knock_back_speed*delta_x/norm,self.knock_back_speed*delta_y/norm)

func _get_is_dead():
	return self.is_dead

func _death():
	randomize()
	var dropDice = rand_range(0,100)
	if dropDice<droprate:
		collectibles.shuffle()
		var c=collectibles[0].instance()
		c.position = self.position
		get_parent().add_child(c)
	self.queue_free()

func _on_Pikes_area_entered(area):
	if !self.is_dead:
		if "Bullet".is_subsequence_of(area.name):
			if area._type=="Bullet":
				health -= 1
				isHit = true
				$RecoveryTimer.start()
				self._knockback(area.position)
				$Sprite.material.set_shader_param("whiten",true)
				yield(get_tree().create_timer(0.1),"timeout")
				$Sprite.material.set_shader_param("whiten",false)
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
	
func _shoot():
	if !self.is_dead:
		var player_position = self.get_parent().get_node("Player").position
		var b = Bullet2.instance()
		self.get_node("Robot1_sounds")._play_song_from_name_with_playback("shoot")
		b.direction = Vector2(player_position.x-self.position.x,player_position.y-self.position.y)
		get_parent().add_child(b)
		b.transform = self.global_transform
	$ShootTimer.wait_time = rand_range(tshoot_min,tshoot_max)
		#b.rotation = self.position.angle_to_point(b.direction)
		
func _shoot_4():
	if !self.is_dead:
		self.get_node("Robot1_sounds")._play_song_from_name_with_playback("shoot")
		for i in range(0,4):
			var b = Bullet2.instance()
			if i == 0: #up
				b.direction = Vector2(0,1)
			elif i == 1: #down
				b.direction = Vector2(0,-1)
			elif i == 2: #left
				b.direction = Vector2(-1,0)
			elif i == 3:#right
				b.direction = Vector2(1,0)
			else:
				print("ERROR in Robot_generique::_shoot_4")
				get_tree().quit()
			get_parent().add_child(b)
			b.transform = self.global_transform
	$ShootTimer.wait_time = rand_range(tshoot_min,tshoot_max)
			
func _shoot_8():
	if !self.is_dead:
		self.get_node("Robot1_sounds")._play_song_from_name_with_playback("shoot")
		for i in range(0,8):
			var b = Bullet2.instance()
			var norm = 0.5*sqrt(2)
			if i == 0: #up
				b.direction = Vector2(0,1)
			elif i == 1: #down
				b.direction = Vector2(0,-1)
			elif i == 2: #left
				b.direction = Vector2(-1,0)
			elif i == 3:#right
				b.direction = Vector2(1,0)
			elif i == 4: #up-left
				b.direction = Vector2(-norm,norm)
			elif i == 5: #up-right
				b.direction = Vector2(norm,norm)
			elif i == 6: #down-left
				b.direction = Vector2(-norm,-norm)
			elif i == 7:#down-right
				b.direction = Vector2(norm,-norm)
			else:
				print("ERROR in Robot_generique::_shoot_8")
				get_tree().quit()
			get_parent().add_child(b)
			b.transform = self.global_transform
	$ShootTimer.wait_time = rand_range(tshoot_min,tshoot_max)

func _shoot_spray():
	if !self.is_dead:
		var player_position = self.get_parent().get_node("Player").position
		var b = Bullet2.instance()
		self.get_node("Robot1_sounds")._play_song_from_name_with_playback("shoot")
		var dir = Vector2(player_position.x-self.position.x,player_position.y-self.position.y)
		b.direction = dir
		get_parent().add_child(b)
		b.transform = self.global_transform
		for i in range(0,self.nb_spray):
			b = Bullet2.instance()
			b.direction = dir.rotated((i+1)*disp)
			get_parent().add_child(b)
			b.transform = self.global_transform
			b = Bullet2.instance()
			b.direction = dir.rotated(-(i+1)*disp)
			get_parent().add_child(b)
			b.transform = self.global_transform
	$ShootTimer.wait_time = rand_range(tshoot_min,tshoot_max)

func _dont_shoot():
	pass

func _move_towards_player():
	var player_position = self.get_parent().get_node("Player").position
	var delta_x = float(self.position.x-player_position.x)
	var delta_y = float(self.position.y-player_position.y)
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	if (norm > 0):
		_move_using_vector((-delta_x*self.speed)/norm,(-delta_y*self.speed)/norm)

func _on_RecoveryTimer_timeout():
	isHit = false
