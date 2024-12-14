extends Control

func _input(event):
	if event.is_action_pressed("Pausa"):
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused


func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/ControlesPauseMenu.tscn")

func _on_salir_del_juego_pressed() -> void:
	get_tree().quit()
