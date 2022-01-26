extends KinematicBody2D

onready var Bullet2 = preload("res://Scenes/Bullet2.tscn")
onready var collectibles = [preload("res://Scenes/Collectible_BulletSize.tscn"),
							preload("res://Scenes/Collectible_BulletSpeed.tscn"),
							preload("res://Scenes/Collectible_CadenceUp.tscn"),
							preload("res://Scenes/Collectible_DashSpeed.tscn"),
							preload("res://Scenes/Collectible_Health.tscn"),
							preload("res://Scenes/Collectible_MoveSpeed.tscn"),
							preload("res://Scenes/Collectible_Grenade.tscn")]
var droprate=0

export var health = 5
export var speed = 0.7
var isMoving = false
var pixel_count = 0
var dir = 0
var is_dead = false
var move_type = 2
var disp = PI/6
var nb_spray = 1

func _setDropRate(val):
	self.droprate = val

func _ready():
	self.get_node("RobotArea").connect("area_entered", self,"_on_Pikes_area_entered")
	self.get_node("RobotArea").connect("body_entered", self,"_on_Pikes_body_entered")
	self.get_node("DeathTimer").connect("timeout",self,"_death")

func _process(delta):
	if health<=0 && !is_dead:
		is_dead = true
		self.get_node("AnimationTree").get("parameters/playback").travel("DEATH")
		self.get_node("MovingTimer").stop()
		if(self.get_node("DeathTimer").is_stopped()):
			self.get_node("DeathTimer").start()
	elif !is_dead:
		if self.move_type>0:
			if self.move_type == 1:
				if self.isMoving:
					if(self.pixel_count < 16):
						self._move()
						self.pixel_count += speed
					else:
						self.get_node("AnimationTree").get("parameters/playback").travel("Idle")
						self.pixel_count = 0
						self.isMoving = false
						self.get_node("MovingTimer").start()
			elif self.move_type ==2:
				self.get_node("AnimationTree").get("parameters/playback").travel("Walk")
				dir = _move_towards_player()
				self.get_node("AnimationTree").set("parameters/Idle/blend_position",dir.normalized())
				self.get_node("AnimationTree").set("parameters/Walk/blend_position",dir.normalized())
			else:
				print("ERROR : error on move_type")
				get_tree().quit()

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

func _dont_shoot():
	pass

func _move_towards_player():
	var player_position = self.get_parent().get_node("Player").position
	var delta_x = float(self.position.x-player_position.x)
	var delta_y = float(self.position.y-player_position.y)
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	if (norm > 0):
		_move_using_vector((-delta_x*self.speed)/norm,(-delta_y*self.speed)/norm)
	return Vector2(-delta_x,-delta_y)
