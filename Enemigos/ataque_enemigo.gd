extends Node2D

var velocidad = Vector2.ZERO  # La velocidad del proyectil

@export var velocidad_base: float = 300.0  # Velocidad base del proyectil

func _ready():
	# Si hay un temporizador configurado en la escena, se activa al inicio
	if $Timer:
		$Timer.start()

func set_direccion(direccion: Vector2) -> void:
	# Configura la velocidad basada en la dirección deseada
	velocidad = direccion.normalized() * velocidad_base

	# Actualiza el flip del sprite según la dirección horizontal
	if $Sprite2D:
		$Sprite2D.flip_h = direccion.x < 0

func _process(delta):
	# Mueve el proyectil en la dirección configurada
	position += velocidad * delta

	# Destruir si está fuera del viewport
	if not get_viewport_rect().has_point(global_position):
		destruir_proyectil()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		destruir_proyectil()
		GestorVida.reducirVida(1)

func _on_timer_timeout():
	destruir_proyectil()

func destruir_proyectil():
	queue_free()
