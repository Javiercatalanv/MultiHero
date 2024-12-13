extends Control


func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($"Audio/VBoxContainer/Audio Slider".value))
	get_tree().change_scene_to_file("res://Menu/Options.tscn")

func _input(event):
	if event.is_action_pressed("Pausa"):
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused
