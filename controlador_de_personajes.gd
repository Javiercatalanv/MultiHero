extends Node2D

@export var escena_personaje_a: PackedScene
@export var escena_personaje_b: PackedScene

# Variable para controlar el personaje actual
var personaje_actual = null

var indice_personaje = 0
# Variable para determinar el personaje activo (inicia con PersonajeA)
var puedeCambiar = true

func _ready():
	# Instancia el primer personaje al inicio del juego
	cambiar_personaje()

func cambiar_personaje():
	# Guarda la posición actual del personaje
	var posicion = personaje_actual.position if personaje_actual else Vector2.ZERO  # Elimina el personaje actual
	if personaje_actual: 
		personaje_actual.queue_free()
	# Alterna entre personajes
	match indice_personaje:
		0:
			personaje_actual = escena_personaje_a.instantiate()
		1:
			personaje_actual = escena_personaje_b.instantiate()
	
	indice_personaje = (indice_personaje + 1) % 2

	personaje_actual.position = posicion
	add_child(personaje_actual)
	
	puedeCambiar = false
	$Timer.start()

func _input(event):
	# Cambia de personaje cuando se presiona una tecla específica
	if event.is_action_pressed("cambioPersonaje") and puedeCambiar and personaje_actual != null:
		cambiar_personaje()


func _on_timer_timeout():
	puedeCambiar = true
