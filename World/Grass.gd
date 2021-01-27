class_name Grass
extends Node2D

const GRASS_EFFECT = preload("res://Effects/GrassEffect.tscn")


func _create_grass_effect():
	var grassEffect = GRASS_EFFECT.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_Area2D_area_entered(_area):
	_create_grass_effect()
	queue_free()
