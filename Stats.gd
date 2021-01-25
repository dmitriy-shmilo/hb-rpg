extends Node

export(int) var maxHealth = 1 setget set_max_health
var health = maxHealth setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	maxHealth = value
	health = maxHealth
	emit_signal("max_health_changed", value)

func set_health(value):
	health = clamp(value, 0, maxHealth)
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	health = maxHealth
