extends KinematicBody2D

var knockback = Vector2.ZERO
onready var stats = $Stats
const deathEffectScene = preload("res://Effects/EnemyDeathEffect.tscn")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Area2D_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage

func _on_Stats_no_health():
	var deathEffect = deathEffectScene.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
