class_name FloatingText
extends Label

onready var _tween = $Tween

func display(text_string: String, duration: float, direction = Vector2.ZERO, spread = 0.0):
	text = text_string
	if spread > 0.0:
		direction = direction.rotated(rand_range(-spread, spread))
	set_deferred("rect_pivot_offset", rect_size / 2)
	
	_tween.interpolate_property(self, "rect_position", \
		rect_position, rect_position + direction, duration, \
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "modulate:a",
		1.0, 0, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()
	yield(_tween, "tween_all_completed")
	queue_free()
