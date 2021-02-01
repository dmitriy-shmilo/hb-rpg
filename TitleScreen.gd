extends Control

func _on_QuitButton_pressed():
	get_tree().quit(0)


func _on_NewGameButton_pressed():
	get_tree().change_scene("res://World.tscn")
