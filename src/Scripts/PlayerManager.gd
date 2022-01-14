extends KinematicBody2D

export var health = 10

export var speed = 200
export var friction = 0.01
export var acceleration = 0.1
var velocity = Vector2()

var Bullet = preload("res://Scenes/Bullet.tscn")

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
		$Cadence.wait_time = 0.2
		$Cadence.start()
		var b = Bullet.instance()
		get_parent().add_child(b)
		b.transform = self.global_transform
	

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_pressed("ui_mouseleft"):
		shoot()

func _on_Cadence_timeout():
	$Cadence.stop()
