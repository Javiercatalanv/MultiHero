extends CharacterBody2D

var gravedad = 250

var velocidad := 120
var direccion := 0.0
var fuerzaSalto = 250

func _physics_process(delta):
	
	direccion = Input.get_axis("ui_left", "ui_right")
	velocity.y += gravedad * delta
	velocity.x = direccion * velocidad
	
	jump()
	move_and_slide()
	
func jump():

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= fuerzaSalto
