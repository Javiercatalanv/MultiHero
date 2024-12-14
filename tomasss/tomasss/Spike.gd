extends Area2D


func _on_body_entered(body):
	if body.get_name() == "Player":
		body.recibir_dano(position.x)
		print("Nos hemos pinchado")
		
		get_tree().reload_current_scene()
