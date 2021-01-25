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
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")
onready var swordHitbox = $SwordHitboxPivot/SwordHitbox
onready var playerHurtbox = $PlayerHurtbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	stats.connect("no_health", self, "_on_PlayerStats_no_health")
	
func _process(delta):
	match state:
		STATE_MOVE:
			move_state(delta)
		STATE_ROLL:
			roll_state(delta)
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
		roll_vector = input_vector
		swordHitbox.knockback_vector = roll_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, \
			ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = STATE_ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = STATE_ROLL

func roll_state(delta):
	velocity = roll_vector * MAX_SPEED * 1.5
	animationState.travel("Roll")
	move()
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_done():
	state = STATE_MOVE

func roll_done():
	velocity = velocity * 0.8
	state = STATE_MOVE

func move():
	velocity = move_and_slide(velocity)

func _on_PlayerHurtbox_area_entered(area):
	stats.health -= 1
	playerHurtbox.create_hit_effect()
	playerHurtbox.start_invincibility(1.0)

func _on_PlayerStats_no_health():
	queue_free()
