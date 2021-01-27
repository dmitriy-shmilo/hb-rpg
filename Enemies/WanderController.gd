extends Node2D

export(float) var wander_range = 32.0

var target_position

onready var _start_position = global_position
onready var _timer = $Timer

func _ready():
	_update_target_position()

 
func start_wander_timer(duration):
	_timer.start(duration)

 
func get_time_left():
	return _timer.time_left


func _on_Timer_timeout():
	 _update_target_position() 

func _update_target_position():
	target_position = _start_position + \
		Vector2(rand_range(-wander_range, wander_range), \
			rand_range(-wander_range, wander_range))
