extends Node2D


func _ready():
	$AnimationPlayer.play("RotateSaw")
	




func _on_Area2D_body_entered(body):
	if body.is_in_group("jugador"):
		GestorVida.reducirVida(1) # Ejecuta función en el jugador (si existe)
