extends CharacterBody2D

# Propiedades del enemigo
var gravedad = 250
var velocidad := 120
var direccion := 1.0  # Dirección inicial del movimiento (-1 para izquierda, 1 para derecha)
var jugador = null
var jugador_en_area = false

# Variables para disparo
@onready var timer = $Timer
@export var prefab_proyectil: PackedScene  # Escena del proyectil
@export var velocidad_proyectil: float = 300.0  # Velocidad del proyectil
@export var tiempo_entre_disparos: float = 1.5  # Tiempo entre disparos


var puede_disparar = true  # Control para limitar disparos consecutivos

func _ready() -> void:
	# Configuración inicial de la velocidad y graveda
	timer.one_shot = false
	timer.autostart = false
	
func _physics_process(delta):
	# Intentar disparar al jugador si está visible
	pass

func disparar(jugador: Node2D) -> void:
	# Inhabilitar disparos hasta que pase el tiempo establecido
	puede_disparar = false
	
	# Calcular la dirección hacia el jugador
	var direccion_proyectil = (jugador.global_position - global_position).normalized()
	
	# Instanciar el proyectil
	var proyectil = prefab_proyectil.instantiate()
	proyectil.global_position = global_position  # Posición inicial del proyectil
	
	# Añadir el proyectil al árbol de nodos
	get_tree().root.add_child(proyectil)
	
	# Configurar la dirección y velocidad del proyectil
	proyectil.set_direccion(direccion_proyectil)
	
	# Retrasar el siguiente disparo usando `await`

	

func localizar_jugador() -> Node2D:
	# Buscar al jugador en el grupo "jugador"
	var jugadores = get_tree().get_nodes_in_group("jugador")
	if jugadores.size() > 0:
		return jugadores[0]  # Tomar el primer jugador encontrado
	return null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("jugador")):
		jugador = localizar_jugador()
		jugador_en_area = true
		timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.is_in_group("jugador")):
		jugador = null
		jugador_en_area = false
		timer.stop()

func _on_timer_timeout():
	if(jugador_en_area and jugador):
		puede_disparar = true
		disparar(jugador)
