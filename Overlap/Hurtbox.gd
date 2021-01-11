extends Area2D

const hitEffectScene = preload("res://Effects/HitEffect.tscn")
export(bool) var show_hit_effect = true

func _on_Area2D_area_entered(area):
	if show_hit_effect:
		var effect = hitEffectScene.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
