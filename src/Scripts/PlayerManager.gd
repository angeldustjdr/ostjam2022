extends KinematicBody2D

export var health = 5

export var speed = 175
export var friction = 0.5
export var acceleration = 0.7
export var cadence = 0.2
export var dashVelocity = 200

export var dashlength_PowerUp = 0.3
var nbDashPowerUp = 0
onready var dashTimer0 = $DashTimer.wait_time
export var bulletSize_PowerUp = 0.4
var nbBulletPowerUp = 0
export var bulletSpeed_PowerUp = 50
export var bulletSpeed0 = 150
var nbBulletSpeedPowerUp = 0
export var speedPowerUp = 75
var nbSpeedPowerUp = 0
export var cadencePowerUp = 0.05
var nbCadencePowerUp = 0

onready var velocity = Vector2.ZERO
onready var keyboard = get_parent().keyboard

onready var Bullet = preload("res://Scenes/Bullet.tscn")
onready var FadingSprite = preload("res://Scenes/FadingSprite.tscn")
onready var particles = preload("res://Scenes/Particles2D.tscn")
onready var shockwave = preload("res://Scenes/ShockWave.tscn")
onready var footstep = preload("res://Scenes/Footstep.tscn")
onready var splatch = preload("res://Scenes/Splatch.tscn")

onready var inputON = false
onready var isDashing = false
onready var canDash = true

func set_keyboard(val):
	self.keyboard = val

func get_input():
	var input = Vector2()
	if Input.is_action_pressed("right_"+keyboard):
		input.x += 1
	if Input.is_action_pressed("left_"+keyboard):
		input.x -= 1
	if Input.is_action_pressed("down_"+keyboard):
		input.y += 1
	if Input.is_action_pressed("up_"+keyboard):
		input.y -= 1
	return input
	
func shoot():
	if $Cadence.is_stopped() and inputON:
		var myCadence = cadence - nbCadencePowerUp*cadencePowerUp
		if myCadence < 0.1:
			myCadence = 0.1
		$Cadence.wait_time = myCadence
		$Cadence.start()
		var b = Bullet.instance()
		self.get_node("Player_sounds")._play_song_from_name_with_playback("shoot")
		b.direction = get_local_mouse_position()
		get_parent().add_child(b)
		b.transform = self.global_transform
		b.rotation = self.position.angle_to_point(b.get_global_mouse_position())
		b.scale = Vector2(1+nbBulletPowerUp*bulletSize_PowerUp,1+nbBulletPowerUp*bulletSize_PowerUp)
		b.speed = bulletSpeed0 + nbBulletSpeedPowerUp*bulletSpeed_PowerUp
	

func _physics_process(delta):
	# Deplacement
	if inputON:
		var direction = get_input()
		var mySpeed = speed + nbSpeedPowerUp*speedPowerUp
		if direction.length() > 0:
			velocity = lerp(velocity, direction.normalized() * mySpeed, acceleration)
			$AnimationTree.get("parameters/playback").travel("Walk")
			if $FootstepTimer.is_stopped():
				var f = footstep.instance()
				f.position = self.position + Vector2(0,7)
				get_parent().add_child(f)
				$FootstepTimer.start()
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
			$AnimationTree.get("parameters/playback").travel("Idle")
		$AnimationTree.set("parameters/Idle/blend_position",get_local_mouse_position().normalized())
		$AnimationTree.set("parameters/Walk/blend_position",get_local_mouse_position().normalized())
	
	#Shoot
		if Input.is_action_pressed("ui_mouseleft"):
			shoot()
	
	#Dash
		if Input.is_action_pressed("ui_select"):
			if !isDashing and canDash:
				dash(dashVelocity)
	
	velocity = move_and_slide(velocity)

func dash(dashVelocity):
	self.get_node("Player_sounds")._play_song_from_name_with_playback("dash")
	isDashing = true
	canDash = false
	speed += dashVelocity
	$DashTimer.wait_time = dashTimer0 + nbDashPowerUp*dashlength_PowerUp
	$DashTimer.start()
	$DashRecoveryTimer.start()
	
func takeDamage(n,monster_position):
	#knockback
	inputON = false
	isDashing = true
	$RecoveryTimer.start()
	var delta_x = self.position.x - monster_position.x
	var delta_y = self.position.y - monster_position.y
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	if (norm > 0):
		velocity = Vector2(100*delta_x/norm,100*delta_y/norm)
	else:
		if (velocity.length() > 0):
			velocity = velocity.rotated(PI) #marche pas pour des ennemis qui viennent vers toi quand t'es immobile
	health -= 1
	$PlayerHealth.updateHealthUI()
	$Glitch.visible = true
	var catchPhrase = ["Ouch !","That hurts !","...","Shit !"]
	catchPhrase.shuffle()
	$PlayerDialog.speak(catchPhrase[0],1)
	if health <= 0:
		self.get_node("Player_sounds")._play_song_from_name_with_playback("death")
		$AnimationTree.get("parameters/playback").travel("DEATH")
	else:
		self.get_node("Player_sounds")._play_song_from_name_with_playback("hurt")
		#camerashake
		var camera = get_parent().get_node("Camera2D")
		camera.addShake(0.2)

func applyCollectible(thisCollectibleType,color):
	match thisCollectibleType:
		"Health":
			health +=1
			$PlayerHealth.updateHealthUI()
		"DashSpeed":
			powerUpStart(color)
			nbDashPowerUp += 1
		"BulletSize":
			powerUpStart(color)
			nbBulletPowerUp +=1
		"BulletSpeed":
			powerUpStart(color)
			nbBulletSpeedPowerUp +=1
		"MoveSpeed":
			powerUpStart(color)
			nbSpeedPowerUp +=1
		"CadenceUp":
			powerUpStart(color)
			nbCadencePowerUp +=1
		"Grenade":
			var s = shockwave.instance()
			self.add_child(s)
			for n in get_tree().get_nodes_in_group("Enemy"):
				n.health -= 2
				n.get_node("HealthUI").updateHealthUI()
			for n in get_tree().get_nodes_in_group("Bullet2"):
				n.queue_free()

func powerUpStart(color):
	$PowerUpUI.visible = true
	$PowerUpTimer.stop()
	$PowerUpTimer.start()
	for n in get_tree().get_nodes_in_group("Particles"):
		n.queue_free()
	var p = particles.instance()
	p.process_material.color = color
	add_child(p)
	var catchPhrase = ["Oh yeah !","This will be usefull","Why not ?","Let's see...","Hell yeah !","Hummm OK..","Sure !","Let's do this !"]
	catchPhrase.shuffle()
	$PlayerDialog.speak(catchPhrase[0],3)

func _on_PowerUpTimer_timeout():
	nbDashPowerUp = 0
	nbBulletPowerUp = 0
	nbBulletSpeedPowerUp = 0
	nbSpeedPowerUp = 0
	nbCadencePowerUp = 0
	for n in get_tree().get_nodes_in_group("Particles"):
		n.queue_free()
	
func _on_Cadence_timeout():
	$Cadence.stop()

func _on_RecoveryTimer_timeout():
	$RecoveryTimer.stop()
	if health > 0 :
		inputON=true
		isDashing = false
		$Glitch.visible = false
	else : 
		velocity = Vector2.ZERO
		isDashing = false

func _on_DashTimer_timeout():
	isDashing = false
	speed -= dashVelocity
	velocity = Vector2.ZERO
	$DashTimer.stop()
	var spl = splatch.instance()
	spl.position = self.position
	get_parent().add_child(spl)

func _on_DashRecoveryTimer_timeout():
	canDash = true
	$DashRecoveryTimer.stop()

func _on_GhostTrail_timeout():
	if isDashing:
		var ghostTrail = FadingSprite.instance()
		ghostTrail.PlayerSprite = $Sprite
		ghostTrail.transform = global_transform
		get_parent().add_child(ghostTrail)


func _on_FootstepTimer_timeout():
	$FootstepTimer.stop()
