extends Node2D

func _on_puerta_area_entered(area: Area2D) -> void:
	if area.name == "player":  # Verifica que el área que entra sea el personaje
		get_tree().change_scene_to_file("res://MUNDO_3.tscn")
