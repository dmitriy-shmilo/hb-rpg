extends Area2D

const hitEffectScene = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

signal invincible_start
signal invincible_end

var invincible = false setget set_invincible

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincible_start")
	else:
		emit_signal("invincible_end")
 
func create_hit_effect():
	var effect = hitEffectScene.instance()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false 

func _on_Hurtbox_invincible_start():
	set_deferred("monitorable", false)

func _on_Hurtbox_invincible_end():
	set_deferred("monitorable", true)
