extends Area2D

@export var dano: int = 1  # Daño que la plataforma causa
@export var intervalo_dano: float = 1.0  # Intervalo de tiempo entre daños
@onready var timer = $Timer
var jugador_en_area = false  # Para saber si el jugador está dentro del área
var jugador = null  # Referencia al jugador

func _ready():
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = false

func _on_body_entered(body: Node2D):
	if body.is_in_group("jugador"):  # Verificar si el cuerpo es el jugador
		jugador_en_area = true  # El jugador está dentro del área
		jugador = body
		jugador.RecibirDano(dano) 
		timer.start()

func _on_body_exited(body: Node2D):
	if body.is_in_group("jugador"):
		jugador_en_area = false  # El jugador salió del área
		jugador = null  # Eliminar la referencia al jugador
		timer.stop()

func _on_timer_timeout():
	if jugador_en_area and jugador:
		jugador.RecibirDano(dano) 
