extends Node2D

export(float) var min_spawn_delay = 20.0
export(float) var max_spawn_delay = 30.0

# TODO: create a base enemy class
onready var _enemy: Bat = $Enemy
onready var _stats: Stats = $Enemy/Stats
onready var _hurtbox: Hurtbox = $Enemy/Hurtbox

var _is_spawned = false

onready var _timer: Timer = $Timer

func _ready():
	var _err = _stats.connect("health_changed", self, "_on_Enemy_health_changed")


func _on_Timer_timeout():
	if _is_spawned:
		printerr("Spawner timed out when spawned entity was still active")
		return
	_hurtbox.reset()
	_stats.reset()
	add_child(_enemy)
	_enemy.global_position = global_position
	_is_spawned = true


func _on_Enemy_health_changed(value):
	if value == 0:
		call_deferred("remove_child", _enemy)
		_is_spawned = false
		_timer.start(rand_range(min_spawn_delay, max_spawn_delay))
