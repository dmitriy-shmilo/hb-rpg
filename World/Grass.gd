extends Node2D

const grassEffectScene = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = grassEffectScene.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_Area2D_area_entered(_area):
	create_grass_effect()
	queue_free()
