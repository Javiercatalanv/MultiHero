extends Node2D

# Referencia al nodo de la puerta
@onready var puerta = $ParallaxLayer/Area2D  # Asegúrate de que la ruta esté correcta

func _on_puerta_area_entered(area: Area2D) -> void:
	if area.name == "Player":  # Verifica que el área que entra sea el personaje
		get_tree().change_scene_to_file("res://MUNDO_2.tscn")
