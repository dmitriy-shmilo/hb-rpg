class_name Player
extends KinematicBody2D

enum {
	STATE_MOVE,
	STATE_ROLL,
	STATE_ATTACK,
}

const MAX_SPEED = 80
const ACCELERATION = 480
const FRICTION = 480
const PLAYER_HURT_SOUND = preload("res://Player/PlayerHurtSound.tscn")

var _state = STATE_MOVE
var _velocity = Vector2.ZERO
var _roll_vector = Vector2.DOWN
var _stats = PlayerStats

onready var _animation_tree: AnimationTree = $AnimationTree
onready var _animation_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _sword_hitbox: SwordHitbox = $SwordHitboxPivot/SwordHitbox
onready var _player_hurtbox: Hurtbox = $PlayerHurtbox
onready var _blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	_animation_tree.active = true
	_sword_hitbox.knockback_vector = _roll_vector
	_stats.connect("health_changed", self, "_on_PlayerStats_health_changed")


func _process(delta):
	match _state:
		STATE_MOVE:
			move_state(delta)
		STATE_ROLL:
			roll_state()
		STATE_ATTACK:
			attack_state()


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") \
		- Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") \
		- Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		_roll_vector = input_vector
		_sword_hitbox.knockback_vector = _roll_vector
		_velocity = _velocity.move_toward(input_vector * MAX_SPEED, \
			ACCELERATION * delta)
		_animation_tree.set("parameters/Idle/blend_position", input_vector)
		_animation_tree.set("parameters/Run/blend_position", input_vector)
		_animation_tree.set("parameters/Attack/blend_position", input_vector)
		_animation_tree.set("parameters/Roll/blend_position", input_vector)
		_animation_state.travel("Run")
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		_animation_state.travel("Idle")
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		_state = STATE_ATTACK
	elif Input.is_action_just_pressed("roll"):
		_state = STATE_ROLL


func roll_state():
	_velocity = _roll_vector * MAX_SPEED * 1.5
	_animation_state.travel("Roll")
	move()


func attack_state():
	_velocity = Vector2.ZERO
	_animation_state.travel("Attack")


func attack_done():
	_state = STATE_MOVE


func roll_done():
	_velocity = _velocity * 0.8
	_state = STATE_MOVE


func move():
	_velocity = move_and_slide(_velocity)


func _on_PlayerHurtbox_area_entered(area):
	if _state == STATE_ROLL:
		return

	_stats.health -= area.damage
	_player_hurtbox.create_hit_effect()
	_player_hurtbox.start_invincibility(1.0)
	var sound = PLAYER_HURT_SOUND.instance()
	get_tree().current_scene.add_child(sound)


func _on_PlayerStats_health_changed(value):
	if value <= 0:
		queue_free()


func _on_PlayerHurtbox_invincibility_started():
	_blink_animation_player.play("Start")


func _on_PlayerHurtbox_invincibility_ended():
	_blink_animation_player.play("Stop")
