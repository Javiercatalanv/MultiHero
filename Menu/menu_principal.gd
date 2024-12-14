extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Niveles/MundoTutorial.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
