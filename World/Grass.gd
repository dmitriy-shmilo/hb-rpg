extends Node2D

func create_grass_effect():
	var grassEffectScene = load("res://Effects/GrassEffect.tscn")
	var grassEffect = grassEffectScene.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position



func _on_Area2D_area_entered(area):
	create_grass_effect()
	queue_free()
