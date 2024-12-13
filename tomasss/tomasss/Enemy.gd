#extends CharacterBody2D
#
#var gravity = 10
#var speed = 50
##var velocity = Vector2(0,0)
#var moving_left = true
#
#func _ready():
	#$AnimationPlayer.play("Walk")
	#
#func _process(delta):
	#move_character()
	#turn()
	#
#func move_character():
	#
	#velocity.y +=gravity
	#
	#if (moving_left):	
		#velocity.x = -speed
		#set_velocity(velocity)
		#set_up_direction(Vector2.UP)
		#move_and_slide()
		#velocity = velocity
	#
	#else:
		#velocity.x = speed
		#set_velocity(velocity)
		#set_up_direction(Vector2.UP)
		#move_and_slide()
		#velocity = velocity
#
#
#func _on_Area2D_body_entered(body):
	#if body.get_name() == "Player":	
		#body.recibir_dano(position.x)
		#pass
		#
#func turn():
	#if not $RayCast2D.is_colliding():
		#moving_left = !moving_left
		#scale.x = -scale.x
		#
extends CharacterBody2D

@export var dano: int = 1  # Daño que la plataforma causa
@export var intervalo_dano: float = 1.0  # Intervalo de tiempo entre daños

var jugador_en_area = false  # Para saber si el jugador está dentro del área
var jugador = null  # Referencia al jugador

var gravity = 10
var speed = 75
var moving_left = true
var vidas=3

func _ready():
	$AnimationPlayer.play("Walk")

func _process(delta):
	move_character()
	turn()

func move_character():
	# Aplicar gravedad
	velocity.y += gravity

	# Configurar la dirección del movimiento
	if moving_left:
		velocity.x = -speed
	else:
		velocity.x = speed

	# Mover al personaje
	move_and_slide()
	
	
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("jugador"):
		GestorVida.reducirVida(1) # Ejecuta función en el jugador (si existe)

func recibir_dano(dano):
	vidas -= dano
	print("Enemigo recibió daño, vida restante: ", vidas)

	if vidas <= 0:
		morir()
		
func _on_body_entered(body: Node2D):
	if body.is_in_group("jugador"):  # Verificar si el cuerpo es el jugador
		jugador_en_area = true  # El jugador está dentro del área
		jugador = body
		jugador.recibir_dano(dano) 

# Nueva función: morir
func morir():
	print("Enemigo murió")
	queue_free()  # Elimina al enemigo de la escena

#func _on_Area2D_body_entered(body):
	#if body.get_name() == "Player":
		#body.recibir_dano(position.x)
		#body.recibir_dano(position.y)

func turn():
	if $RayCast2D.is_colliding():   # Si hay colisión
		moving_left = !moving_left    # Cambiar dirección
		scale.x = -scale.x           # Invertir visualmente
