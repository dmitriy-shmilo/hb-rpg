extends Node

signal health_changed(value)
signal max_health_changed(value)

export(int) var maxHealth = 1 setget _set_max_health
var health = maxHealth setget _set_health

func _ready():
	health = maxHealth


func _set_max_health(value):
	maxHealth = value
	health = maxHealth
	emit_signal("max_health_changed", value)


func _set_health(value):
	health = clamp(value, 0, maxHealth)
	emit_signal("health_changed", value)
