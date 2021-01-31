class_name Stats
extends Node

signal health_changed(value)
signal max_health_changed(value)

export(int) var max_health = 1 setget _set_max_health
export(int) var exp_worth = 1 # TODO: consider EnemyStats class
var health = max_health setget _set_health

func _ready():
	health = max_health


func reset():
	health = max_health


func _set_max_health(value):
	max_health = value
	health = max_health
	emit_signal("max_health_changed", value)


func _set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", value)
