class_name FloatingTextSpawner
extends Node2D

const FLOATING_TEXT = preload("res://UI/FloatingText.tscn")

export(Vector2) var direction = Vector2(0, -21)
export(float) var duration = 0.4
export(float) var spread = 0.0

func display(text_string: String):
	# TODO: cache and limit an amount of spawned label nodes
	var scene = FLOATING_TEXT.instance()
	add_child(scene)
	scene.display(text_string, duration, direction, spread)
