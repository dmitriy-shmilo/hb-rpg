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

var state = STATE_CHASE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var animatedSprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var enenmyHurtbox = $EnemyHurtbox
onready var softCollision = $SoftCollision

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		STATE_IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()

		STATE_WANDER:
			pass
		STATE_CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
			else:
				state = STATE_IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	animatedSprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = STATE_CHASE

func _on_Area2D_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage
	enenmyHurtbox.create_hit_effect()

func _on_Stats_no_health():
	var deathEffect = deathEffectScene.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
