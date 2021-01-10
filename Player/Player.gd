extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 480
const FRICTION = 480

enum {
	STATE_MOVE,
	STATE_ROLL,
	STATE_ATTACK
}

var state = STATE_MOVE
var velocity = Vector2.ZERO
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	
func _process(delta):
	match state:
		STATE_MOVE:
			move_state(delta)
		STATE_ROLL:
			pass
		STATE_ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") \
		- Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") \
		- Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, \
			ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = STATE_ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_done():
	state = STATE_MOVE
