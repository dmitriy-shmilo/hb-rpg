extends KinematicBody2D

enum {
	STATE_IDLE,
	STATE_WANDER,
	STATE_CHASE
}

const deathEffectScene = preload("res://Effects/EnemyDeathEffect.tscn")

export var acceleration = 300
export var max_speed = 50
export var friction = 200
export(float) var wander_target_threshold = 5

var state = STATE_CHASE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var animatedSprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var enenmyHurtbox = $EnemyHurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	state = pick_random_state([STATE_IDLE, STATE_WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		STATE_IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
	
		STATE_WANDER:
			seek_player()
			if wanderController.get_time_left() == 0 \
				|| global_position.distance_to(wanderController.target_position) <= wander_target_threshold:
				update_wander()

			accelerate_towards(wanderController.target_position, delta)

		STATE_CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				accelerate_towards(player.global_position, delta)
			else:
				state = STATE_IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	animatedSprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func pick_random_state(state_list: Array):
	return state_list[randi() % state_list.size()]

func update_wander():
	state = pick_random_state([STATE_IDLE, STATE_WANDER])
	wanderController.start_wander_timer(rand_range(1, 3)) 

func accelerate_towards(point: Vector2, delta: float):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = STATE_CHASE

func _on_Area2D_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage
	enenmyHurtbox.create_hit_effect()
	enenmyHurtbox.start_invincibility(0.4)

func _on_Stats_no_health():
	var deathEffect = deathEffectScene.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()

func _on_EnemyHurtbox_invincible_start():
	blinkAnimationPlayer.play("Start")

func _on_EnemyHurtbox_invincible_end():
	blinkAnimationPlayer.play("Stop")
