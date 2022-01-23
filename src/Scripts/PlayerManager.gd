extends KinematicBody2D

export var health = 5

export var speed = 200
export var friction = 0.01
export var acceleration = 0.1
export var cadence = 0.2
export var dashVelocity = 200

onready var velocity = Vector2()
onready var keyboard = get_parent().keyboard

onready var Bullet = preload("res://Scenes/Bullet.tscn")
onready var FadingSprite = preload("res://Scenes/FadingSprite.tscn")

onready var inputON = true
onready var isDashing = false
onready var canDash = true

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
		$Cadence.wait_time = cadence
		$Cadence.start()
		var b = Bullet.instance()
		self.get_node("Player_sounds")._play_song_from_name_with_playback("shoot")
		b.direction = get_local_mouse_position()
		get_parent().add_child(b)
		b.transform = self.global_transform
		b.rotation = self.position.angle_to_point(b.direction)
	

func _physics_process(delta):
	# Deplacement
	if inputON:
		var direction = get_input()
		if direction.length() > 0:
			velocity = lerp(velocity, direction.normalized() * speed, acceleration)
			$AnimationTree.get("parameters/playback").travel("Walk")
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
			$AnimationTree.get("parameters/playback").travel("Idle")
		$AnimationTree.set("parameters/Idle/blend_position",get_local_mouse_position().normalized())
		$AnimationTree.set("parameters/Walk/blend_position",get_local_mouse_position().normalized())
	velocity = move_and_slide(velocity)
	
	#Shoot
	if Input.is_action_pressed("ui_mouseleft"):
		shoot()
	
	#Dash
	if Input.is_action_pressed("ui_select"):
		if !isDashing and canDash:
			dash(dashVelocity)

func dash(dashVelocity):
	self.get_node("Player_sounds")._play_song_from_name_with_playback("dash")
	isDashing = true
	canDash = false
	speed += dashVelocity
	$DashTimer.start()
	$DashRecoveryTimer.start()
	
func takeDamage(n,monster_position):
	#knockback
	inputON = false
	$RecoveryTimer.start()
	var delta_x = self.position.x - monster_position.x
	var delta_y = self.position.y - monster_position.y
	var norm = sqrt(delta_x*delta_x+delta_y*delta_y)
	if (norm > 0):
		velocity = Vector2(200*delta_x/norm,200*delta_y/norm)
	else:
		if (velocity.length() > 0):
			velocity = velocity.rotated(PI) #marche pas pour des ennemis qui viennent vers toi quand t'es immobile
	health -= 1
	$PlayerHealth.updateHealthUI()
	$Glitch.visible = true
	if health <= 0:
		self.get_node("Player_sounds")._play_song_from_name_with_playback("death")
		$AnimationTree.get("parameters/playback").travel("DEATH")
	else:
		self.get_node("Player_sounds")._play_song_from_name_with_playback("hurt")

func _on_Cadence_timeout():
	$Cadence.stop()

func _on_RecoveryTimer_timeout():
	$RecoveryTimer.stop()
	if health > 0 :
		inputON=true
		$Glitch.visible = false
	else : 
		velocity = Vector2.ZERO

func _on_DashTimer_timeout():
	isDashing = false
	speed -= dashVelocity
	$DashTimer.stop()

func _on_DashRecoveryTimer_timeout():
	canDash = true
	$DashRecoveryTimer.stop()

func _on_GhostTrail_timeout():
	if isDashing:
		var ghostTrail = FadingSprite.instance()
		ghostTrail.PlayerSprite = $Sprite
		ghostTrail.transform = global_transform
		get_parent().add_child(ghostTrail)
