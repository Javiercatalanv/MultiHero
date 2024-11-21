extends CharacterBody2D

var gravedad = 250

var velocidad := 120
var direccion := 0.0

var vidaPersonaje:int = 10

var maxSaltos:int = 2
var contSaltos:int  = 0
var fuerzaSalto = 250
var fuerzaSegSalto = 250


@onready var anim = $AnimationPlayer
@onready var sprite = $playerSprite

@export var ataqueNieve:PackedScene
@export var ataqueNormal:PackedScene
var puede_atacar = true
var puedeAtacarNormal = false

func _physics_process(delta):
	
	direccion = Input.get_axis("ui_left", "ui_right")
	velocity.y += gravedad * delta
	velocity.x = direccion * velocidad
	
	if direccion != 0 and is_on_floor():
		anim.play("correr")
	else:
		anim.play("idel")
	
	sprite.flip_h = direccion < 0 if direccion != 0 else sprite.flip_h
	jump()
	move_and_slide()
	gameOver()
func jump():
	if is_on_floor():
		contSaltos = 0

	if Input.is_action_just_pressed("jump") and contSaltos < maxSaltos:
		if contSaltos == 0 and is_on_floor():
			velocity.y -= fuerzaSalto
			contSaltos += 1
		elif contSaltos == 1:
			velocity.y = 0
			velocity.y -= fuerzaSegSalto
			contSaltos += 1
	if Input.is_action_pressed("jump") and !is_on_floor() and velocity.y > 0 :
		gravedad = 40
	else:
		gravedad = 250
func _input(event):
	if event.is_action_pressed("Ataque Nieve") and puede_atacar:
		ataqueEspecial()
	if event.is_action_pressed("Ataque normal"):
		ataqueNieveNormal()
func ataqueEspecial():
	var newNieve = ataqueNieve.instantiate()
	newNieve.position = self.position
	newNieve.salida = sprite.flip_h
	add_sibling(newNieve)
		
	newNieve.connect("ataque_desaparecido", Callable(self, "_on_ataque_desaparecido"))
		
	puede_atacar = false
func ataqueNieveNormal():
	if puedeAtacarNormal: return
	puedeAtacarNormal = true
	var nieveNormal = ataqueNormal.instantiate()
	nieveNormal.position = self.position
	nieveNormal.salida = sprite.flip_h
	nieveNormal.connect("destruirNieve", activarProyectil)
	add_sibling(nieveNormal)
func activarProyectil():
	puedeAtacarNormal = false
# Método llamado cuando el ataque desaparece
func _on_ataque_desaparecido():
	puede_atacar = true

func recibir_dano(dano):
	vidaPersonaje = vidaPersonaje - dano
	print(vidaPersonaje)

func gameOver():
	if vidaPersonaje <= 0:
		queue_free()
