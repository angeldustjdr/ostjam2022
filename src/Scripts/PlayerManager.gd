extends KinematicBody2D

export var health = 10

export var speed = 200
export var friction = 0.01
export var acceleration = 0.1
export var cadence = 0.2
export var dashVelocity = 500

onready var velocity = Vector2()

onready var Bullet = preload("res://Scenes/Bullet.tscn")
onready var FadingSprite = preload("res://Scenes/FadingSprite.tscn")

onready var inputON = true
onready var isDashing = false
onready var canDash = true

func get_input():
	var input = Vector2()
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	return input
	
func shoot():
	if $Cadence.is_stopped():
		$Cadence.wait_time = cadence
		$Cadence.start()
		var b = Bullet.instance()
		get_parent().add_child(b)
		b.transform = self.global_transform
	

func _physics_process(delta):
	# Deplacement
	if inputON:
		look_at(get_global_mouse_position())
		var direction = get_input()
		if direction.length() > 0:
			velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	#Shoot
	if Input.is_action_pressed("ui_mouseleft"):
		shoot()
	
	#Dash
	if Input.is_action_pressed("ui_select"):
		if !isDashing and canDash:
			dash(dashVelocity)

func dash(dashVelocity):
	isDashing = true
	canDash = false
	speed += dashVelocity
	$PlayerCollisionShape.disabled = true
	$DashTimer.start()
	$DashRecoveryTimer.start()
	
func takeDamage(n):
	#knockback
	inputON = false
	$RecoveryTimer.start()
	velocity = velocity.rotated(PI)
	health -= 1

func _on_Cadence_timeout():
	$Cadence.stop()

func _on_RecoveryTimer_timeout():
	inputON=true
	$RecoveryTimer.stop()

func _on_DashTimer_timeout():
	isDashing = false
	speed -= dashVelocity
	$PlayerCollisionShape.disabled = false
	$DashTimer.stop()

func _on_DashRecoveryTimer_timeout():
	canDash = true
	$DashRecoveryTimer.stop()

func _on_GhostTrail_timeout():
	if isDashing:
		var ghostTrail = FadingSprite.instance()
		ghostTrail.transform = global_transform
		get_parent().add_child(ghostTrail)
