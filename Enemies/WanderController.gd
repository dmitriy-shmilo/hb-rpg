extends Node2D

export(float) var wander_range = 32.0

onready var start_position = global_position
onready var timer = $Timer
var target_position

func _ready():
	update_target_position()

func update_target_position():
	target_position = start_position + \
		Vector2(rand_range(-wander_range, wander_range), \
			rand_range(-wander_range, wander_range))
 
func start_wander_timer(duration):
	timer.start(duration)
 
func get_time_left():
	return timer.time_left

func _on_Timer_timeout():
	 update_target_position() 
