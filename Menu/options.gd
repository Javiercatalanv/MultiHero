extends Control

func _on_volume_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/audio_option.tscn")

func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/ControlesMenu.tscn")

func _on_back_pressed() -> void:
		get_tree().change_scene_to_file("res://Menu/MenuPrincipal.tscn")
