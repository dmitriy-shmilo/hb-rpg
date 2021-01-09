extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 480
const FRICTION = 480

var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") \
		- Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") \
		- Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, \
			ACCELERATION * delta)
		animationPlayer.play("RunRight")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationPlayer.play("IdleRight")
	
	velocity = move_and_slide(velocity)