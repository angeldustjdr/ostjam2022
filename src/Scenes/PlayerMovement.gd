extends KinematicBody2D


export var speed = 200

var velocity = Vector2.ZERO

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	look_at(get_global_mouse_position())
	get_input()
	velocity = move_and_slide(velocity)

