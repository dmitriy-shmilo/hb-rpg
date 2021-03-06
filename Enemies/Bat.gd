class_name Bat
extends KinematicBody2D

enum {
	STATE_IDLE,
	STATE_WANDER,
	STATE_CHASE,
}

const DEATH_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

export(float) var acceleration = 300
export(float) var max_speed = 50
export(float) var friction = 200
export(float) var wander_target_threshold = 5

var _state = STATE_CHASE
var _velocity = Vector2.ZERO
var _knockback = Vector2.ZERO

onready var _stats: Stats = $Stats
onready var _animated_sprite: AnimatedSprite = $AnimatedSprite
onready var _player_detection_zone: PlayerDetectionZone = $PlayerDetectionZone
onready var _enemy_hurtbox: Hurtbox = $Hurtbox
onready var _soft_collision: SoftCollision = $SoftCollision
onready var _wander_controller: WanderController = $WanderController
onready var _blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
onready var _emote: AnimatedSprite = $Emote

func _ready():
	_state = _pick_random_state([STATE_IDLE, STATE_WANDER])
	_play_emotion()


func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, 200 * delta)
	_knockback = move_and_slide(_knockback)
	
	match _state:
		STATE_IDLE:
			_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
			_seek_player()
			if _wander_controller.get_time_left() == 0:
				_update_wander()
	
		STATE_WANDER:
			_seek_player()
			if _wander_controller.get_time_left() == 0 \
				or global_position.distance_to(_wander_controller.target_position) <= wander_target_threshold:
				_update_wander()

			_accelerate_towards(_wander_controller.target_position, delta)

		STATE_CHASE:
			var player = _player_detection_zone.player
			
			if player != null:
				_accelerate_towards(player.global_position, delta)
			else:
				_state = STATE_IDLE
				_play_emotion("Confused") # TODO: introduce player lost state
	
	if _soft_collision.is_colliding():
		_velocity += _soft_collision.get_push_vector() * delta * 400
	
	_animated_sprite.flip_h = _velocity.x < 0
	_velocity = move_and_slide(_velocity)


func _pick_random_state(state_list: Array):
	return state_list[randi() % state_list.size()]


func _update_wander():
	_state = _pick_random_state([STATE_IDLE, STATE_WANDER])
	_play_emotion()
	_wander_controller.start_wander_timer(rand_range(1, 3))


func _accelerate_towards(point: Vector2, delta: float):
	var direction = global_position.direction_to(point)
	_velocity = _velocity.move_toward(direction * max_speed, acceleration * delta)


func _seek_player():
	if _player_detection_zone.can_see_player():
		_state = STATE_CHASE
		_play_emotion()


func _play_emotion(emotion: String = ""):
	if _emote.visible:
		return

	_emote.visible = true
	_emote.frame = 0
	if emotion != "":
		_emote.play(emotion)
		return

	match _state:
		STATE_CHASE:
			_emote.play("Angry")
		STATE_WANDER:
			_emote.play("Idle")
		STATE_IDLE:
			_emote.visible = false
			_emote.stop()


func _on_Area2D_area_entered(area: SwordHitbox):
	_knockback = area.knockback_vector * 120
	_stats.health -= area.damage
	_enemy_hurtbox.create_hit_effect()
	_enemy_hurtbox.start_invincibility(0.4)


func _on_Stats_health_changed(value: int):
	if value <= 0:
		var deathEffect = DEATH_EFFECT.instance()
		get_parent().add_child(deathEffect)
		deathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	_blink_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	_blink_animation_player.play("Stop")


func _on_Emote_animation_finished():
	_emote.visible = false
