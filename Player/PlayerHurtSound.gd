class_name PlayerHurtSound
extends AudioStreamPlayer

func _on_PlayerHurtSound_finished():
	queue_free()
