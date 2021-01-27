class_name Hurtbox
extends Area2D

signal invincibility_started
signal invincibility_ended

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn")

onready var _timer: Timer = $Timer
onready var _shape: CollisionShape2D = $CollisionShape2D

var invincible = false setget _set_invincible

func _set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func create_hit_effect():
	var effect = HIT_EFFECT.instance()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)


func start_invincibility(duration: float):
	self.invincible = true
	_timer.start(duration)


func _on_Timer_timeout():
	self.invincible = false 


func _on_Hurtbox_invincibility_started():
	_shape.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	_shape.set_deferred("disabled", false)
